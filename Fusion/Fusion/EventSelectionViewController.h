//
//  EventSelectionViewController.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 13/9/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EventSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *eventName;
@property (strong, nonatomic) IBOutlet UILabel *dateAndTime;
@property (strong, nonatomic) IBOutlet UILabel *place;
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;

@property (strong, nonatomic) NSString *incomingEventName;
@property (strong, nonatomic) NSString *incomingDateAndTime;
@property (strong, nonatomic) NSString *incomingPlace;
@property (strong, nonatomic) UIImage *incomingProfilePic;

@property (strong, nonatomic) NSString *incomingEventId;

@property (strong, nonatomic) IBOutlet UILabel *numberOfPeopleGoingLabel;

@property (strong, nonatomic) IBOutlet UISegmentedControl *rsvpSegmentControl;
- (IBAction)confirmRsvp:(UISegmentedControl *)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@end