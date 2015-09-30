//
//  CommunitySelectionViewController.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 28/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CommunitySelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) NSString *incomingGroupId;
@property (strong, nonatomic) IBOutlet UILabel *groupsName;
@property (strong, nonatomic) IBOutlet UIImageView *groupsProfilePic;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControlOutlet;
@property (strong, nonatomic) IBOutlet UITableView *tableview;

- (IBAction)createPost:(UIBarButtonItem *)sender;

@end