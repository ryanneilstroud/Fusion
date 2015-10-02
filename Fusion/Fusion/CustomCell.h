//
//  CustomSearchResultCell.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 24/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CustomCell : UITableViewCell
{
    IBOutlet UILabel *friendName;
    IBOutlet UITextView *friendMessage;
    IBOutlet UIImageView *friendProfilePicture;
    IBOutlet UIImageView *friendPicture;
    
    IBOutlet UILabel *timestampWithImage;
    IBOutlet UILabel *friendNameWithImage;
    IBOutlet UITextView *friendMessageWithImage;
    IBOutlet UIImageView *friendProfilePictureWithImage;
    IBOutlet UIImageView *friendPictureWithImage;
    IBOutlet UILabel *timestamp;
    
    IBOutlet UILabel *eventTitle;
    IBOutlet UIImageView *eventCreator;
    IBOutlet UIImageView *eventImage;
    IBOutlet UILabel *eventHeadline;
    IBOutlet UILabel *eventDateAndTime;
    IBOutlet UILabel *eventLocation;
    IBOutlet UIImageView *eventMap;
    IBOutlet UIButton *favoriteButtonOutlet;
    IBOutlet UIButton *commentButtonOutlet;
    IBOutlet UISegmentedControl *rsvpSegmentControl;
}
- (IBAction)rsvpAttendance:(UISegmentedControl *)sender;

@property (strong, nonatomic) NSString* objectId;
@property (strong, nonatomic) NSString* eventId;

- (IBAction)favoriteButton:(UIButton *)sender;
- (IBAction)commentButton:(UIButton *)sender;

-(void)refreshCellWithInfo:(NSString *)_objectId;

//-(void)refreshCellWithInfo:(NSString*)titleText captionText:(NSString*)captionText imagePicture:(UIImage*)imagePicture :(NSDate*)_timestamp :(NSString *)objectId :(NSString*)favorited;

-(void)refreshCellWithImageInfo:(NSString*)titleText captionText:(NSString*)captionText imagePicture:(UIImage*)imagePicture :(UIImage*)sharedPhoto :(NSDate*)_timestamp :(NSString*)_objectId :(NSString*)favorited;

-(void)refreshCellWithEventInfo:(NSString*)titleText :(NSString*)headlineOfEvent : (NSString*)dateAndTimeOfEvent :(NSString*)locationOfEvent :(UIImage*)imageOfEventCreator :(UIImage*)imageForEvent :(UIImage*)mapOfLocation :(NSString *)eventId :(NSString *)rsvp;

-(void)refreshCellWithMessage:(NSString *)_objectId;

-(void)refreshCellWithFriendsWall:(NSString *)_objectId;

@end
