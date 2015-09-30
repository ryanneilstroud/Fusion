//
//  CustomNotificationCell.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 26/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNotificationCell : UITableViewCell
{
    IBOutlet UILabel *notificationMessage;
    IBOutlet UIImageView *notificationImage;
}

-(void)refreshCellWithInfo:(NSString*)cellMessage :(UIImage*)cellImage;

@end
