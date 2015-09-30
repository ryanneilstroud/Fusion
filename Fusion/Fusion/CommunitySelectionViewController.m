//
//  CommunitySelectionViewController.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 28/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "CommunitySelectionViewController.h"
#import "CustomCell.h"
#import "SearchCustomCell.h"
#import "NewPublishArticleViewController.h"
#import "CommentCell.h"

@interface CommunitySelectionViewController ()
@property NSInteger segmentControlIndex;
@property NSMutableArray *array;

@property NSMutableArray *particpants;
@property NSMutableArray *particpantsIds;

@property int rowHeight;

@property NSObject *myCell;

@property (strong, nonatomic) NSMutableArray *names;
@property (strong, nonatomic) NSMutableArray *comments;
@property (strong, nonatomic) NSMutableArray *profilePics;

@property (strong, nonatomic) NSMutableArray *eventName;
@property (strong, nonatomic) NSMutableArray *dateAndTime;
@property (strong, nonatomic) NSMutableArray *location;
@property (strong, nonatomic) NSMutableArray *creatorImages;
@property (strong, nonatomic) NSMutableArray *creators;
@property (strong, nonatomic) NSMutableArray *objectId;

@property (strong, nonatomic) UIImageView *navBarHairlineImageView;

@property (nonatomic) CGRect screenRect;
@property (strong, nonatomic) UILabel *label;

@end

@implementation CommunitySelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
//    self.navigationController.navigationBar.clipsToBounds = YES;
    
    self.rowHeight = 75;
    
    self.eventName = [[NSMutableArray alloc] init];
    self.dateAndTime = [[NSMutableArray alloc] init];
    self.location = [[NSMutableArray alloc] init];
    self.creators = [[NSMutableArray alloc] init];
    self.creatorImages = [[NSMutableArray alloc] init];
    
    self.myCell = [[NSObject alloc] init];
    
    self.names = [[NSMutableArray alloc] init];
    self.comments = [[NSMutableArray alloc] init];
    self.profilePics = [[NSMutableArray alloc] init];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //seconds
    lpgr.delegate = self;
    [self.tableview addGestureRecognizer:lpgr];
    
    self.segmentControlIndex = 0;
    
    self.array = [[NSMutableArray alloc] init];
    
    self.particpants = [[NSMutableArray alloc] init];
    self.particpantsIds = [[NSMutableArray alloc] init];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,
                                    [UIFont fontWithName:@"Roboto-Light" size:20.0f], NSFontAttributeName,
                                    nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    [self getGroupData];
    
    self.screenRect = [[UIScreen mainScreen] bounds];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.screenRect.size.width, 50)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont fontWithName:@"Roboto-Light" size:16.0f];


}

-(void)viewDidAppear:(BOOL)animated {
    if (self.segmentControlIndex == 0) {
        NSLog(@"0");
        [self loadMessages];
    } else if (self.segmentControlIndex == 1) {
        NSLog(@"1");
        [self loadEvents];
    } else {
        NSLog(@"2");
        [self loadParticipants];
    }
}

-(void)getGroupData {
    
    PFQuery *query = [PFQuery queryWithClassName:@"CommunityGroup"];
    [query getObjectInBackgroundWithId:self.incomingGroupId block:^(PFObject *group, NSError *error){
        self.groupsName.text = group[@"name"];
        self.navigationItem.title = group[@"name"];
                
        PFFile *file = group[@"profilePic"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                // image can now be set on a UIImageView
                
                UISegmentedControl *statFilter = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[UIImage imageNamed:@"user_ffffff_16.png"],
                                                                                            [UIImage imageNamed:@"calendar_16.png"], [UIImage imageNamed:@"users_16.png"], nil]];
                [statFilter addTarget:self action:@selector(segmentControl:) forControlEvents:UIControlEventValueChanged];
                [statFilter sizeToFit];
                self.navigationItem.titleView = statFilter;
                
                UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
                v.image = image;
                v.layer.masksToBounds = YES;
                v.layer.cornerRadius = 20;
                
                UIBarButtonItem *flipButton = [[UIBarButtonItem alloc] initWithCustomView:v];
                self.navigationItem.rightBarButtonItem = flipButton;
                
                [self.navigationController.navigationBar pushNavigationItem:self.navigationItem animated:NO];
                
                
                self.groupsProfilePic.layer.cornerRadius = 50;
                self.groupsProfilePic.clipsToBounds = YES;
            } else {
                NSLog(@"error: %@", error);
            }
        }];
    }];
}

-(IBAction)segmentControl:(UISegmentedControl*)segmentControl {
    self.segmentControlIndex = segmentControl.selectedSegmentIndex;
    if (segmentControl.selectedSegmentIndex == 0) {
        NSLog(@"0");
        [self loadMessages];
    } else if (segmentControl.selectedSegmentIndex == 1) {
        NSLog(@"1");
        [self loadEvents];
    } else {
        NSLog(@"2");
        [self loadParticipants];
    }
}



-(void)loadMessages {
    [self.names removeAllObjects];
    [self.comments removeAllObjects];
    [self.profilePics removeAllObjects];
    
    self.rowHeight = 75;
    
    PFQuery *messages = [PFQuery queryWithClassName:@"CommunityGroupMessage"];
    [messages whereKey:@"groupId" equalTo:self.incomingGroupId];
    [messages orderByDescending:@"createdAt"];
    [messages findObjectsInBackgroundWithBlock:^(NSArray *messages, NSError *error){
        if (!error) {
            if ([messages count] < 1) {
                [self handleEmptyTableView:YES];
            } else {
                [self handleEmptyTableView:NO];
                for (int i = 0; i < [messages count]; i++) {
                    
                    PFQuery *user = [PFUser query];
                    NSLog(@"creator = %@", messages[i][@"creator"]);
                    [user getObjectInBackgroundWithId:[messages[i][@"creator"] objectId] block:^(PFObject *object, NSError *error){
                        
                        PFFile *file = object[@"profilePic"];
                        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                            if (!error) {
                                UIImage *image = [UIImage imageWithData:data];
                                
                                [self.comments addObject:messages[i][@"message"]];
                                [self.names addObject:object[@"fullName"]];
                                [self.profilePics addObject:image];
                                
                                if ([messages count] > 0) {
                                    [self.tableview reloadData];
//                                    self.tableview.hidden = NO;
//                                    [self.activityIndicator stopAnimating];
                                    
                                }
                            }
                        }];
                    }];
                }
            }
        }
    }];
}

-(void)loadParticipants {
    
    [self.particpants removeAllObjects];
    [self.particpantsIds removeAllObjects];
    
    self.rowHeight = 75;
    
    PFQuery *query = [PFQuery queryWithClassName:@"CommunityGroup"];
    [query orderByDescending:@"fullName"];
    [query getObjectInBackgroundWithId:self.incomingGroupId block:^(PFObject *community, NSError *error){
        if (!error) {
            if ([community[@"participants"] count] < 1) {
                [self handleEmptyTableView:YES];
            } else {
                [self handleEmptyTableView:NO];
                for (int i = 0; i < [community[@"participants"] count]; i++) {
                    
                    PFQuery *userQuery = [PFUser query];
                    [userQuery getObjectInBackgroundWithId:community[@"participants"][i] block:^(PFObject *user, NSError *error){
                        if (!error) {
                            NSLog(@"user name = %@", user[@"fullName"]);
                            [self.particpants addObject:user[@"fullName"]];
                            [self.particpantsIds addObject:user.objectId];
                            
                            [self.tableview reloadData];
                        }
                    }];
                }
            }
        }
    }];
}

- (void)handleEmptyTableView:(BOOL) emptyTableView {
    if (emptyTableView) {
        NSLog(@"yes");
        [self.view addSubview:self.label];
        self.tableview.hidden = YES;
        
        if (self.segmentControlIndex == 0) {
            self.label.text = @"no messages";
        } else if (self.segmentControlIndex == 1) {
            self.label.text = @"no events";
        } else {
            self.label.text = @"no participants";
        }
    } else {
        NSLog(@"no");
        [self.label removeFromSuperview];
        self.tableview.hidden = NO;
    }
}

-(void)loadEvents {
    [self.creators removeAllObjects];
    [self.creatorImages removeAllObjects];
    [self.eventName removeAllObjects];
    [self.location removeAllObjects];
    [self.dateAndTime removeAllObjects];
    
    self.rowHeight = 200;
    
    PFQuery *events = [PFQuery queryWithClassName:@"GroupEvent"];
    [events whereKey:@"groupId" equalTo:self.incomingGroupId];
    [events findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error){
        if (!error) {
            if (events.count < 1) {
                [self handleEmptyTableView:YES];
            } else {
                [self handleEmptyTableView:NO];
                for (int i = 0; i < events.count; i++) {
                    if (![self.dateAndTime containsObject:events[i][@"dateTime"]]) {
                        PFQuery *creatorQuery = [PFUser query];
                        [creatorQuery getObjectInBackgroundWithId:[events[i][@"creator"] objectId] block:^(PFObject *creator, NSError *error){
                            
                            NSLog(@"events: %@", events);
                            PFFile *file = creator[@"profilePic"];
                            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                                if (!error) {
                                    UIImage *image = [UIImage imageWithData:data];
                                    [self.creatorImages addObject:image];
                                    [self.creators addObject:creator[@"fullName"]];
                                    [self.eventName addObject:events[i][@"eventName"]];
                                    [self.location addObject:events[i][@"location"]];
                                    [self.dateAndTime addObject:events[i][@"dateTime"]];
                                    
                                    if ([self.creators count] > 0) {
                                        [self.tableview reloadData];
                                    }
                                }
                            }];
                        }];
                    }
                }
            }
        } else {
            NSLog(@"error = %@", [error userInfo]);
        }
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.rowHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segmentControlIndex == 0) {
        return [self.profilePics count];
    } else if (self.segmentControlIndex == 1) {
        NSLog(@"it's 1");
        return [self.creators count];
    } else if (self.segmentControlIndex == 2) {
        NSLog(@"it's 2");
        return [self.particpants count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmentControlIndex == 0) {
        static NSString *cellID = @"commentCell";
        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell){
            [tableView registerNib:[UINib nibWithNibName:@"CommunityMessageCell" bundle:nil] forCellReuseIdentifier:cellID];
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        }
        
        self.myCell = cell;
        
        return cell;
    } else if (self.segmentControlIndex == 1) {
        static NSString *cellID = @"eventFeedCell";
        SearchCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell){
            [tableView registerNib:[UINib nibWithNibName:@"CommunityEventsCell" bundle:nil] forCellReuseIdentifier:cellID];
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        }
        
        self.myCell = cell;
        
        return cell;
    } else if (self.segmentControlIndex == 2) {
        static NSString *cellID = @"searchResultFriendCell";
        SearchCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell){
            [tableView registerNib:[UINib nibWithNibName:@"SearchResultFriendCell" bundle:nil] forCellReuseIdentifier:cellID];
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        }
        
        self.myCell = cell;
        
        return cell;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SearchCustomCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.segmentControlIndex == 0) {
        [cell updateCellWithInfo:[self.names objectAtIndex:indexPath.row] :[self.comments objectAtIndex:indexPath.row] :[self.profilePics objectAtIndex:indexPath.row]];
    } else if (self.segmentControlIndex == 1) {
        [cell refreshCellWithEventInfo:[self.creators objectAtIndex:indexPath.row] :[self.eventName objectAtIndex:indexPath.row] :[self.dateAndTime objectAtIndex:indexPath.row] :[self.location objectAtIndex:indexPath.row] :[self.creatorImages objectAtIndex:indexPath.row] :[UIImage imageNamed:@"dinner_test.jpg"] :[UIImage imageNamed:@"maps3.jpg"]];
    } else if (self.segmentControlIndex == 2) {
        [cell refreshCellWithSearchResultsPerson:[self.particpants objectAtIndex:indexPath.row]];
    } else {
    
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    CGPoint p = [gestureRecognizer locationInView:self.tableview];
    
    NSIndexPath *indexPath = [self.tableview indexPathForRowAtPoint:p];
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"remove from group" otherButtonTitles:
                                nil];
        popup.tag = indexPath.row;
        [popup showInView:[UIApplication sharedApplication].keyWindow];
    }
    
//    if (indexPath == nil) {
//        NSLog(@"long press on table view but not on a row");
//    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"long press on table view at row ");
//    } else {
//        NSLog(@"gestureRecognizer.state");
//    }
}

- (void)deleteParticipant:(NSInteger )index {
    PFQuery *query = [PFQuery queryWithClassName:@"CommunityGroup"];
    [query getObjectInBackgroundWithId:self.incomingGroupId block:^(PFObject *community, NSError *error){
        if (!error) {
            if (![self.particpantsIds[index] isEqualToString:[community[@"admin"] objectId]]) {
                [community removeObjectsInArray:@[self.particpantsIds[index]] forKey:@"participants"];
                [community saveInBackgroundWithBlock:^(BOOL success, NSError *error){
                    if (success) {
                        [self loadParticipants];
                    }
                }];
            } else {
                [self createAlert:@"the admin cannot be removed"];
            }
        }
    }];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            NSLog(@"0");
            NSLog(@"popup = %ld", (long)popup.tag);
            [self deleteParticipant: popup.tag];
            break;
        case 1:
            NSLog(@"1");

            break;

        default:
            break;
    }
}

-(void)createAlert:(NSString *)_message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                    message:_message
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)createPost:(UIBarButtonItem *)sender {
    //postViewController
    
    PFQuery *currentUserQuery = [PFUser query];
    [currentUserQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error){
        if (!error) {
            object[@"tempStorage"] = [[NSMutableArray alloc] initWithObjects:@"CommunityGroupMessage", self.incomingGroupId, nil];
            [object saveInBackground];
        }
    }];
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    NewPublishArticleViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"friendsNewFeedSelection"];
//    vc.incomingClassName = @"CommunityGroupMessage";
//    vc.incomingCommunityGroupId = self.incomingGroupId;
    [self presentViewController:vc animated:YES completion:nil];
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarHairlineImageView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navBarHairlineImageView.hidden = NO;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

@end