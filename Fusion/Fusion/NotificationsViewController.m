//
//  NotificationsViewController.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 26/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "NotificationsViewController.h"
#import "CustomNotificationCell.h"
#import "PersonDetailViewController.h"
#import "FriendsPostSelectionViewController.h"

@interface NotificationsViewController ()
@property (nonatomic) BOOL hasFriendRequest;
@property (nonatomic) BOOL wasTagged;
@property (nonatomic) UILabel *infoLabel;
@property (nonatomic) UIView *notificationsView;

@end

@implementation NotificationsViewController
@synthesize notificationImages;
@synthesize notificationMessages;
@synthesize personsId;
@synthesize postId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.notificationsView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x,
                                                                      self.view.frame.origin.y,
                                                                      self.view.frame.size.width,
                                                                      self.view.frame.size.height)];
    self.notificationsView.backgroundColor = [UIColor whiteColor];
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    self.infoLabel.text = @"You don't have any notifications :(";
    
    PFUser *currentUser = [PFUser currentUser];
    
    notificationMessages = [[NSMutableArray alloc] init];
    notificationImages = [[NSMutableArray alloc] init];
    personsId = [[NSMutableArray alloc] init];
    postId = [[NSMutableArray alloc] init];
    
    self.hasFriendRequest = NO;
    self.wasTagged = NO;
    
    //check for notification
    PFQuery *query = [PFQuery queryWithClassName:@"CommunityGroup"];
    [query whereKey:@"admin" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            NSLog(@"found it!");
    
            PFQuery *communityRequest = [PFQuery queryWithClassName:@"CommunityRequest"];
            [communityRequest getObjectInBackgroundWithId:[array[0] objectId] block:^(PFObject *object, NSError *error) {
                
            }];
            
        } else {
            NSLog(@"not admin");
        }
    }];
    
    PFQuery *taggedNotificationsQuery = [PFQuery queryWithClassName:@"NewsFeedMessage"];
    [taggedNotificationsQuery whereKey:@"taggedFriends" equalTo:currentUser[@"username"]];
    [taggedNotificationsQuery findObjectsInBackgroundWithBlock:^(NSArray *tags, NSError *error){
        NSLog(@"tags: %@", tags);
        if ([tags count] == 0) {
//            [self.view addSubview:self.notificationsView];
//            self.wasTagged = NO;
//            self.tableview.hidden = YES;
//            [self.view addSubview:self.infoLabel];
        } else {
//            self.wasTagged = YES;
//            self.tableview.hidden = NO;
            if (!error) {
                PFQuery *taggerQuery = [PFUser query];
                for (int i = 0; i < tags.count; i++) {
                    [taggerQuery getObjectInBackgroundWithId:[tags[i][@"creator"] objectId] block:^(PFObject *tagger, NSError *error){
                        [personsId addObject:[tagger objectId]];
                        [postId addObject:[tags[i] objectId]];
                        
                        NSString *message = [NSString stringWithFormat:@"%@ has tagged you in a post", tagger[@"fullName"]];
                        [notificationMessages addObject:message];
                        
                        [tagger[@"profilePic"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                            if (!error) {
                                UIImage *image = [UIImage imageWithData:data];
                                [notificationImages addObject:image];
                                if ([notificationMessages count] > 0) {
                                    [self.tableview reloadData];
                                }
                            }
                        }];
                    }];
                }
            } else {
                NSLog(@"error: %@", error);
            }
        }
    }];
    
    if (currentUser) {
        // do stuff with the user
        //check for notifications
        PFQuery *query = [PFQuery queryWithClassName:@"FriendRequest"];
        [query whereKey:@"receiver" equalTo:currentUser.objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                [query whereKey:@"status" equalTo:@"pending"];
                [query findObjectsInBackgroundWithBlock:^(NSArray *pendingStatuses, NSError *error) {
                    if (!error) {
                        if ([pendingStatuses count] == 0) {
                            NSLog(@"pendingStatusesI = %@", pendingStatuses);
//                            self.hasFriendRequest = NO;
//                            self.tableview.hidden = YES;
//                            [self.view addSubview:self.notificationsView];
//                            [self.view addSubview:self.infoLabel];
                        } else {
                            NSLog(@"pendingStatusesU = %@", pendingStatuses);
//                            self.hasFriendRequest = YES;
//                            self.tableview.hidden = NO;
                            
                            for (int i = 0; i<pendingStatuses.count; i++) {
                                PFQuery *query = [PFUser query];
                                [query getObjectInBackgroundWithId:pendingStatuses[i][@"sender"] block:^(PFObject *user, NSError *error) {
                                    [postId addObject:[user objectId]];
                                    
                                    NSLog(@"HELLO");
                                    
                                    [personsId addObject:[user objectId]];
                                    
                                    NSLog(@"sender = %@", user[@"username"]);
                                    NSString *message = [NSString stringWithFormat:@"%@ has sent you a friend request", user[@"username"]];
                                    [notificationMessages addObject:message];
                                    
                                    [user[@"profilePic"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                                        if (!error) {
                                            UIImage *image = [UIImage imageWithData:data];
                                            [notificationImages addObject:image];
                                            if ([notificationMessages count] > 0) {
                                                [self.tableview reloadData];
                                            }
                                        }
                                    }];
                                    
                                }];
                            }
                        }
                        
                    } else {
                        NSLog(@"%@", error);
                    }
                }];
            } else {
                NSLog(@"%@", error);
            }
        }];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,
                                    [UIFont fontWithName:@"Roboto-Light" size:20.0f], NSFontAttributeName,
                                    nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return notificationMessages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell"];
    
    if (cell != nil) {
        [cell refreshCellWithInfo:[notificationMessages objectAtIndex:indexPath.row] :[notificationImages objectAtIndex:indexPath.row]];
    }
    
    NSLog(@"%@", notificationMessages);
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (int i = 0; i < notificationMessages.count; i++) {
        if ([notificationMessages[indexPath.row] containsString:@"has tagged you in a post"]) {
            NSLog(@"tagged in a post");
            
            FriendsPostSelectionViewController *friendsPostSelectionViewController = [[FriendsPostSelectionViewController alloc] initWithNibName:@"FriendsPostSelection" bundle:nil];
            friendsPostSelectionViewController.incomingPostId = [self.postId objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:friendsPostSelectionViewController animated:YES];
            
            break;
        } else if ([notificationMessages[indexPath.row] containsString:@"has sent you a friend request"]) {
            NSLog(@"sent a friend request");
            
            PersonDetailViewController *personDetailViewController = [[PersonDetailViewController alloc] initWithNibName:@"PersonDetailViewController" bundle:nil];
            personDetailViewController.incomingPersonId = [self.personsId objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:personDetailViewController animated:YES];

            break;
        }
    }
}

@end





