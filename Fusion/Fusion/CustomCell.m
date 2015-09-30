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
//    FriendsPostSelectionViewController *vc = [[FriendsPostSelectionViewController alloc] initWithNibName:@"FriendsPostSelection" bundle:nil];
//    vc.incomingPostId = [self.objectId objectAtIndex:indexPath.row];
//    vc.incomingName = [self.names objectAtIndex:indexPath.row];
//    vc.incomingMessage = [self.messages objectAtIndex:indexPath.row];
//    vc.incomingProfilePic = [self.images objectAtIndex:indexPath.row];
//    vc.incomingSharedImages = [self.sharedImages objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)refreshCellWithInfo:(NSString *)_objectId {
    NSLog(@"objectId = %@", _objectId);
}

-(void)refreshCellWithInfo:(NSString*)titleText captionText:(NSString*)captionText imagePicture:(UIImage*)imagePicture :(NSDate*)_timestamp :(NSString*)_objectId :(NSString*)_favorited
{
    
    if ([_favorited integerValue]) {
        [favoriteButtonOutlet setImage:[UIImage imageNamed:@"star_ffc700_32.png"] forState:UIControlStateNormal];
    } else {
        [favoriteButtonOutlet setImage:[UIImage imageNamed:@"star-o_636363_32.png"] forState:UIControlStateNormal];
    }
    
    objectId = _objectId;
    
    friendName.text = titleText;
    friendMessage.text = captionText;
    friendProfilePicture.image = imagePicture;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a, dd"];
    
    NSString *stringFromDate = [NSString stringWithFormat:@"%@ Sep",[formatter stringFromDate:_timestamp]];
    
    timestamp.text = stringFromDate;
    
    friendProfilePicture.layer.cornerRadius = 30;
    friendProfilePicture.clipsToBounds = YES;
    
    friendName.font = [UIFont fontWithName:@"Roboto-Regular" size:18.0f];
    friendMessage.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
    
//    NSString *testString = @"Hello http://google.com world";
//    NSDataDetector *detect = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
//    NSArray *matches = [detect matchesInString:testString options:0 range:NSMakeRange(0, [testString length])];
//    NSLog(@"%@", matches);
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

@end
