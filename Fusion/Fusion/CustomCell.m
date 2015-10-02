//
//  CustomSearchResultCell.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 24/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize objectId;
@synthesize eventId;

- (IBAction)favoriteButton:(UIButton *)sender {
    
    PFQuery *query = [PFQuery queryWithClassName:@"NewsFeedMessage"];
    [query getObjectInBackgroundWithId:objectId block:^(PFObject *object, NSError *error){
        if (!error) {
            NSLog(@"object = %@", object);
            if (![object[@"favorited"] containsObject:[[PFUser currentUser] objectId]]) {
                NSLog(@"not favorited");
                [favoriteButtonOutlet setImage:[UIImage imageNamed:@"star_ffc700_32.png"] forState:UIControlStateNormal];
                [object[@"favorited"] addObject:[[PFUser currentUser] objectId]];
            } else {
                NSLog(@"favorited");
                [favoriteButtonOutlet setImage:[UIImage imageNamed:@"star-o_636363_32.png"] forState:UIControlStateNormal];
                [object[@"favorited"] removeObject:[[PFUser currentUser] objectId]];

            }
            [object saveInBackground];
        }
    }];
}

- (IBAction)commentButton:(UIButton *)sender {

}

-(void)refreshCellWithInfo:(NSString *)_objectId {

}

-(void)refreshCellWithImageInfo:(NSString*)titleText captionText:(NSString*)captionText imagePicture:(UIImage*)imagePicture :(UIImage*)sharedPhoto :(NSDate*)_timestamp :(NSString*)_objectId  :(NSString*)_favorited
{
    
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    friendPictureWithImage.frame = CGRectMake(0, friendPictureWithImage.frame.origin.y, screenRect.size.width, friendPictureWithImage.frame.size.height);
//    
//    NSLog(@"height = %f",self.frame.size.height);
    
    if ([_favorited integerValue]) {
        [favoriteButtonOutlet setImage:[UIImage imageNamed:@"star_ffc700_32.png"] forState:UIControlStateNormal];
    } else {
        [favoriteButtonOutlet setImage:[UIImage imageNamed:@"star-o_636363_32.png"] forState:UIControlStateNormal];
    }
    
    self.objectId = _objectId;
    
    friendNameWithImage.text = titleText;
    friendMessageWithImage.text = captionText;
    friendProfilePictureWithImage.image = imagePicture;
    friendPictureWithImage.image = sharedPhoto;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a, dd"];
    
    NSString *stringFromDate = [NSString stringWithFormat:@"%@ Sep",[formatter stringFromDate:_timestamp]];
    
    timestampWithImage.text = stringFromDate;
    
    friendProfilePictureWithImage.layer.cornerRadius = 30;
    friendProfilePictureWithImage.clipsToBounds = YES;
    
    friendNameWithImage.font = [UIFont fontWithName:@"Roboto-Regular" size:18.0f];
    friendMessageWithImage.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
}

-(void)refreshCellWithEventInfo:(NSString *)titleText :(NSString *)headlineOfEvent :(NSString *)dateAndTimeOfEvent :(NSString *)locationOfEvent :(UIImage *)imageOfEventCreator :(UIImage *)imageForEvent :(UIImage *)mapOfLocation :(NSString *)_eventId :(NSString *)_rsvp {
    
    self.eventId = _eventId;
    
    if ([_rsvp integerValue] == 0) {
        rsvpSegmentControl.selectedSegmentIndex = 0;
    } else if ([_rsvp integerValue] == 1) {
        rsvpSegmentControl.selectedSegmentIndex = 1;
    } else if ([_rsvp integerValue] == 2) {
        rsvpSegmentControl.selectedSegmentIndex = 2;
    }
    
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

- (IBAction)rsvpAttendance:(UISegmentedControl *)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"PublicEvent"];
    [query getObjectInBackgroundWithId:self.eventId block:^(PFObject *event, NSError *error){
        if (!error) {
            
            [event[@"going"] removeObject:[[PFUser currentUser] objectId]];
            [event[@"maybe"] removeObject:[[PFUser currentUser] objectId]];
            [event[@"notGoing"] removeObject:[[PFUser currentUser] objectId]];
            
            NSString *rsvp = @"";
            
            if (sender.selectedSegmentIndex == 0) {
                rsvp = @"going";
            } else if (sender.selectedSegmentIndex == 1) {
                rsvp = @"maybe";
            } else if (sender.selectedSegmentIndex == 2) {
                rsvp = @"notGoing";
            }
            
            [event[rsvp] addObject:[[PFUser currentUser] objectId]];
            [event saveInBackground];

        }
    }];
}

-(void)refreshCellWithFriendsWall:(NSString *)_objectId {
    NSLog(@"test");
    PFQuery *query = [PFQuery queryWithClassName:@"NewsFeedMessage"];
    [query getObjectInBackgroundWithId:_objectId block:^(PFObject *object, NSError *error){
        if (!error) {
            
            NSLog(@"objectId = %@", _objectId);
            NSLog(@"name = %@", object);
            
            friendName.text = object[@"creator"][@"fullName"];
            friendMessage.text = object[@"message"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"hh:mm a, dd"];
            
            timestamp.text = [formatter stringFromDate:[object createdAt]];
            
            friendName.font = [UIFont fontWithName:@"Roboto-Regular" size:18.0f];
            friendMessage.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
            
            PFFile *file = object[@"creator"][@"profilePic"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    
                    objectId = _objectId;
                    
                    friendProfilePicture.image = image;
                    friendProfilePicture.layer.cornerRadius = 30;
                    friendProfilePicture.clipsToBounds = YES;
                    
                    if ([object[@"favorited"] containsObject:[[PFUser currentUser] objectId]]) {
                        [favoriteButtonOutlet setImage:[UIImage imageNamed:@"star_ffc700_32.png"] forState:UIControlStateNormal];
                    } else {
                        [favoriteButtonOutlet setImage:[UIImage imageNamed:@"star-o_636363_32.png"] forState:UIControlStateNormal];
                    }
                    
                }
            }];
        } else {
            NSLog(@"error = %@", [error userInfo]);
        }
    }];}

-(void)refreshCellWithMessage:(NSString *)_objectId {
    NSLog(@"refresh");
    
    friendName.hidden = YES;
    friendMessage.hidden = YES;
    timestamp.hidden = YES;
    friendProfilePicture.hidden = YES;
    
    friendName.text = @"";
    friendMessage.text = @"";
    timestamp.text = @"";
    friendProfilePicture.image = nil;
    
    PFQuery *query = [PFQuery queryWithClassName:@"NewsFeedMessage"];
    [query getObjectInBackgroundWithId:_objectId block:^(PFObject *object, NSError *error){
        if (!error) {
            
            NSLog(@"objectId = %@", _objectId);
            NSLog(@"name = %@", object);

            friendName.text = object[@"creator"][@"fullName"];
            friendMessage.text = object[@"message"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"hh:mm a, dd"];
            
            timestamp.text = [formatter stringFromDate:[object createdAt]];
            
            friendName.font = [UIFont fontWithName:@"Roboto-Regular" size:18.0f];
            friendMessage.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
            
            PFFile *file = object[@"creator"][@"profilePic"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    
                    objectId = _objectId;
                    
                    friendProfilePicture.image = image;
                    friendProfilePicture.layer.cornerRadius = 30;
                    friendProfilePicture.clipsToBounds = YES;
                    
                    if ([object[@"favorited"] containsObject:[[PFUser currentUser] objectId]]) {
                        [favoriteButtonOutlet setImage:[UIImage imageNamed:@"star_ffc700_32.png"] forState:UIControlStateNormal];
                    } else {
                        [favoriteButtonOutlet setImage:[UIImage imageNamed:@"star-o_636363_32.png"] forState:UIControlStateNormal];
                    }
                    
                    friendName.hidden = NO;
                    friendMessage.hidden = NO;
                    timestamp.hidden = NO;
                    friendProfilePicture.hidden = NO;

                }
            }];
        } else {
            NSLog(@"error = %@", [error userInfo]);
        }
    }];
}

@end
