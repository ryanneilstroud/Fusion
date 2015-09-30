//
//  EditEventViewController.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 25/9/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "EditEventViewController.h"

@interface EditEventViewController ()

@end

@implementation EditEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"hellojkdl");
    
    [self.eventNameTextField becomeFirstResponder];
    
    self.eventNameTextField.text = self.incomingEventName;
    self.eventLocationTextField.text = self.incomingLocation;
    self.eventDateTimeTextField.text = self.incomingDateAndTime;
    
    self.navigationItem.title = @"edit";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"save" style:UIBarButtonItemStylePlain target:self action:@selector(saveChanges)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)saveChanges {
    if ([self.eventNameTextField.text isEqualToString:@""]) {
        [self createAlert:@"your event must have a name" :@"oh no!"];
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"PublicEvent"];
        [query getObjectInBackgroundWithId:self.incomingEventId block:^(PFObject *event, NSError *error){
            if (!error) {
                NSLog(@"event = %@", event);
                event[@"eventName"] = self.eventNameTextField.text;
                event[@"location"] = self.eventLocationTextField.text;
                event[@"dateTime"] = self.eventDateTimeTextField.text;
                
                [event saveInBackgroundWithBlock:^(BOOL success, NSError *error){
                    if (success) {
                        [self createAlert:@"your event changes have been saved" :@"success!"];
                        self.navigationItem.title = @"saved!";
                        [NSTimer scheduledTimerWithTimeInterval:2.0
                                                         target:self
                                                       selector:@selector(setNavigationItemTitle)
                                                       userInfo:nil
                                                        repeats:NO];
                    } else {
                        NSLog(@"error = %@", [error userInfo]);
                    }
                }];

            }
        }];
    }
}

-(void)setNavigationItemTitle {
    self.navigationItem.title = @"edit";
}

-(void)createAlert:(NSString *)_message :(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:_message
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
