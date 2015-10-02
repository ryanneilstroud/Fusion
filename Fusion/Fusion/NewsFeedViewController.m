//
//  NewsFeedViewController.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 26/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "FriendsPostSelectionViewController.h"
#import "EventSelectionViewController.h"
#import "CustomCell.h"

@interface NewsFeedViewController ()
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableArray *names;
@property (strong, nonatomic) NSMutableDictionary *sharedImages;
@property (strong, nonatomic) NSMutableArray *timestamps;
@property (strong, nonatomic) NSMutableArray *favoritedArray;

@property (strong, nonatomic) NSMutableArray *eventName;
@property (strong, nonatomic) NSMutableArray *dateAndTime;
@property (strong, nonatomic) NSMutableArray *location;
@property (strong, nonatomic) NSMutableArray *creatorImages;
@property (strong, nonatomic) NSMutableArray *creators;
@property (strong, nonatomic) NSMutableArray *rsvpArray;

@property (strong, nonatomic) NSMutableArray *messagesObjectId;
@property (strong, nonatomic) NSMutableArray *eventIds;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@property (nonatomic) CGRect screenRect;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UILabel *secondLabel;
@property (strong, nonatomic) UIImage *arrow;
@property (strong, nonatomic) UIImageView *arrowView;

@end

@implementation NewsFeedViewController
@synthesize segmentedControl;
@synthesize rowHeight;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.screenRect = [[UIScreen mainScreen] bounds];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.spinner.frame = CGRectMake(self.screenRect.size.width/2 - 100/2, self.screenRect.size.height/5, 100, 100);
        [self.view addSubview:self.spinner];
        
        if(segmentedControl.selectedSegmentIndex == 0) {
            [self getFriendsMessages];
        } else {
            [self getEvents];
        }
    } else {
        // show the signup or login screen
        NSString *vcIndentifer = @"logInScreen";
        [self navigateToStoryboard:vcIndentifer];
    }
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.screenRect.size.width, 50)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont fontWithName:@"Roboto-Light" size:16.0f];
    
    self.secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, self.screenRect.size.width, 50)];
    self.secondLabel.textAlignment = NSTextAlignmentCenter;
    self.secondLabel.font = [UIFont fontWithName:@"Roboto-Light" size:16.0f];
    
    self.arrow = [UIImage imageNamed:@"arrowright.png"];
    
    self.arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(self.screenRect.size.width - 80, 20, 100, 100)];
    self.arrowView.image = self.arrow;
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableview addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

    
//    self.messages = [[NSMutableArray alloc] init];
//    self.images = [[NSMutableArray alloc] init];
//    self.names = [[NSMutableArray alloc] init];
//    self.sharedImages = [[NSMutableDictionary alloc] init];
//    self.timestamps = [[NSMutableArray alloc] init];
    self.messagesObjectId = [[NSMutableArray alloc] init];
//    self.favoritedArray = [[NSMutableArray alloc] init];
    
    self.eventName = [[NSMutableArray alloc] init];
    self.dateAndTime = [[NSMutableArray alloc] init];
    self.location = [[NSMutableArray alloc] init];
    self.creators = [[NSMutableArray alloc] init];
    self.creatorImages = [[NSMutableArray alloc] init];
    self.eventIds = [[NSMutableArray alloc] init];
    self.rsvpArray = [[NSMutableArray alloc] init];

    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,
                                    [UIFont fontWithName:@"Roboto-Light" size:20.0f], NSFontAttributeName,
                                    nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    rowHeight = 120;
    
//    [self resetArrays];
}

- (void)refreshTable {
    [self resetArrays];
    [self.refreshControl endRefreshing];
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self getFriendsMessages];
    } else {
        [self getEvents];
    }
}

- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

-(void)viewDidAppear:(BOOL)animated {
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"current user");
        
        NSLog(@"compose");
        PFQuery *currentUserQuery = [PFUser query];
        [currentUserQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error){
            if (!error) {
                [object[@"tempStorage"] removeAllObjects];
                [object[@"tempStorage"] addObject: @"NewsFeedMessage"];
                [object[@"tempStorage"] addObject: @""];
                [object saveInBackground];
            }
        }];

        // do stuff with the user
        if (segmentedControl.selectedSegmentIndex == 0) {
            [self getFriendsMessages];
        } else {
            [self getEvents];
        }
    }
}

- (void)handleEmptyTableView:(BOOL) emptyTableView {
    if (emptyTableView) {
        NSLog(@"yes");
        [self.view addSubview:self.label];
        [self.view addSubview:self.secondLabel];
        [self.view addSubview:self.arrowView];
        self.tableview.hidden = YES;
        
        self.secondLabel.text = @"click the compose button to create your first";
        
        if (segmentedControl.selectedSegmentIndex == 0) {
            self.label.text = @"no messages";
        } else if (segmentedControl.selectedSegmentIndex == 1) {
            self.label.text = @"no events";
        }
        [self.spinner stopAnimating];
    } else {
        NSLog(@"no");
        [self.label removeFromSuperview];
        [self.secondLabel removeFromSuperview];
        [self.arrowView removeFromSuperview];
        self.tableview.hidden = NO;
        [self.spinner stopAnimating];
    }
}

-(void)getEvents {
    [self.spinner startAnimating];
    [self resetArrays];
    
    NSLog(@"names = %@", self.names);
    
    PFQuery *events = [PFQuery queryWithClassName:@"PublicEvent"];
    [events findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error){
        if (events.count < 1) {
            [self handleEmptyTableView:YES];
        } else {
            [self handleEmptyTableView:NO];
            for (int i = 0; i < events.count; i++) {
                if (![self.dateAndTime containsObject:events[i][@"dateTime"]]) {
                    PFQuery *creatorQuery = [PFUser query];
                    [creatorQuery getObjectInBackgroundWithId:[events[i][@"creator"] objectId] block:^(PFObject *creator, NSError *error){
                        
                        PFFile *file = creator[@"profilePic"];
                        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                            if (!error) {
                                if (![self.eventIds containsObject:[events[i] objectId]]) {
                                    
                                    NSLog(@"event id = %@", [events[i] objectId]);
                                    
                                    UIImage *image = [UIImage imageWithData:data];
                                    [self.creatorImages addObject:image];
                                    [self.creators addObject:creator[@"fullName"]];
                                    [self.eventName addObject:events[i][@"eventName"]];
                                    [self.location addObject:events[i][@"location"]];
                                    [self.dateAndTime addObject:events[i][@"dateTime"]];
                                    [self.eventIds addObject:[events[i] objectId]];
                                    
                                    if ([events[i][@"going"] containsObject:[[PFUser currentUser] objectId]]) {
                                        [self.rsvpArray addObject:@"0"];
                                        
                                    } else if ([events[i][@"maybe"] containsObject:[[PFUser currentUser] objectId]]) {
                                        [self.rsvpArray addObject:@"1"];
                                        
                                    } else if ([events[i][@"notGoing"] containsObject:[[PFUser currentUser] objectId]]) {
                                        [self.rsvpArray addObject:@"2"];
                                        
                                    } else {
                                        [self.rsvpArray addObject:@"3"];
                                    }
                                    
                                    if ([self.eventIds count] > 0) {
                                        [self.tableview reloadData];
                                        [self handleEmptyTableView:NO];
                                    }
                                }
                            }
                        }];
                    }];
                }
            }
        }
    }];
}

-(void)getFriendsMessages {
    [self.spinner startAnimating];
    [self resetArrays];
    
    PFQuery *userQuery = [PFQuery queryWithClassName:@"FriendsList"];
    [userQuery whereKey:@"owner" equalTo:[PFUser currentUser]];
    [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (!error) {
            
            NSLog(@"friendsList = %@", object[@"friends"]);
            if ([object[@"friends"] count] < 1) {
                [self handleEmptyTableView:YES];
            } else {
                [self handleEmptyTableView:NO];
                PFQuery *messagesQuery = [PFQuery queryWithClassName:@"NewsFeedMessage"];
                [messagesQuery orderByDescending:@"createdAt"];
                [messagesQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
                    if (!error) {
                        
                        
                        for (int i = 0; i < array.count; i++) {
                            
                            NSLog(@"array = %@", array);
                            
                            if ([object[@"friends"] containsObject:[array[i][@"creator"] objectId]]) {
                                if (![self.messagesObjectId containsObject:[array[i] objectId]]) {
                                    [self.messagesObjectId addObject:[array[i] objectId]];
                                    
                                    if (self.messagesObjectId.count > 0) {
                                        [self.tableview reloadData];
                                    } else {
                                        [self handleEmptyTableView:NO];
                                    }
                                }
                            }
                        }
                    }
                }];
            }
        } else {
            [self handleEmptyTableView:YES];
        }
    }];
}

//-(void)getFriendsMessages {
//    [self.spinner startAnimating];
//    [self resetArrays];
//    
//    __block NSArray *friendsArr = [[NSArray alloc] init];
//    
//    PFQuery *userQuery = [PFQuery queryWithClassName:@"FriendsList"];
//    [userQuery whereKey:@"owner" equalTo:[PFUser currentUser]];
//    [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
//        if (!error) {
//            if ([object[@"friends"] count] < 1) {
//                [self handleEmptyTableView:YES];
//            } else {
//                [self handleEmptyTableView:NO];
//                friendsArr = [[NSArray alloc] initWithArray:object[@"friends"]];
//                PFQuery *messages = [PFQuery queryWithClassName:@"NewsFeedMessage"];
//                [messages orderByDescending:@"createdAt"];
//                [messages findObjectsInBackgroundWithBlock:^(NSArray *messagesArr, NSError *error){
//                    if (!error) {
//                        
//                        for (int i = 0; i < messagesArr.count; i++) {
//                            
//                            [self.objectId addObject:[messagesArr[i] objectId]];
//
//                            PFQuery *userQuery = [PFUser query];
//                            [userQuery getObjectInBackgroundWithId:[messagesArr[i][@"creator"] objectId] block:^(PFObject *user, NSError *error){
//                                
//                                PFFile *file = user[@"profilePic"];
//                                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//                                    if (!error) {
//                                        
//                                        if ([friendsArr containsObject:[messagesArr[i][@"creator"] objectId]]) {
//                                            if (![self.messages containsObject:messagesArr[i][@"message"]]) {
//                                                UIImage *currentUserImage = [UIImage imageWithData:data];
//                                                
//                                                [self.messages addObject:messagesArr[i][@"message"]];
//                                                [self.names addObject:user[@"fullName"]];
//                                                [self.images addObject:currentUserImage];
//                                                [self.timestamps addObject:[messagesArr[i] createdAt]];
//                                                [self.objectId addObject:[messagesArr[i] objectId]];
//                                                
//                                                if ([messagesArr[i][@"favorited"] containsObject:[[PFUser currentUser] objectId]]) {
//                                                    [self.favoritedArray addObject:@"1"];
//                                                } else {
//                                                    [self.favoritedArray addObject:@"0"];
//                                                    
//                                                }
//                                                
//                                                PFFile *file = messagesArr[i][@"photo"];
//                                                [file getDataInBackgroundWithBlock:^(NSData *moreData, NSError *error) {
//                                                    if (!error) {
//                                                        UIImage *image = [UIImage imageWithData:moreData];
//                                                        [self.sharedImages setObject:image forKey:[NSString stringWithFormat:@"%d", i]];
//                                                        
//                                                    } else {
//                                                        NSLog(@"error: %@", error);
//                                                    }
//                                                }];
//                                                
//                                                if ([self.messages count] > 0) {
//                                                    [self.tableview reloadData];
//                                                    [self handleEmptyTableView:NO];
//                                                }
//                                            }
//                                            
//                                        } else {
//                                            if ([self.messages count] < 1) {
//                                                [self handleEmptyTableView:YES];
//                                            }
//                                        }
//                                        
//                                    }
//                                }];
//                            }];
//                        }
//                        
//                    }
//                }];
//            }
//        } else {
//            [self handleEmptyTableView:YES];
//        }
//    }];
//}

-(void)resetArrays {
//    [self.messages removeAllObjects];
//    [self.images removeAllObjects];
//    [self.names removeAllObjects];
//    [self.sharedImages removeAllObjects];
//    [self.timestamps removeAllObjects];
//    
    [self.creators removeAllObjects];
    [self.creatorImages removeAllObjects];
    [self.eventName removeAllObjects];
    [self.location removeAllObjects];
    [self.dateAndTime removeAllObjects];
    [self.eventIds removeAllObjects];
    [self.rsvpArray removeAllObjects];
    
    [self.messagesObjectId removeAllObjects];
//    [self.favoritedArray removeAllObjects];
    
}

-(IBAction)segmentedControlAction:(UISegmentedControl *)sender {
//    [self.tableview reloadData];
    [self resetArrays];
    if (segmentedControl.selectedSegmentIndex == 0) {
        NSLog(@"0");
        [self getFriendsMessages];
    } else {
        NSLog(@"1");
        [self getEvents];
    }
}

- (void)navigateToStoryboard: (NSString *)_vcIndentifer {
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:_vcIndentifer];
    [self presentViewController:vc animated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(segmentedControl.selectedSegmentIndex == 0) {
//        return [self.names count];
        return [self.messagesObjectId count];
    } else {
        return [self.eventName count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(segmentedControl.selectedSegmentIndex == 0) {
        if ([self.sharedImages objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]] != nil) {
            return rowHeight + 400;
        } else {
            return rowHeight + 30;
        }
    } else {
        return 200;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* segmentedCell;
    NSString* nibName;
    
    if(segmentedControl.selectedSegmentIndex == 0) {
        segmentedCell = @"newsFeedCell";
        nibName = @"MyCustomCell";
        rowHeight = 100;
//        if ([self.sharedImages objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]] != nil) {
//            segmentedCell = @"newsFeedCellWithImage";
//            nibName = @"MyCustomCellWithImage";
//        } else {
//            segmentedCell = @"newsFeedCell";
//            nibName = @"MyCustomCell";
//        }
//        NSAttributedString *atrStr = [[NSAttributedString alloc] initWithString:[self.messages objectAtIndex:indexPath.row]];
//        if (![[self.messages objectAtIndex:indexPath.row] isEqualToString:@""]) {
//            rowHeight = [self textViewHeightForAttributedText:atrStr andWidth:self.view.frame.size.width - 200];
//        } else {
//            rowHeight = 100;
//        }
        
    } else if(segmentedControl.selectedSegmentIndex == 1) {
        segmentedCell = @"eventFeedCell";
        nibName = @"EventsFeed";
        rowHeight = 200;
    }
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:segmentedCell];

    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:segmentedCell];
        cell = [tableView dequeueReusableCellWithIdentifier:segmentedCell];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(CustomCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(segmentedControl.selectedSegmentIndex == 0) {
        
        [cell refreshCellWithMessage:[self.messagesObjectId objectAtIndex:indexPath.row]];
//        if ([self.sharedImages objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]] != nil) {
//            [cell refreshCellWithImageInfo:[self.names objectAtIndex:indexPath.row]
//                               captionText:[self.messages objectAtIndex:indexPath.row]
//                              imagePicture:[self.images objectAtIndex:indexPath.row]
//                                          :[self.sharedImages objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]]
//                                          :[self.timestamps objectAtIndex:indexPath.row]
//                                          :[self.objectId objectAtIndex:indexPath.row]
//                                          :[self.favoritedArray objectAtIndex:indexPath.row]];
//        } else {
//            [cell refreshCellWithInfo:[self.names objectAtIndex:indexPath.row]
//                          captionText:[self.messages objectAtIndex:indexPath.row]
//                         imagePicture:[self.images objectAtIndex:indexPath.row]
//                                     :[self.timestamps objectAtIndex:indexPath.row]
//                                     :[self.objectId objectAtIndex:indexPath.row]
//                                     :[self.favoritedArray objectAtIndex:indexPath.row]];
//        }

    } else if(segmentedControl.selectedSegmentIndex == 1) {
        [cell refreshCellWithEventInfo:[self.creators objectAtIndex:indexPath.row]
                                      :[self.eventName objectAtIndex:indexPath.row]
                                      :[self.dateAndTime objectAtIndex:indexPath.row]
                                      :[self.location objectAtIndex:indexPath.row]
                                      :[self.creatorImages objectAtIndex:indexPath.row]
                                      :[UIImage imageNamed:@"dinner_test.jpg"]
                                      :[UIImage imageNamed:@"maps3.jpg"]
                                      :[self.eventIds objectAtIndex:indexPath.row]
                                      :[self.rsvpArray objectAtIndex:indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (segmentedControl.selectedSegmentIndex == 0) {
        
        NSLog(@"id = %@", [self.messagesObjectId objectAtIndex:indexPath.row]);
        FriendsPostSelectionViewController *vc = [[FriendsPostSelectionViewController alloc] initWithNibName:@"FriendsPostSelection" bundle:nil];
        vc.incomingPostId = [self.messagesObjectId objectAtIndex:indexPath.row];
//        vc.incomingName = [self.names objectAtIndex:indexPath.row];
//        vc.incomingMessage = [self.messages objectAtIndex:indexPath.row];
//        vc.incomingProfilePic = [self.images objectAtIndex:indexPath.row];
//        vc.incomingSharedImages = [self.sharedImages objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        EventSelectionViewController *vc = [[EventSelectionViewController alloc] initWithNibName:@"EventSelectionView" bundle:nil];
        vc.incomingProfilePic = [self.creatorImages objectAtIndex:indexPath.row];
        vc.incomingEventName = [self.eventName objectAtIndex:indexPath.row];
        vc.incomingDateAndTime = [self.dateAndTime objectAtIndex:indexPath.row];
        vc.incomingPlace = [self.location objectAtIndex:indexPath.row];
        vc.incomingEventId = [self.eventIds objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewDidLayoutSubviews {
    self.tableview.frame = self.view.bounds;
}

@end
