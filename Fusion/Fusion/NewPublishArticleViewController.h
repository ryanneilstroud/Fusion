//
//  NewPublishArticleViewController.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 11/9/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NewPublishArticleViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSString *incomingClassName;
@property (strong, nonatomic) NSString *incomingCommunityGroupId;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *mediaButtonOutlet;

- (IBAction)getMedia:(UIBarButtonItem *)sender;
- (IBAction)tagFriend:(UIBarButtonItem *)sender;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *TextViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UIImageView *userSelectedImageView;
@property (strong, nonatomic) IBOutlet UITextView *articleTextView;

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
- (IBAction)postMessageButton:(UIBarButtonItem *)sender;

@property (strong, nonatomic) NSMutableArray *taggedPersons;

@property(nonatomic,assign)id articleDelegate;

@property (strong, nonatomic) NSString *editValue;

@end