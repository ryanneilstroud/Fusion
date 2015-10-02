//
//  FriendsPostSelection.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 27/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "FriendsPostSelectionViewController.h"
#import "CommentCell.h"

@interface FriendsPostSelectionViewController ()
@property (strong, nonatomic) NSMutableArray *names;
@property (strong, nonatomic) NSMutableArray *comments;
@property (strong, nonatomic) NSMutableArray *profilePics;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) UILabel *infoLabel;

@end

@implementation FriendsPostSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.navigationItem.title = @"comments";
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 100)];
    
    self.commentTextField.frame = CGRectMake(self.commentTextField.frame.origin.x,
                                             self.commentTextField.frame.origin.y,
                                             screenRect.size.width - 75, self.commentTextField.frame.size.height);
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(screenRect.size.width/2 - 50, screenRect.size.height/3 - 50, 100, 100)];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.activityIndicator];
    
    self.commentToolbar.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.commentToolbar.frame = CGRectMake(self.commentToolbar.frame.origin.x,
                                           self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.commentToolbar.frame.size.height,
                                           self.commentToolbar.frame.size.width,
                                           self.commentToolbar.frame.size.height);
    
    [self.commentTextField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    self.names = [[NSMutableArray alloc] init];
    self.comments = [[NSMutableArray alloc] init];
    self.profilePics = [[NSMutableArray alloc] init];
    
    NSLog(@"post id = %@", self.incomingPostId);
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,
                                    [UIFont fontWithName:@"Roboto-Light" size:20.0f], NSFontAttributeName,
                                    nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UISwipeGestureRecognizer* swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:swipeDownGestureRecognizer];
    
    [self loadComments];
}

- (void)handleSwipeDownFrom:(UIGestureRecognizer*)recognizer {
    [self.view endEditing:YES];
}

-(void)resetArrays {
    [self.names removeAllObjects];
    [self.comments removeAllObjects];
    [self.profilePics removeAllObjects];
}

- (IBAction)composeComment:(UIBarButtonItem *)sender {
    [self resetArrays];
    
    PFObject *comment = [PFObject objectWithClassName:@"MessageComment"];
    comment[@"message"] = self.commentTextField.text;
    comment[@"creator"] = [PFUser currentUser];
    
    comment[@"parent"] = self.incomingPostId;
    [comment saveInBackgroundWithBlock:^(BOOL success, NSError *error){
        if (!error) {
            [self loadComments];
            self.commentTextField.text = @"";
            [self.view endEditing:YES];
            [self.infoLabel removeFromSuperview];
        }
    }];
}

-(void)loadComments {
    self.tableview.hidden = YES;
    [self.activityIndicator startAnimating];
    
    PFQuery *query = [PFQuery queryWithClassName:@"MessageComment"];
    [query whereKey:@"parent" equalTo:self.incomingPostId];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error){
        if (!error) {
            if ([comments count] == 0) {
                self.tableview.hidden = YES;
                self.infoLabel.text = @"no comments";
                self.infoLabel.textAlignment = NSTextAlignmentCenter;
                self.infoLabel.textColor = [UIColor grayColor];
                [self.view addSubview:self.infoLabel];
                
                [self.activityIndicator stopAnimating];
                
            } else {
                for (int i = 0; i < [comments count]; i++) {
                    
                    PFQuery *user = [PFUser query];
                    NSLog(@"creator = %@", comments[i][@"creator"]);
                    [user getObjectInBackgroundWithId:[comments[i][@"creator"] objectId] block:^(PFObject *object, NSError *error){
                        
                        PFFile *file = object[@"profilePic"];
                        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                            if (!error) {
                                UIImage *image = [UIImage imageWithData:data];
                                
                                [self.comments addObject:comments[i][@"message"]];
                                [self.names addObject:object[@"fullName"]];
                                [self.profilePics addObject:image];
                                
                                if ([comments count] > 0) {
                                    [self.tableview reloadData];
                                    self.tableview.hidden = NO;
                                    [self.activityIndicator stopAnimating];

                                }
                            }
                        }];
                    }];
                }
            }
        }
    }];
}

- (void)keyboardWillShow:(NSNotification *) notification {
    int keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    
    self.commentToolbar.frame = CGRectMake(self.commentToolbar.frame.origin.x,
                                           self.view.frame.size.height - keyboardHeight - self.commentToolbar.frame.size.height,
                                           self.commentToolbar.frame.size.width,
                                           self.commentToolbar.frame.size.height);
}

- (void)keyboardWillHide:(NSNotification *) notification {
    self.commentToolbar.frame = CGRectMake(self.commentToolbar.frame.origin.x,
                                           self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.commentToolbar.frame.size.height,
                                           self.commentToolbar.frame.size.width,
                                           self.commentToolbar.frame.size.height);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.comments count] > 0) {
        return [self.comments count];
    } else {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"commentCell";
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell){
        [tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(CommentCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.comments count] > 0) {
        [cell updateCellWithInfo:[self.names objectAtIndex:indexPath.row] :[self.comments objectAtIndex:indexPath.row] :[self.profilePics objectAtIndex:indexPath.row]];
    }
}

- (IBAction)favoriteButton:(UIButton *)sender {
}

- (IBAction)commentButton:(UIButton *)sender {
}

@end
