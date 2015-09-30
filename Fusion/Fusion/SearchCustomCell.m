//
//  UITableViewCell+SearchCustomCell.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 28/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "SearchCustomCell.h"

@implementation SearchCustomCell


- (IBAction)addFriendButton:(UIButton *)sender {
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
    }
}

- (void)refreshCellWithSearchResultsPerson:(NSString *)resultNameOfPerson :(UIImage *)resultProfilePicOfPerson {

    resultPersonName.text = resultNameOfPerson;
    resultPersonProfilePic.image = resultProfilePicOfPerson;
    
    resultPersonProfilePic.layer.cornerRadius = 30;
    resultPersonProfilePic.clipsToBounds = YES;
}

- (void)refreshCellWithSearchResultsPerson:(NSString *)resultNameOfPerson {
    
    resultPersonName.text = resultNameOfPerson;
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"fullName" containsString:resultNameOfPerson];
    [query findObjectsInBackgroundWithBlock:^(NSArray *pArray, NSError *error) {
        
        PFFile *file = pArray[0][@"profilePic"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                // image can now be set on a UIImageView
                
                resultPersonProfilePic.image = image;
            }
        }];
        
    }];
    
    PFQuery *groupQuery = [PFQuery queryWithClassName:@"CommunityGroup"];
    [groupQuery whereKey:@"name" containsString:resultNameOfPerson];
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray *pArray, NSError *error) {
        
        PFFile *file = pArray[0][@"profilePic"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                // image can now be set on a UIImageView
                
                resultPersonProfilePic.image = image;
            }
        }];
        
    }];
    //    resultPersonProfilePic.image = ;
    
    resultPersonProfilePic.layer.cornerRadius = 30;
    resultPersonProfilePic.clipsToBounds = YES;
}

-(void)updateCellWithInfo:(NSString*)personName :(NSString*)personComment :(UIImage*)_image {
    self.name.text = personName;
    self.comment.text = personComment;
    self.profilePic.image = _image;
    
    self.profilePic.layer.cornerRadius = 25;
    self.profilePic.clipsToBounds = YES;
    
    self.name.font = [UIFont fontWithName:@"Roboto-Regular" size:18.0f];
    self.comment.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
}

-(void)refreshCellWithEventInfo:(NSString *)titleText :(NSString *)headlineOfEvent :(NSString *)dateAndTimeOfEvent :(NSString *)locationOfEvent :(UIImage *)imageOfEventCreator :(UIImage *)imageForEvent :(UIImage *)mapOfLocation {
    eventTitle.text = titleText;
    eventCreator.image = imageOfEventCreator;
    //    eventImage.image = imageForEvent;
    eventHeadline.text = headlineOfEvent;
    eventDateAndTime.text = dateAndTimeOfEvent;
    eventLocation.text = locationOfEvent;
    //    eventMap.image = mapOfLocation;
    
    eventTitle.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
    eventHeadline.font = [UIFont fontWithName:@"Roboto-Regular" size:18.0f];
    eventDateAndTime.font = [UIFont fontWithName:@"Roboto-Light" size:16.0f];;
    eventLocation.font = [UIFont fontWithName:@"Roboto-Light" size:16.0f];
    
    eventCreator.layer.cornerRadius = 30;
    eventCreator.clipsToBounds = YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    return YES;
}

@end
