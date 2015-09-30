//
//  NewsFeedViewController.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 26/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NewsFeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property int rowHeight;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (strong, nonatomic) IBOutlet UITableView *tableview;

- (IBAction)segmentedControlAction:(UISegmentedControl *)sender;
@end