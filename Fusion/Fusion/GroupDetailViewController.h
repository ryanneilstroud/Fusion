//
//  Header.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 9/9/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GroupDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UIButton *joinButtonOutlet;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *church;
@property (strong, nonatomic) NSString *incomingGroupId;
@property (strong, nonatomic) IBOutlet UILabel *groupName;
@property (strong, nonatomic) IBOutlet UILabel *churchName;

- (IBAction)joinButton:(UIButton *)sender;
@end
