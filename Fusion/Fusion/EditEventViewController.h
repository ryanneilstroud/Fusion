//
//  EditEventViewController.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 25/9/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditEventViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *eventLocationTextField;
@property (strong, nonatomic) IBOutlet UITextField *eventDateTimeTextField;

@property (strong, nonatomic) NSString *incomingEventName;
@property (strong, nonatomic) NSString *incomingLocation;
@property (strong, nonatomic) NSString *incomingDateAndTime;
@property (strong, nonatomic) NSString *incomingEventId;

@end
