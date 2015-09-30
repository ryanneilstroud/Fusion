//
//  CustomNotificationCell.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 26/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "CustomNotificationCell.h"

@implementation CustomNotificationCell

-(void)refreshCellWithInfo:(NSString*)cellMessage :(UIImage*)cellImage {
    notificationImage.image = cellImage;
    notificationMessage.text = cellMessage;
    notificationMessage.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
    
    notificationImage.layer.cornerRadius = 30;
    notificationImage.clipsToBounds = YES;
}

@end