//
//  PersonDetailViewController.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 3/9/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "PersonDetailViewController.h"

@interface PersonDetailViewController ()
@property (nonatomic) NSString *personId;
@property (strong, nonatomic) NSString *ADD_FRIEND;
@property (strong, nonatomic) NSString *FRIEND_REQUEST_SENT;
@property (strong, nonatomic) NSString *FRIENDS;
@property (strong, nonatomic) NSString *FRIEND_REQUEST_RECEIVED;

@property (strong, nonatomic) NSString *FRIENDSHIP_PENDING;
@property (strong, nonatomic) NSString *FRIENDSHIP_ACCEPTED;
@property (strong, nonatomic) NSString *FRIENDSHIP_DECLINED;

@end

@implementation PersonDetailViewController

-(void)viewDidLoad {
    
    NSLog(@"ViewDidLoad");
    
    _ADD_FRIEND = @"add friend";
    _FRIEND_REQUEST_SENT = @"friend request sent";
    _FRIENDS = @"friends";
    _FRIEND_REQUEST_RECEIVED = @"Accept Friend Request";
    
    _FRIENDSHIP_PENDING = @"pending";
    _FRIENDSHIP_ACCEPTED = @"accepted";
    _FRIENDSHIP_DECLINED = @"declined";
    
    //pull down details of person being viewed
    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:self.incomingPersonId block:^(PFObject *user, NSError *error){
        if (!error) {
            self.navigationItem.title = user[@"username"];
            
            self.usernameLabel.text = user[@"fullName"];
            self.communityGroupLabel.text = user[@"communityGroupName"];
            self.churchLabel.text = user[@"churchName"];
            
            PFFile *file = user[@"profilePic"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    // image can now be set on a UIImageView
                    
                    self.profileImage.image = image;
                    
                    self.profileImage.layer.cornerRadius = 100;
                    self.profileImage.clipsToBounds = YES;
                }
            }];
        }
    }];
    
    self.usernameLabel.font = [UIFont fontWithName:@"Roboto-Light" size:24.0f];
    self.communityGroupLabel.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
    self.churchLabel.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
        
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    [self.acceptButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.declineButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.addFriendButtonOutlet setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    self.acceptButton.frame = CGRectMake(self.acceptButton.frame.origin.x, self.acceptButton.frame.origin.y, screenRect.size.width/2, self.acceptButton.frame.size.height);
    self.declineButton.frame = CGRectMake(screenRect.size.width/2, self.declineButton.frame.origin.y, screenRect.size.width/2, self.declineButton.frame.size.height);
    self.addFriendButtonOutlet.frame = CGRectMake(self.addFriendButtonOutlet.frame.origin.x, self.addFriendButtonOutlet.frame.origin.y, screenRect.size.width, self.addFriendButtonOutlet.frame.size.height);
    
    NSLog(@"buttonHeight = %f", self.acceptButton.frame.size.height);

    [self getFriendshipStatus];

//    self.acceptButton.layer.cornerRadius = 10;
//    self.acceptButton.clipsToBounds = YES;
}

- (void)getFriendshipStatus {
    PFUser *currentUser = [PFUser currentUser];
    
    PFQuery *friendshipStatusQuery = [PFQuery queryWithClassName:@"FriendRequest"];
    [friendshipStatusQuery findObjectsInBackgroundWithBlock:^(NSArray *friendshipStatuses, NSError *error) {
        if (!error) {
//            NSLog(@"friendship statues: %@", friendshipStatuses);
            
            if (![friendshipStatuses count] == 0) {
            
                //loop
                for (int i = 0; i<friendshipStatuses.count; i++) {
//                    NSLog(@"friendshipStatuses[%d] = %@", i, friendshipStatuses[i]);
//                    NSLog(@"self.incomingPersonId = %@", self.incomingPersonId);
                    
                    if ([friendshipStatuses[i][@"sender"] isEqualToString:currentUser.objectId] && [friendshipStatuses[i][@"receiver"] isEqualToString:self.incomingPersonId]) {
                        
                        if ([friendshipStatuses[i][@"status"] isEqualToString:_FRIENDSHIP_ACCEPTED]) {
                            [self.addFriendButtonOutlet setTitle:_FRIENDS forState:UIControlStateNormal];
                            self.addFriendButtonOutlet.enabled = NO;

                        } else if ([friendshipStatuses[i][@"status"] isEqualToString:_FRIENDSHIP_DECLINED]) {
                            [self.addFriendButtonOutlet setTitle:_ADD_FRIEND forState:UIControlStateNormal];
                        } else {
                            [self.addFriendButtonOutlet setTitle:_FRIEND_REQUEST_SENT forState:UIControlStateNormal];
                            self.addFriendButtonOutlet.enabled = NO;
                        }
//                        NSLog(@"MATCH: sender = %@, receiver = %@", currentUser.objectId, self.incomingPersonId);

                        
                    } else if ([friendshipStatuses[i][@"sender"] isEqualToString:self.incomingPersonId] && [friendshipStatuses[i][@"receiver"] isEqualToString:currentUser.objectId]) {
                        
                        if ([friendshipStatuses[i][@"status"] isEqualToString:_FRIENDSHIP_ACCEPTED]) {
                            NSLog(@"accepted");
//                            self.addFriendButtonOutlet.hidden = NO;
                            [self.addFriendButtonOutlet setTitle:_FRIENDS forState:UIControlStateNormal];
                            self.addFriendButtonOutlet.enabled = NO;
                        } else {
                            self.acceptButton.hidden = NO;
                            self.declineButton.hidden = NO;
                            self.addFriendButtonOutlet.hidden = YES;
                        }
                        
//                        NSLog(@"MATCH: receiver = %@, sender = %@", currentUser.objectId, self.incomingPersonId);


                    } else {
                        NSLog(@"NO MATCH");
                    }
                }
                
            }
        } else {
            NSLog(@"%@ %@", error, [error userInfo]);
        }
    }];
}

- (IBAction)addFriendButton:(UIButton *)sender {
    
    PFUser *currentUser = [PFUser currentUser];
    
    NSLog(@"incomingPersonId = %@", self.incomingPersonId);
    
    //ACCEPT FRIEND REQUEST?
    if ([self.addFriendButtonOutlet.titleLabel.text isEqualToString:_FRIEND_REQUEST_RECEIVED]) {
        PFQuery *receiver = [PFQuery queryWithClassName:@"FriendRequest"];
        [receiver whereKey:@"receiver" equalTo:currentUser.objectId];
        
        PFQuery *sender = [PFQuery queryWithClassName:@"FriendRequest"];
        [sender whereKey:@"sender" equalTo:self.incomingPersonId];
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[receiver,sender]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            if (!error) {
                NSLog(@"results = %@", results);
                results[0][@"status"] = _FRIENDSHIP_ACCEPTED;
                [results[0] saveInBackground];
            }
        }];
        
        [self.addFriendButtonOutlet setTitle:_FRIENDS forState:UIControlStateNormal];
        self.addFriendButtonOutlet.enabled = NO;
        
        //ADD FRIEND?
    } else if ([self.addFriendButtonOutlet.titleLabel.text isEqualToString:_ADD_FRIEND]) {
        PFObject *friendRequestStatus = [PFObject objectWithClassName:@"FriendRequest"];
        friendRequestStatus[@"sender"] = currentUser.objectId;
        friendRequestStatus[@"status"] = _FRIENDSHIP_PENDING;
        friendRequestStatus[@"receiver"] = self.incomingPersonId;
        [friendRequestStatus saveInBackground];
        
        [self.addFriendButtonOutlet setTitle:_FRIEND_REQUEST_SENT forState:UIControlStateNormal];
        self.addFriendButtonOutlet.enabled = NO;
    }
    
}
- (IBAction)declineRequest:(UIButton *)sender {
    self.acceptButton.hidden = YES;
    self.declineButton.hidden = YES;
    
    self.addFriendButtonOutlet.hidden = NO;
    [self.addFriendButtonOutlet setTitle:_ADD_FRIEND forState:UIControlStateNormal];
    self.addFriendButtonOutlet.backgroundColor = [UIColor colorWithRed:0 green:0.471 blue:1 alpha:1];
    
    PFQuery *receiver = [PFQuery queryWithClassName:@"FriendRequest"];
    [receiver whereKey:@"receiver" equalTo:[[PFUser currentUser] objectId]];
    
    PFQuery *sendr = [PFQuery queryWithClassName:@"FriendRequest"];
    [sendr whereKey:@"sender" equalTo:self.incomingPersonId];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[receiver,sendr]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error) {
            NSLog(@"results = %@", results);
//            results[0][@"status"] = _FRIENDSHIP_DECLINED;
            [results[0] deleteInBackground];
            [results[0] saveInBackground];
        }
    }];
}
- (IBAction)acceptRequest:(UIButton *)sender {
    self.acceptButton.hidden = YES;
    self.declineButton.hidden = YES;

    self.addFriendButtonOutlet.hidden = NO;
    self.addFriendButtonOutlet.enabled = NO;
    [self.addFriendButtonOutlet setTitle:_FRIENDS forState:UIControlStateNormal];
    self.addFriendButtonOutlet.backgroundColor = [UIColor colorWithRed:0 green:0.471 blue:1 alpha:1];
    
    PFQuery *receiver = [PFQuery queryWithClassName:@"FriendRequest"];
    [receiver whereKey:@"receiver" equalTo:[[PFUser currentUser] objectId]];
    
    PFQuery *sendr = [PFQuery queryWithClassName:@"FriendRequest"];
    [sendr whereKey:@"sender" equalTo:self.incomingPersonId];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[receiver,sendr]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error) {
            NSLog(@"results = %@", results);
            results[0][@"status"] = _FRIENDSHIP_ACCEPTED;
            [results[0] saveInBackground];
        }
    }];
    
    PFQuery *userQuery = [PFUser query];
    [userQuery getObjectInBackgroundWithId:self.incomingPersonId block:^(PFObject *object, NSError *error){
        if (!error) {
            PFQuery *myFriendsListQuery = [PFQuery queryWithClassName:@"FriendsList"];
            [myFriendsListQuery whereKey:@"owner" equalTo:object];
            [myFriendsListQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
                if (!error) {
                    NSLog(@"array = %@", array);
                    [array[0][@"friends"] addObject:[[PFUser currentUser] objectId]];
                    [array[0] saveInBackgroundWithBlock:^(BOOL success, NSError *error){
                        if (!error) {
                            NSLog(@"success");
                        } else {
                            NSLog(@"error = %@", error);
                        }
                    }];
                }
            }];
        }
    }];
    
    PFQuery *theirFirendsListQuery = [PFQuery queryWithClassName:@"FriendsList"];
    [theirFirendsListQuery whereKey:@"owner" equalTo:[PFUser currentUser]];
    [theirFirendsListQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        if (!error) {
            NSLog(@"array = %@", array);
            [array[0][@"friends"] addObject:self.incomingPersonId];
            [array[0] saveInBackgroundWithBlock:^(BOOL success, NSError *error){
                if (!error) {
                    NSLog(@"success");
                } else {
                    NSLog(@"error = %@", error);
                }
            }];
            
        }
    }];
    
}
@end