//
//  PersonDetailViewController.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 3/9/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PersonDetailViewController : UIViewController
@property(nonatomic) NSArray *persons;
@property(nonatomic) NSString *incomingPersonId;
@property(nonatomic) NSString *username; //CHANGE

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *communityGroupLabel;
@property (strong, nonatomic) IBOutlet UILabel *churchLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;

- (IBAction)addFriendButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *addFriendButtonOutlet;

@property (strong, nonatomic) IBOutlet UIButton *acceptButton;
- (IBAction)acceptRequest:(UIButton *)sender;

- (IBAction)declineRequest:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *declineButton;
@end
