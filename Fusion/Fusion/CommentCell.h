//
//  CommentCell.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 19/9/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UITextView *comment;

-(void)updateCellWithInfo:(NSString*)_name :(NSString*)_comment :(UIImage*)_image;

@end
