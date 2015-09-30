//
//  NotificationsViewController.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 26/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NotificationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *notificationImages;
@property (strong, nonatomic) NSMutableArray *notificationMessages;
@property (strong, nonatomic) NSMutableArray *personsId;
@property (strong, nonatomic) NSMutableArray *postId;


@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end