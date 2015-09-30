//
//  ViewController.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 14/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

- (IBAction)signOutButton:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UILabel *userProfileName;
@property (strong, nonatomic) IBOutlet UILabel *userChurch;
@property (strong, nonatomic) IBOutlet UILabel *userCommunityGroup;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UIImageView *userProfilePicture;
@property (strong, nonatomic) IBOutlet UINavigationItem *userUsername;

@property (strong, nonatomic) IBOutlet UIImageView *userProfilePictureInEdit;

@property (strong, nonatomic) PFUser *currentUser;

//- (IBAction)editProfileButton:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITextField *fullNameInput;
@property (strong, nonatomic) IBOutlet UITextField *userChurchInput;
@property (strong, nonatomic) IBOutlet UITextField *userCommunityGroupInput;
@property (strong, nonatomic) IBOutlet UITextField *usernameInput;
- (IBAction)saveUserInput:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *saveButtonOutlet;

@property (strong, nonatomic) IBOutlet UIButton *signOutOutlet;

- (IBAction)personalDataButton:(UIBarButtonItem *)sender;

@end

