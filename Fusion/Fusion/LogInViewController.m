//
//  LogInViewController.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 25/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()
@property (nonatomic, strong) NSString *ALERT_TITLE;

@end

@implementation LogInViewController

@synthesize TABBARCONTROLLER;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer* swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:swipeDownGestureRecognizer];
    
    self.ALERT_TITLE = @"oh no!";
    
    TABBARCONTROLLER = @"tabBarController";
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"user: %@", currentUser);
        NSString *vcIndentifer = TABBARCONTROLLER;
        [self navigateToStoryboard:vcIndentifer];
    } else {
        NSLog(@"no user: %@", currentUser);
    }
}

- (void)handleSwipeDownFrom:(UIGestureRecognizer*)recognizer {
    [self.view endEditing:YES];
}

- (IBAction)signInButton:(UIButton *)sender {
    NSString *userName = self.usernameInput.text;
    NSString *userPassword = self.passwordInput.text;
    
    if ([userName isEqual:@""] || [userPassword isEqual:@""]) {
        [self createAlert: @"both fields are required" :self.ALERT_TITLE];
    } else {
        [self.loadingIndicator startAnimating];
        [self signIn:userName :userPassword];
    }
}

- (IBAction)cancelSignUpButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signIn:(NSString *)_userName :(NSString *)_userPassword {
    [self.signUpLoadingIndicator startAnimating];
    
    [PFUser logInWithUsernameInBackground:_userName password:_userPassword
        block:^(PFUser *user, NSError *error) {
            if ([self.signUpLoadingIndicator isAnimating]) {
                [self.signUpLoadingIndicator stopAnimating];
            }
            
            if (user) {
                // Do stuff after successful login.
                NSLog(@"Login successful");

                PFQuery *query = [PFQuery queryWithClassName:@"FriendsList"];
                [query whereKey:@"owner" equalTo:[PFUser currentUser]];
                [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
                    if (!error) {
                        NSLog(@"array = %@", array);
                        if (array.count == 0) {
                            PFObject *friendsList = [PFObject objectWithClassName:@"FriendsList"];
                            [friendsList setObject:[PFUser currentUser] forKey:@"owner"];
                            friendsList[@"friends"] = [[NSMutableArray alloc] initWithObjects:[[PFUser currentUser] objectId], nil];
                            [friendsList saveInBackground];
                        }
                    } else {
                        NSLog(@"error = %@", [error userInfo]);

                    }
                }];
                
                NSString *vcIndentifer = TABBARCONTROLLER;
                [self navigateToStoryboard:vcIndentifer];
            } else {
                // The login failed. Check error to see why.
                [self.loadingIndicator stopAnimating];
                self.passwordInput.text = @"";
                NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
                [self createAlert: errorString :self.ALERT_TITLE];
            }
    }];
}

- (void)navigateToStoryboard: (NSString *)_vcIndentifer {
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:_vcIndentifer];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)signUpConfirmationButton:(UIButton *)sender {
    if ([self confirmNewUserDetailsOnSignUp] == YES) {
        NSLog(@"local sign up approved");
        [self attemptToCreateNewAccount];
    } else {
        NSLog(@"local sign up rejected");
    }
}

- (IBAction)forgotPasswordButton:(UIButton *)sender {
    UIAlertView *forgotPasswordAlert = [[UIAlertView alloc] initWithTitle:@"Enter Email" message:@"We will send you an email to reset your password." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reset", nil];
    forgotPasswordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;

    [forgotPasswordAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"1");
        UITextField *email = [alertView textFieldAtIndex:0];
        if ([self NSStringIsValidEmail:email.text]) {
            [PFUser requestPasswordResetForEmailInBackground:email.text block:^(BOOL success, NSError *error){
                if (success) {
                    [self createAlert:[NSString stringWithFormat:@"An email was sent to you at %@",email.text] :@"success!"];
                } else {
                    [self createAlert:[NSString stringWithFormat:@"We found no record of %@",email.text] :self.ALERT_TITLE];
                }
            }];
        } else {
            [self createAlert:@"Please enter a valid email.": self.ALERT_TITLE];
        }
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString {
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)confirmNewUserDetailsOnSignUp {
    BOOL userConfirmationStatus = NO;
    
    BOOL usernameConfirmationStatus = NO;
    BOOL userEmailConfirmationStatus = NO;
    BOOL userPasswordLengthConfirmationStatus = NO;
    BOOL userPasswordMatchConfirmationStatus = NO;
    
    NSString *username = self.usernameSignUp.text;
    NSString *userEmail = self.userEmailSignUp.text;
    NSString *userInitalPassword = self.userPasswordSignUp.text;
    NSString *userFinalPassword = self.userPasswordConfirmationSignUp.text;
    
    NSString *regex = @"([a-z_.-0-9]){2,30}\\w+";
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    usernameConfirmationStatus = ([regexPredicate evaluateWithObject:username]) ? YES : NO;
    userEmailConfirmationStatus = ([self NSStringIsValidEmail:userEmail]) ? YES : NO;
    userPasswordLengthConfirmationStatus = (userInitalPassword.length >= 8) ? YES : NO;
    userPasswordMatchConfirmationStatus = ([userInitalPassword isEqual: userFinalPassword]) ? YES : NO;
    
    if (usernameConfirmationStatus == YES && userEmailConfirmationStatus == YES &&
        userPasswordLengthConfirmationStatus == YES && userPasswordMatchConfirmationStatus == YES) {
        userConfirmationStatus = YES;
    } else {
        NSString *message;
        if (usernameConfirmationStatus == NO) {
            message = @"usernames may only contain lowercase letters, numbers, underscores, hyphens, and must be between 3 and 30 characters with no spaces.";
        } else if (userEmailConfirmationStatus == NO) {
            message = @"please enter a valid email address";
        } else if (userPasswordLengthConfirmationStatus == NO) {
            message = @"passwords must be 8 or more characters";
        } else {
            message = @"your passwords must match";
        }
        [self createAlert:message :self.ALERT_TITLE];
    }
    
    return userConfirmationStatus;
}

- (void)attemptToCreateNewAccount {
    [self.signUpLoadingIndicator startAnimating];
    
    NSString *username = self.usernameSignUp.text;
    NSString *userEmail = self.userEmailSignUp.text;
    NSString *userInitalPassword = self.userPasswordSignUp.text;
    
    PFUser *user = [PFUser user];
    NSLog(@"user = %@", user);
    user.username = username;
    user.password = userInitalPassword;
    user.email = userEmail;
    user[@"fullName"] = username;
    user[@"churchName"] = @"none";
    user[@"communityGroupName"] = @"none";
    user[@"tempStorage"] = [[NSMutableArray alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"user_large.png"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    [imageFile saveInBackground];
        
    [user setObject:imageFile forKey:@"profilePic"];
    
    NSLog(@"user = %@", user);
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([self.signUpLoadingIndicator isAnimating]) {
            [self.signUpLoadingIndicator stopAnimating];
        }
        
        if (!error) {   // Hooray! Let them use the app now.
            NSLog(@"Hooray! Let them use the app now.");
            
            [self signIn:username :userInitalPassword];
        } else {
            NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
//            NSLog(@"error = %@", error);
            if ([error code] == 203) {
                [self createAlert: errorString :self.ALERT_TITLE];
            } else if ([error code] == 202) {
                [self createAlert: errorString :self.ALERT_TITLE];
            } else {
                
            }
        }
    }];
}

-(void)createAlert:(NSString *)_message :(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:_message
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
}

@end