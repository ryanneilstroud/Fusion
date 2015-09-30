//
//  FriendsPostSelection.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 27/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendsPostSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *incomingName;
@property (strong, nonatomic) NSString *incomingMessage;
@property (strong, nonatomic) UIImage *incomingProfilePic;
@property (strong, nonatomic) UIImage *incomingSharedImages;

@property (strong, nonatomic) NSString *incomingPostId;

- (IBAction)favoriteButton:(UIButton *)sender;
- (IBAction)commentButton:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) IBOutlet UIToolbar *commentToolbar;
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;

- (IBAction)composeComment:(UIBarButtonItem *)sender;
@end