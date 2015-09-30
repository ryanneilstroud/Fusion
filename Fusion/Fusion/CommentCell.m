//
//  CommentCell.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 19/9/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

-(void)updateCellWithInfo:(NSString*)personName :(NSString*)personComment :(UIImage*)_image {
    self.name.text = personName;
    self.comment.text = personComment;
    self.profilePic.image = _image;
    
    self.profilePic.layer.cornerRadius = 25;
    self.profilePic.clipsToBounds = YES;
    
    self.name.font = [UIFont fontWithName:@"Roboto-Regular" size:18.0f];
    self.comment.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
}

@end