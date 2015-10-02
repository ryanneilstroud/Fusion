//
//  CommunityCell.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 27/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CommunityCell : UITableViewCell
{
    IBOutlet UIImageView *userFriendProfilePic;
    IBOutlet UILabel *userFriendFullName;
    IBOutlet UILabel *userFriendDetails;
    
    IBOutlet UIImageView *communityGroupProfilePic;
    IBOutlet UILabel *communityGroupName;
    IBOutlet UILabel *communityGroupDetails;
    
    IBOutlet UIImageView *rsvpImage;
}

- (void)refreshCellWithUserFriendInfo:(NSString *)fullNameOfUserFriend :(NSString *)detailsOfUserFriend :(UIImage *)profilePicOfUserFriend;

- (void)refreshCellWithUserAttendance:(NSString *)fullNameOfUserFriend :(NSString *)detailsOfUserFriend :(UIImage *)profilePicOfUserFriend :(UIImage *)rsvpImage;

//- (void)refreshCellWithCommunityGroupInfo:(NSString *)nameOfCommunityGroup :(NSString *)detailsOfCommunityGroup :(UIImage *)profilePicOfCommunityGroup;
- (void)refreshCellWithCommunityGroupInfo:(NSString *)groupId;
- (void)refreshCellWithUserInfo:(NSString *)personId;

@end
