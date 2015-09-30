//
//  NewCommunityGroupViewController.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 3/9/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NewCommunityGroupViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *communityGroupProfilePicture;
@property (strong, nonatomic) IBOutlet UITextField *communityNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *churchNameTextField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *createCommunityButtonOutlet;


- (IBAction)cancelCreateNewCommunity:(UIBarButtonItem *)sender;
- (IBAction)editCommunityProfilePicture:(UIButton *)sender;
- (IBAction)createCommunityButton:(UIBarButtonItem *)sender;

@end