//
//  NewEventViewController.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 12/9/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "NewEventViewController.h"

@interface NewEventViewController ()

@end

@implementation NewEventViewController

- (void)viewDidLoad {
    NSLog(@"Hello World!");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
}

- (IBAction)createEventBarButtonItem:(UIBarButtonItem *)sender {
    
    PFQuery *userQuery = [PFUser query];
    [userQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error){
        if (!error) {
            if ([object[@"tempStorage"][0] isEqualToString:@"CommunityGroupMessage"]) {
                PFObject *event = [PFObject objectWithClassName:@"GroupEvent"];
                event[@"eventName"] = self.eventNameTextField.text;
                event[@"location"] = self.locationTextField.text;
                event[@"dateTime"] = self.dateAndTimeTextField.text;
                event[@"going"] = [[NSMutableArray alloc] initWithObjects:[[PFUser currentUser] objectId], nil];
                event[@"maybe"] = [[NSMutableArray alloc] init];
                event[@"notGoing"] = [[NSMutableArray alloc] init];

                event[@"groupId"] = object[@"tempStorage"][1];

                [event setObject:[PFUser currentUser] forKey:@"creator"];
                
                [event saveInBackgroundWithBlock:^(BOOL success, NSError *error ) {
                    if (success) {
                        NSLog(@"saved successfully");
                    } else {
                        NSLog(@"somthings wrong");
                    }
                }];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                PFObject *event = [PFObject objectWithClassName:@"PublicEvent"];
                event[@"eventName"] = self.eventNameTextField.text;
                event[@"location"] = self.locationTextField.text;
                event[@"dateTime"] = self.dateAndTimeTextField.text;
                event[@"going"] = [[NSMutableArray alloc] initWithObjects:[[PFUser currentUser] objectId], nil];
                event[@"maybe"] = [[NSMutableArray alloc] init];
                event[@"notGoing"] = [[NSMutableArray alloc] init];

                [event setObject:[PFUser currentUser] forKey:@"creator"];
                
                [event saveInBackgroundWithBlock:^(BOOL success, NSError *error ) {
                    if (success) {
                        NSLog(@"saved successfully");
                    } else {
                        NSLog(@"somthings wrong");
                    }
                }];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];

}

- (void)keyboardWillShow:(NSNotification *) notification {
    NSLog(@"hello, I'm keyboard");
    
    // Get the size of the keyboard.
    int keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    NSLog(@"%f", self.toolbar.frame.size.height);
    NSLog(@"%d", keyboardHeight);
    
    self.toolbar.frame = CGRectMake(self.toolbar.frame.origin.x, self.view.frame.size.height - keyboardHeight - self.toolbar.frame.size.height, self.toolbar.frame.size.width, self.toolbar.frame.size.height);
}

- (void)keyboardWillHide:(NSNotification *) notification {
    NSLog(@"goodbye");
}

- (void)textViewDidChange:(UITextView *)textView {
//    NSLog(@"textview text = %@", self. .text);
}

@end