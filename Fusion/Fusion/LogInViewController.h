//
//  LogInViewController.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 25/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LogInViewController : UIViewController

//@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSString *TABBARCONTROLLER;

@property (strong, nonatomic) IBOutlet UITextField *usernameInput;
@property (strong, nonatomic) IBOutlet UITextField *passwordInput;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *signUpLoadingIndicator;

- (IBAction)signInButton:(UIButton *)sender;
- (IBAction)cancelSignUpButton:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITextField *usernameSignUp;
@property (strong, nonatomic) IBOutlet UITextField *userEmailSignUp;
@property (strong, nonatomic) IBOutlet UITextField *userPasswordSignUp;
@property (strong, nonatomic) IBOutlet UITextField *userPasswordConfirmationSignUp;

- (IBAction)signUpConfirmationButton:(UIButton *)sender;

- (IBAction)forgotPasswordButton:(UIButton *)sender;
@end