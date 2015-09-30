//
//  NewCommunityGroupViewController.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 3/9/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "NewCommunityGroupViewController.h"

@interface NewCommunityGroupViewController ()

@end

@implementation NewCommunityGroupViewController

-(void)viewDidLoad {
    self.createCommunityButtonOutlet.enabled = NO;
    [self.communityNameTextField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,
                                    [UIFont fontWithName:@"Roboto-Light" size:20.0f], NSFontAttributeName,
                                    nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UISwipeGestureRecognizer* swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:swipeDownGestureRecognizer];
}

- (void)handleSwipeDownFrom:(UIGestureRecognizer*)recognizer {
    [self.view endEditing:YES];
}

- (void)textFieldDidChange:(NSNotification *)notification {
    // Do whatever you like to respond to text changes here.
    if (![self.communityNameTextField.text isEqualToString:@""]) {
        self.createCommunityButtonOutlet.enabled = YES;
    } else {
        self.createCommunityButtonOutlet.enabled = NO;
    }
}

- (IBAction)cancelCreateNewCommunity:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editCommunityProfilePicture:(UIButton *)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Choose Existing",
                            @"Take Photo",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)createCommunityButton:(UIBarButtonItem *)sender {
    //check if community name is taken
    
    PFObject *communityGroup = [PFObject objectWithClassName:@"CommunityGroup"];
    communityGroup[@"name"] = self.communityNameTextField.text;
    communityGroup[@"church"] = self.churchNameTextField.text;
    communityGroup[@"isPublic"] = @YES;
    communityGroup[@"participants"] = [[NSMutableArray alloc] initWithObjects:[[PFUser currentUser] objectId], nil];
    
    NSData *imageData = UIImageJPEGRepresentation(self.communityGroupProfilePicture.image, 0.5f);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            [communityGroup setObject:imageFile forKey:@"profilePic"];
            [communityGroup setObject:[PFUser currentUser] forKey:@"admin"];
            
            [communityGroup saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // The score key has been incremented
                    PFUser *currentUser = [PFUser currentUser];
                    PFObject *communityRequest = [PFObject objectWithClassName:@"CommunityRequest"];
                    communityRequest[@"sender"] = currentUser.objectId;
                    communityRequest[@"status"] = @"accepted";
                    communityRequest[@"receiver"] = communityGroup.objectId;
                    
                    [communityRequest saveInBackground];
                } else {
                    // There was a problem, check error.description
                }
            }];

        } else {
            // There was a problem, check error.description
            NSLog(@"%@", error);
        }
    }];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createAlert:(NSString *)_message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"oh no!"
                                                    message:_message
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *selectedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (selectedImage != nil) {
        UIImage *image = selectedImage;
        self.communityGroupProfilePicture.image = image;
        
        self.communityGroupProfilePicture.layer.cornerRadius = 50;
        self.communityGroupProfilePicture.clipsToBounds = YES;
    }
    
    [picker dismissViewControllerAnimated:true completion:nil];
}

@end