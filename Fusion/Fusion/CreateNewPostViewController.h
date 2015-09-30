//
//  UIViewController+CreateNewPostViewController.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 28/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CreateNewPostViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
- (IBAction)cancelCreateNewPost:(UIBarButtonItem *)sender;
//- (IBAction)postMessageButton:(UIBarButtonItem *)sender;

@property (strong, nonatomic) IBOutlet UIView *singleContainerView;
@property (strong, nonatomic) IBOutlet UIView *eventContainerView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *postMessageButtonOutlet;

- (IBAction)segementedControl:(UISegmentedControl *)sender;
@end
