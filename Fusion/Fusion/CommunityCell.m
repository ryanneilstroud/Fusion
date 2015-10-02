//
//  CommunityCell.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 27/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "CommunityCell.h"

@implementation CommunityCell

- (void)refreshCellWithUserFriendInfo:(NSString *)fullNameOfUserFriend :(NSString *)detailsOfUserFriend :(UIImage *)profilePicOfUserFriend {
    userFriendFullName.text = fullNameOfUserFriend;
    userFriendDetails.text = detailsOfUserFriend;
    userFriendProfilePic.image = profilePicOfUserFriend;
    
    userFriendProfilePic.layer.cornerRadius = 30;
    userFriendProfilePic.clipsToBounds = YES;
    
    userFriendFullName.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
    userFriendDetails.font = [UIFont fontWithName:@"Roboto-Light" size:14.0f];

}

- (void)refreshCellWithUserAttendance:(NSString *)fullNameOfUserFriend :(NSString *)detailsOfUserFriend :(UIImage *)profilePicOfUserFriend :(UIImage *)_rsvpImage {
    userFriendFullName.text = fullNameOfUserFriend;
    userFriendDetails.text = detailsOfUserFriend;
    userFriendProfilePic.image = profilePicOfUserFriend;
    rsvpImage.image = _rsvpImage;
//    rsvpImage.hidden = NO;
    
    userFriendProfilePic.layer.cornerRadius = 30;
    userFriendProfilePic.clipsToBounds = YES;
    
    userFriendFullName.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
    userFriendDetails.font = [UIFont fontWithName:@"Roboto-Light" size:14.0f];
    
}

- (void)refreshCellWithCommunityGroupInfo:(NSString *)groupId {
    NSLog(@"id = %@", groupId);

    PFQuery *query = [PFQuery queryWithClassName:@"CommunityGroup"];
    [query getObjectInBackgroundWithId:groupId block:^(PFObject *object, NSError *error){
        if (!error) {
            
            PFFile *file = object[@"profilePic"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    communityGroupName.text = object[@"name"];
                    communityGroupDetails.text = object[@"church"];
                    communityGroupProfilePic.image = image;
                    
                    communityGroupProfilePic.layer.cornerRadius = 30;
                    communityGroupProfilePic.clipsToBounds = YES;
                    
                    communityGroupName.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
                    communityGroupDetails.font = [UIFont fontWithName:@"Roboto-Light" size:14.0f];
                }
            }];
        }
    }];
}

- (void)refreshCellWithUserInfo:(NSString *)personId {
    NSLog(@"personId = %@", personId);

    
    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:personId block:^(PFObject *object, NSError *error){
        if (!error) {
            
            PFFile *file = object[@"profilePic"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    userFriendFullName.text = object[@"fullName"];
                    userFriendDetails.text = object[@"churchName"];
                    userFriendProfilePic.image = image;
                    
                    userFriendProfilePic.layer.cornerRadius = 30;
                    userFriendProfilePic.clipsToBounds = YES;
                    
                    userFriendFullName.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
                    userFriendDetails.font = [UIFont fontWithName:@"Roboto-Light" size:14.0f];
                }
            }];
        }
    }];
}

@end