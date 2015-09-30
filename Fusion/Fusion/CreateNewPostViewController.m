//
//  UIViewController+CreateNewPostViewController.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 28/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "CreateNewPostViewController.h"
#import "NewPublishArticleViewController.h"

@implementation CreateNewPostViewController

- (void)viewDidLoad {
        
//     self.postMessageButtonOutlet.enabled = NO;
//     [[NSNotificationCenter defaultCenter] addObserver:self
//                                              selector:@selector(textFieldDidBeginEditing:)
//                                                  name:UITextFieldTextDidChangeNotification
//                                                object:self.postNewTextView];
}

//- (void)textDidtextFieldDidBeginEditingChange:(NSNotification *)notification {
//    // Do whatever you like to respond to text changes here.
//    NSLog(@"hello");
//    if (![self.postNewTextView.text isEqualToString:@""]) {
//        self.postMessageButtonOutlet.enabled = YES;
//    } else {
//        self.postMessageButtonOutlet.enabled = NO;
//    }
//}

- (IBAction)cancelCreateNewPost:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)segementedControl:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            NSLog(@"0");
            self.singleContainerView.hidden = NO;
            self.eventContainerView.hidden = YES;
            break;
        case 1:
            NSLog(@"1");
            self.eventContainerView.hidden = NO;
            self.singleContainerView.hidden = YES;
            break;
        default:
            break;
    }
}

@end
