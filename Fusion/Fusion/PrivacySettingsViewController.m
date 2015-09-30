//
//  PrivacySettingsViewController.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 3/9/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "PrivacySettingsViewController.h"

@interface PrivacySettingsViewController ()

@end

@implementation PrivacySettingsViewController
@synthesize updatedUsernameTextField;
@synthesize oldEmailTextField;
@synthesize updatedEmailTextField;
@synthesize oldPasswordTextField;
@synthesize updatedPasswordTextField;
@synthesize confirmUpdatedPasswordTextField;

-(void)viewDidLoad {
    
    self.oldEmailTextField.text = [PFUser currentUser][@"email"];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{
       NSFontAttributeName:[UIFont fontWithName:@"Roboto-Light" size:18.0f]
       }
     forState:UIControlStateNormal];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,
                                    [UIFont fontWithName:@"Roboto-Light" size:20.0f], NSFontAttributeName,
                                    nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}


- (IBAction)confirmChangesButton:(UIBarButtonItem *)sender {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
                
        [self emailCheck: currentUser];
    }
}

- (IBAction)cancelChangePersonalDetailsButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)emailCheck:(PFUser *)_currentUser {
    
    if ([oldEmailTextField.text isEqualToString:@""]) {

    } else if (![_currentUser[@"email"] isEqualToString:self.oldEmailTextField.text]) {
        [self createAlert:@"your email does not match our records" :@"oh no!"];
    } else if ([self NSStringIsValidEmail:updatedEmailTextField.text]) {
        _currentUser[@"email"] = updatedEmailTextField.text;
        [_currentUser saveInBackgroundWithBlock:^(BOOL success, NSError *error){
            [self createAlert:@"your email has now been changed" :@"success!"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    } else {
        [self createAlert:@"please enter a valid email address" :@"oh no!"];
    }

}

-(void)passwordCheck:(PFUser *)_currentUser {
    
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString {
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void)createAlert:(NSString *)_message :(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:_message
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
}

//-(void)createAlert {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"please enter your username and password"
//                                                    message:nil
//                                                   delegate:self
//                                          cancelButtonTitle:@"Cancel"
//                                          otherButtonTitles:@"Enter", nil];
//    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
//    [alert show];
//}
@end