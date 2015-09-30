//
//  NewPublishArticleViewController.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 11/9/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "NewPublishArticleViewController.h"
#import "SearchViewController.h"

@interface NewPublishArticleViewController ()

@end

@implementation NewPublishArticleViewController
@synthesize incomingClassName;
@synthesize incomingCommunityGroupId;

- (void)viewDidLoad {
    
    NSLog(@"incomingClassName = %@", self.incomingClassName);
    NSLog(@"incomingCommunityGroupId = %@", self.incomingCommunityGroupId);
    
    
    [self.articleTextView becomeFirstResponder];
    self.taggedPersons = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    
    if ([self.taggedPersons count] > 0) {
        self.articleTextView.text = [NSString stringWithFormat:@"%@ %@", self.articleTextView.text, self.taggedPersons[[self.taggedPersons count] - 1]];
    }
}

- (IBAction)postMessageButton:(UIBarButtonItem *)sender {
    
    PFQuery *userQuery = [PFUser query];
    [userQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error){
        if (!error) {
            if ([object[@"tempStorage"][0] isEqualToString:@"CommunityGroupMessage"]) {
                
                
                NSMutableArray *taggedFriends = [[NSMutableArray alloc] initWithArray:self.taggedPersons];
                
                PFObject *message = [PFObject objectWithClassName:@"CommunityGroupMessage"];
                message[@"message"] =  self.articleTextView.text; //publishArticleVC.articleTextView.text; needs to be sent back
                message[@"taggedFriends"] = taggedFriends;
                message[@"favorited"] = [[NSMutableArray alloc] init];
                message[@"groupId"] = object[@"tempStorage"][1];
                [message setObject:[PFUser currentUser] forKey:@"creator"];
                
                UIImage *image = self.userSelectedImageView.image;
                if (image != NULL) {
                    NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
                    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
                    [imageFile saveInBackground];
                    
                    [message setObject:imageFile forKey:@"photo"];
                }
                
                [message saveInBackgroundWithBlock:^(BOOL success, NSError *error ) {
                    if (success) {
                        NSLog(@"saved successfully");
                    } else {
                        NSLog(@"somthings wrong");
                    }
                }];
                
                [self dismissViewControllerAnimated:YES completion:nil];

            } else {
                NSMutableArray *taggedFriends = [[NSMutableArray alloc] initWithArray:self.taggedPersons];
                
                PFObject *message = [PFObject objectWithClassName:@"NewsFeedMessage"];
                message[@"message"] =  self.articleTextView.text; //publishArticleVC.articleTextView.text; needs to be sent back
                message[@"taggedFriends"] = taggedFriends;
                message[@"favorited"] = [[NSMutableArray alloc] init];
                [message setObject:[PFUser currentUser] forKey:@"creator"];
                
                UIImage *image = self.userSelectedImageView.image;
                if (image != NULL) {
                    NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
                    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
                    [imageFile saveInBackground];
                    
                    [message setObject:imageFile forKey:@"photo"];
                }
                
                [message saveInBackgroundWithBlock:^(BOOL success, NSError *error ) {
                    if (success) {
                        NSLog(@"saved successfully");
                    } else {
                        NSLog(@"somthings wrong");
                    }
                }];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
    
    //get image
}

-(void)sendDataToA:(NSString *)selectedPerson {
    [self.taggedPersons addObject:selectedPerson];
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"textview text = %@", self.articleTextView.text);
}

- (IBAction)getMedia:(UIBarButtonItem *)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Choose Existing",
                            @"Take Photo",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)tagFriend:(UIBarButtonItem *)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController* searchViewController = [sb instantiateViewControllerWithIdentifier:@"SearchView"];
    
    searchViewController.fromPublishArticleView = YES;
    searchViewController.delegate = self; // protocol listener

    [self.navigationController pushViewController:searchViewController animated:YES];
}

- (void)keyboardWillShow:(NSNotification *) notification {
    NSLog(@"hello, I'm keyboard");
    
    // Get the size of the keyboard.
    int keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    NSLog(@"%f", self.toolbar.frame.size.height);
    NSLog(@"%d", keyboardHeight);
    
    self.toolbar.frame = CGRectMake(self.toolbar.frame.origin.x, self.view.frame.size.height - keyboardHeight - self.toolbar.frame.size.height, self.toolbar.frame.size.width, self.toolbar.frame.size.height);
}

- (void)keyboardWillHide:(NSNotification *) notification {
    NSLog(@"goodbye");
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (selectedImage != nil) {
        self.userSelectedImageView.image = selectedImage;
    }
    
    [picker dismissViewControllerAnimated:true completion:nil];
}

@end