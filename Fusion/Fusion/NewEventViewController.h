//
//  NewEventViewController.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 12/9/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NewEventViewController : UIViewController


@property (strong, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UITextField *dateAndTimeTextField;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)createEventBarButtonItem:(UIBarButtonItem *)sender;
@end