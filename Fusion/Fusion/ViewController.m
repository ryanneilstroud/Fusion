//
//  ViewController.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 14/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize currentUser;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationItemTitle];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0.0, 1.0);
    shadow.shadowColor = [UIColor whiteColor];
    
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
    
    self.userProfileName.font = [UIFont fontWithName:@"Roboto-Light" size:24.0f];
    self.userChurch.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
    self.userCommunityGroup.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
    
    self.signOutOutlet.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:18.0f];
    
    UISwipeGestureRecognizer* swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:swipeDownGestureRecognizer];

}

- (void)handleSwipeDownFrom:(UIGestureRecognizer*)recognizer {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setCurrentUserData];
}

- (IBAction)saveUserInput:(UIButton *)sender {
    [self.activityIndicator startAnimating];
    
    currentUser[@"churchName"] = self.userChurchInput.text;
    currentUser[@"communityGroupName"] = self.userCommunityGroupInput.text;
    currentUser[@"fullName"] = self.fullNameInput.text;
    
    if (![self.usernameInput.text isEqualToString:@""]) {
        
        NSString *regex = @"([a-z_.-0-9]){3,30}\\w+";
        NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        if ([regexPredicate evaluateWithObject:self.usernameInput.text]) {
            
            PFQuery *query = [PFUser query];
            [query whereKey:@"username" equalTo:self.usernameInput.text]; // find all the women
            NSArray *username = [query findObjects];
            
            if (username.count == 0) {
                currentUser.username = self.usernameInput.text;
            } else if ([username[0][@"username"] isEqualToString:currentUser.username]) {
                currentUser.username = self.usernameInput.text;
            } else {
                [self createAlert:@"This username is already taken." :@"oops!"];
            }
        } else {
            [self createAlert:@"usernames may only contain lowercase letters, numbers, underscores, hyphens, and must be between 3 and 30 characters with no spaces." :@"oops!"];
        }
    }
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {

        } else {
            NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            [self createAlert:errorString :@"oops!"];
        }
        [self.activityIndicator stopAnimating];
        self.navigationItem.title = @"saved!";
        [self createAlert:@"your profile is now updated!" :@"success!"];
        [NSTimer scheduledTimerWithTimeInterval:2.0
                                         target:self
                                       selector:@selector(setNavigationItemTitle)
                                       userInfo:nil
                                        repeats:NO];
    }];
}

-(void)setNavigationItemTitle {
    self.navigationItem.title = @"edit";
}

- (void)setCurrentUserData {
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.activityIndicator startAnimating];
    
    currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        self.userUsername.title = currentUser.username;
        self.userProfileName.text = currentUser[@"fullName"];
        if ([self.userProfileName.text isEqualToString:@""]) {
            self.userProfileName.text = @"-";
        }
        self.username.text = currentUser.username;
        self.userChurch.text = currentUser[@"churchName"];
        if ([self.userChurch.text isEqualToString:@""]) {
            self.userChurch.text = @"-";
        }
        self.userCommunityGroup.text = currentUser[@"communityGroupName"];
        if ([self.userCommunityGroup.text isEqualToString:@""]) {
            self.userCommunityGroup.text = @"-";
        }
        
        [currentUser[@"profilePic"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                self.userProfilePicture.image = image;
                self.userProfilePictureInEdit.image = image;
                
                [self.activityIndicator stopAnimating];
            }
        }];
        
    } else {
        // show the signup or login screen
    }
    
    self.userProfilePicture.layer.cornerRadius = 100;
    self.userProfilePicture.clipsToBounds = YES;

    if ([currentUser[@"churchName"] isEqualToString:@"none"]) {
        self.userChurchInput.text = @"";
    } else {
        self.userChurchInput.text = currentUser[@"churchName"];
    }
    
    if ([currentUser[@"communityGroupName"] isEqualToString:@"none"]) {
        self.userCommunityGroupInput.text = @"";
    } else {
        self.userCommunityGroupInput.text = currentUser[@"communityGroupName"];
    }
    self.fullNameInput.text = currentUser[@"fullName"];
    self.usernameInput.text = currentUser.username;
    
    self.userProfilePictureInEdit.layer.cornerRadius = 100;
    self.userProfilePictureInEdit.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigateToStoryboard: (NSString *)_vcIndentifer {
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:_vcIndentifer];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)chaneProfilePictureButton:(UIButton *)sender {
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Choose Existing",
                            @"Take Photo",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self chooseFromCameraRoll];
                    break;
                case 1:
                    //[self takePhoto];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

-(void)chooseFromCameraRoll {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        if (pickerController != nil)
        {
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
            // set up the delegate
            pickerController.delegate = self;
    
            pickerController.allowsEditing = true;
    
            [self presentViewController:pickerController animated:YES completion:nil];
        }
}

// user selected an image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (selectedImage != nil) {
        UIImage *image = selectedImage;
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
        [imageFile saveInBackground];
        
        [currentUser setObject:imageFile forKey:@"profilePic"];
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self setCurrentUserData];
            } else {
            
            }
        }];
    }
    
    [picker dismissViewControllerAnimated:true completion:nil];
}

-(void)takePhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    picker.showsCameraControls = NO;
    
    [self presentViewController:picker animated:YES
                     completion:^ {
                         [picker takePicture];
                     }];
}

- (IBAction)signOutButton:(UIButton *)sender {
    [PFUser logOut];
    
    NSString *vcIndentifer = @"logInScreen";
    [self navigateToStoryboard: vcIndentifer];
}

-(void)createAlert:(NSString *)_message :(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:_message
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)personalDataButton:(UIBarButtonItem *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"enter password"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert addButtonWithTitle:@"Login"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UITextField *password = [alertView textFieldAtIndex:0];
        [PFUser logInWithUsernameInBackground:currentUser[@"username"] password:password.text block:^(PFUser *user, NSError *error) {
            if (user) {
                // Do stuff after successful login.
                NSLog(@"password confirmed");
                
                NSString *vcIndentifer = @"privacySettingsViewController";
                [self navigateToStoryboard:vcIndentifer];
            } else {
                // The login failed. Check error to see why.
                NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
                [self createAlert: errorString :@"oops!"];
            }
        }];
    }
}

@end
