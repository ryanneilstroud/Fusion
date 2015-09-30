//
//  CommunityViewController.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 26/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "CommunityViewController.h"
#import "CommunitySelectionViewController.h"
#import "CommunityCell.h"
#import "PersonDetailViewController.h"

@interface CommunityViewController ()
@property (strong, nonatomic) NSMutableArray *names;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableArray *churches;

@property (strong, nonatomic) NSMutableArray *communityNames;
@property (strong, nonatomic) NSMutableArray *communityImages;
@property (strong, nonatomic) NSMutableArray *communityChurches;

@property (strong, nonatomic) NSMutableArray *groupIds;
@property (strong, nonatomic) NSMutableArray *personIds;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic) CGRect screenRect;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UILabel *secondLabel;
@property (strong, nonatomic) UIImage *arrow;
@property (strong, nonatomic) UIImageView *arrowView;

@end

@implementation CommunityViewController
@synthesize segmentedControl;
@synthesize rowHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");

    
    self.screenRect = [[UIScreen mainScreen] bounds];
    
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

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(screenRect.size.width/2 - 50, screenRect.size.height/3 - 50, 100, 100)];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    self.names = [[NSMutableArray alloc] init];
    self.images = [[NSMutableArray alloc] init];
    self.churches = [[NSMutableArray alloc] init];
    
    self.communityNames = [[NSMutableArray alloc] init];
    self.communityImages = [[NSMutableArray alloc] init];
    self.communityChurches = [[NSMutableArray alloc] init];
    
    self.groupIds = [[NSMutableArray alloc] init];
    self.personIds = [[NSMutableArray alloc] init];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,
                                    [UIFont fontWithName:@"Roboto-Light" size:20.0f], NSFontAttributeName,
                                    nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    
    rowHeight = 150;
        
//    if(segmentedControl.selectedSegmentIndex == 0) {
//        if ([self.communityImages count] == 0) {
//            
//        }
//        [self loadCommunityData];
//    } else {
//        if ([self.images count] == 0) {
//        }
//        [self loadFriendData];
//    }
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"hello!");
    [self resetArrays];
    
//    [self refreshControl];
    
    if(segmentedControl.selectedSegmentIndex == 0) {
        NSLog(@"hello?");
        [self loadCommunityData];
    } else {

        [self loadFriendData];
    }
    //takes to long to save and retrieve
    
}

- (void)refreshTable {
    [self resetArrays];
    if(segmentedControl.selectedSegmentIndex == 0) {
        [self loadCommunityData];
    } else {
        [self loadFriendData];
    }
    [self.refreshControl endRefreshing];
}

- (void)resetArrays {
    [self.names removeAllObjects];
    [self.images removeAllObjects];
    [self.churches removeAllObjects];
    
    [self.communityNames removeAllObjects];
    [self.communityImages removeAllObjects];
    [self.communityChurches removeAllObjects];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(segmentedControl.selectedSegmentIndex == 0) {
        return [self.communityNames count];
    } else {
        return [self.names count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
}

- (void)handleEmptyTableView:(BOOL) emptyTableView {
    if (emptyTableView) {
        [self.view addSubview:self.label];
        [self.view addSubview:self.secondLabel];
        [self.view addSubview:self.arrowView];
        self.tableview.hidden = YES;
        
        self.secondLabel.text = @"look here!";
        
        if (segmentedControl.selectedSegmentIndex == 0) {
            self.label.text = @"no groups";
        } else {
            self.label.text = @"no friends";
        }
    } else {
        [self.label removeFromSuperview];
        [self.secondLabel removeFromSuperview];
        [self.arrowView removeFromSuperview];
        self.tableview.hidden = NO;
    }
}

- (void)loadFriendData {
    [self resetArrays];
    
    PFQuery *query = [PFQuery queryWithClassName:@"FriendsList"];
    [query whereKey:@"owner" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (!error) {

            if ([object[@"friends"] count] < 2) {
                [self handleEmptyTableView:YES];
            } else {
                [self handleEmptyTableView:NO];

                for (int i = 0; i < [object[@"friends"] count]; i++) {
                    
                    if (![object[@"friends"][i] isEqualToString:[[PFUser currentUser] objectId]]) {
                        PFQuery *userQuery = [PFUser query];
                        [userQuery getObjectInBackgroundWithId:object[@"friends"][i] block:^(PFObject *object, NSError *error){
                            if (!error) {
                                NSLog(@"friend = %@", object);
                                
                                [self.names addObject:object[@"fullName"]];
                                [self.churches addObject:object[@"churchName"]];
                                [self.personIds addObject:[object objectId]];
                                
                                PFFile *file = object[@"profilePic"];
                                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                                    if (!error) {
                                        UIImage *image = [UIImage imageWithData:data];
                                        [self.images addObject:image];
                                        
                                        if ([self.names count] > 0) {
                                            [self.tableview reloadData];
                                        }
                                    }
                                }];
                            }
                        }];
                    }
                    
                }
            }

            }
    }];
}


- (void)loadCommunityData {

    [self resetArrays];
    
    PFQuery *query = [PFQuery queryWithClassName:@"CommunityGroup"];
    [query whereKey:@"participants" equalTo:[[PFUser currentUser] objectId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        if (!error) {
        
            if ([array count] < 1) {
                [self handleEmptyTableView:YES];
            } else {
                [self handleEmptyTableView:NO];
                for (int i = 0; i < array.count; i++) {
                    [self.communityNames addObject:array[i][@"name"]];
                    [self.communityChurches addObject:array[i][@"church"]];
                    [self.groupIds addObject:[array[i] objectId]];
                    
                    PFFile *file = array[i][@"profilePic"];
                    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                        if (!error) {
                            UIImage *image = [UIImage imageWithData:data];
                            [self.communityImages addObject:image];
                            
                            if ([self.communityNames count] > 0) {
                                [self.tableview reloadData];
                            }
                        }
                    }];
                }

            }
            
        }
    }];
}

//- (void)loadCommunityData {
//    PFUser *currentUser = [PFUser currentUser];
//    
//    PFQuery *communityRequest = [PFQuery queryWithClassName:@"CommunityRequest"];
//    [communityRequest whereKey:@"status" equalTo:@"accepted"];
//    [communityRequest findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            NSLog(@"objects = %@", objects);
//                for (int i = 0; i<objects.count; i++) {
//                    if ([objects[i][@"sender"] isEqualToString:currentUser.objectId]) {
//                        
//                        PFQuery *communityQuery = [PFQuery queryWithClassName:@"CommunityGroup"];
//                        [communityQuery getObjectInBackgroundWithId:objects[i][@"receiver"] block:^(PFObject *user, NSError *error) {
//                            if (!error) {
//                                [self.communityNames addObject:user[@"name"]];
//                                [self.communityChurches addObject:user[@"church"]];
//                                [self.groupIds addObject:user.objectId];
//                                
//                                PFFile *file = user[@"profilePic"];
//                                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//                                    if (!error) {
//                                        UIImage *image = [UIImage imageWithData:data];
//                                        // image can now be set on a UIImageView
//                                        [self.communityImages addObject:image];
//                                        if ([self.communityNames count] > 0) {
//                                            [self.tableview reloadData];
//                                        }
//                                    }
//                                }];
//                            } else {
//                                NSLog(@"error: %@", error);
//                            }
//                        }];
//                        
//                    } else if ([objects[i][@"receiver"] isEqualToString:currentUser.objectId]) {
//                        NSLog(@"I received that");
//                        
//                        PFQuery *communityQuery = [PFQuery queryWithClassName:@"CommunityGroup"];
//                        [communityQuery getObjectInBackgroundWithId:objects[i][@"sender"] block:^(PFObject *user, NSError *error) {
//                            if (!error) {
//                                [self.communityNames addObject:user[@"name"]];
//                                [self.communityChurches addObject:user[@"church"]];
//                                [self.groupIds addObject:user.objectId];
//                                
//                                PFFile *file = user[@"profilePic"];
//                                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//                                    if (!error) {
//                                        UIImage *image = [UIImage imageWithData:data];
//                                        // image can now be set on a UIImageView
//                                        [self.communityImages addObject:image];
//                                        if ([self.communityNames count] > 0) {
//                                            [self.tableview reloadData];
//                                            [self.activityIndicator stopAnimating];
//                                        }
//                                    }
//                                }];
//                            } else {
//                                NSLog(@"error: %@", error);
//                            }
//                        }];
//                    } else {
//                            NSLog(@"no groups");
//                        self.tableview.hidden = YES;
//                        self.infoLabel.hidden = NO;
//                            self.infoLabel.text = @"you have no groups";
//                            self.infoLabel.textAlignment = NSTextAlignmentCenter;
//                            self.infoLabel.textColor = [UIColor grayColor];
//                            [self.view addSubview:self.infoLabel];
//                            [self.activityIndicator stopAnimating];
//                    }
//                }
//        } else {
//            NSLog(@"error: %@", error);
//        }
//    }];
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"cellForRowAtIndexPath called");
    
    NSString* segmentedCell;
    NSString* nibName;
    
    if(segmentedControl.selectedSegmentIndex == 0) {
        segmentedCell = @"communityGroupCell";
        nibName = @"CommunityGroupCell";
        rowHeight = 125;
        
    } else {
        segmentedCell = @"friendCell";
        nibName = @"FriendCell";
        rowHeight = 75;
    }
    
    CommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:segmentedCell];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:segmentedCell];
        cell = [tableView dequeueReusableCellWithIdentifier:segmentedCell];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(CommunityCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"forRowAtIndexPath called");
    
    if(segmentedControl.selectedSegmentIndex == 0) {
        if (indexPath.row >= [self.communityImages count]) {
        
        } else {
            [cell refreshCellWithCommunityGroupInfo:[self.communityNames objectAtIndex:indexPath.row] :[self.communityChurches objectAtIndex:indexPath.row] :[self.communityImages objectAtIndex:indexPath.row]];
        }
    } else if(segmentedControl.selectedSegmentIndex == 1) {
        NSLog(@"indexPath.row = %@", [self.names objectAtIndex:indexPath.row]);
        if (indexPath.row >= [self.images count]) {
        
        } else {
            [cell refreshCellWithUserFriendInfo:[self.names objectAtIndex:indexPath.row] :[self.churches objectAtIndex:indexPath.row]:[self.images objectAtIndex:indexPath.row]];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (segmentedControl.selectedSegmentIndex == 0) {
        
        CommunitySelectionViewController *vc = [[CommunitySelectionViewController alloc] initWithNibName:@"CommunitySelection" bundle:nil];
        vc.incomingGroupId = [self.groupIds objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSLog(@"row selected: %ld", (long)indexPath.row);
        
        PersonDetailViewController *personDetailViewController = [[PersonDetailViewController alloc] initWithNibName:@"PersonDetailViewController" bundle:nil];
        personDetailViewController.incomingPersonId = [self.personIds objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:personDetailViewController animated:YES];
    }
}

-(IBAction)segmentedControlAction:(UISegmentedControl *)sender {
    [self resetArrays];
    
    if(segmentedControl.selectedSegmentIndex == 0) {
        [self loadCommunityData];
    } else {
        [self loadFriendData];
    }
}

- (void)viewDidLayoutSubviews {
    self.tableview.frame = self.view.bounds;
}

@end