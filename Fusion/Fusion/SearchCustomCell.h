
//
//  SearchCustomCell.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 28/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SearchCustomCell : UITableViewCell
{
    IBOutlet UIImageView *resultPersonProfilePic;
    IBOutlet UILabel *resultPersonName;
    
    IBOutlet UILabel *eventTitle;
    IBOutlet UIImageView *eventCreator;
    IBOutlet UIImageView *eventImage;
    IBOutlet UILabel *eventHeadline;
    IBOutlet UILabel *eventDateAndTime;
    IBOutlet UILabel *eventLocation;
    IBOutlet UIImageView *eventMap;

}
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UITextView *comment;


-(void)updateCellWithInfo:(NSString*)_name :(NSString*)_comment :(UIImage*)_image;

- (IBAction)addFriendButton:(UIButton *)sender;

- (void)refreshCellWithSearchResultsPerson: (NSString*)resultNameOfPerson :(UIImage*)resultProfilePicOfPerson;

- (void)refreshCellWithSearchResultsPerson:(NSString *)resultNameOfPerson;

-(void)refreshCellWithEventInfo:(NSString*)titleText :(NSString*)headlineOfEvent : (NSString*)dateAndTimeOfEvent :(NSString*)locationOfEvent :(UIImage*)imageOfEventCreator :(UIImage*)imageForEvent :(UIImage*)mapOfLocation;

@end