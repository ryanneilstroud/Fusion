//
//  PrivacySettingsViewController.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 3/9/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PrivacySettingsViewController : UIViewController

- (IBAction)confirmChangesButton:(UIBarButtonItem *)sender;
- (IBAction)cancelChangePersonalDetailsButton:(UIBarButtonItem *)sender;

@property (strong, nonatomic) IBOutlet UITextField *updatedUsernameTextField;

@property (strong, nonatomic) IBOutlet UITextField *oldEmailTextField;
@property (strong, nonatomic) IBOutlet UITextField *updatedEmailTextField;

@property (strong, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *updatedPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmUpdatedPasswordTextField;

@end
