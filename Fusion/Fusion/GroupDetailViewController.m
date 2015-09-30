//
//  GroupSelectionViewController.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 9/9/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "GroupDetailViewController.h"

@interface GroupDetailViewController ()
@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSString *COMMUNTIY_GROUP;

@end

@implementation GroupDetailViewController
@synthesize incomingGroupId;

- (void)viewDidLoad {
    NSLog(@"Hello");
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    [self.profilePic setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.joinButtonOutlet setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    self.profilePic.frame = CGRectMake(screenRect.size.width/2 - self.profilePic.frame.size.width/2, 20, self.profilePic.frame.size.width, self.profilePic.frame.size.height);
    self.joinButtonOutlet.frame = CGRectMake(0, self.profilePic.frame.size.height + 40, screenRect.size.width, self.joinButtonOutlet.frame.size.height);

    self.groupName.font = [UIFont fontWithName:@"Roboto-Light" size:24.0f];
    self.churchName.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
    
    self.COMMUNTIY_GROUP = @"CommunityGroup";
    
//    self.navigationItem.title = self.name;
    
    //pull down details of person being viewed
    PFQuery *query = [PFQuery queryWithClassName:self.COMMUNTIY_GROUP];
    [query whereKey:@"name" equalTo:self.name];
    [query findObjectsInBackgroundWithBlock:^(NSArray *group, NSError *error) {
        
        self.groupName.text = self.name;
        self.churchName.text = group[0][@"church"];
        
        self.groupId = [group[0] objectId];
        
        PFFile *file = group[0][@"profilePic"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                // image can now be set on a UIImageView
                
                self.profilePic.image = image;
                
                self.profilePic.layer.cornerRadius = 100;
                self.profilePic.clipsToBounds = YES;
            }
        }];
    
    }];
    
    [self groupMemberStatus];
}

- (void)groupMemberStatus {
    NSLog(@"checking group member status");
    PFQuery *thisGroup = [PFQuery queryWithClassName:self.COMMUNTIY_GROUP];
    [thisGroup getObjectInBackgroundWithId:incomingGroupId block:^(PFObject *community, NSError *error){
        if (!error) {
            NSLog(@"groupId = %@",incomingGroupId);
            if ([community[@"participants"] containsObject:[[PFUser currentUser] objectId]]) {
                if ([[[PFUser currentUser] objectId] isEqualToString:[community[@"admin"] objectId]]) {
                    NSLog(@"admin");
                    [self.joinButtonOutlet setTitle:@"admin" forState:UIControlStateNormal];
                    [self.joinButtonOutlet setEnabled:NO];
                    self.joinButtonOutlet.backgroundColor = [UIColor colorWithRed:0 green:0.471 blue:1 alpha:1];
                } else {
                    [self.joinButtonOutlet setTitle:@"leave community" forState:UIControlStateNormal];
                    self.joinButtonOutlet.backgroundColor = [UIColor redColor];
                }
            } else {
                NSLog(@"does not contain");

                [self.joinButtonOutlet setTitle:@"join" forState:UIControlStateNormal];
                self.joinButtonOutlet.backgroundColor = [UIColor colorWithRed:0 green:0.471 blue:1 alpha:1];
            }
            
        }
        
    }];
}

- (IBAction)joinButton:(UIButton *)sender {

    //if already part of the community group
    //text = leave community
    
    PFQuery *thisGroup = [PFQuery queryWithClassName:self.COMMUNTIY_GROUP];
    [thisGroup getObjectInBackgroundWithId:incomingGroupId block:^(PFObject *community, NSError *error){
        if (!error) {
            
            if ([community[@"participants"] containsObject:[[PFUser currentUser] objectId]]) {
                [self.joinButtonOutlet setTitle:@"join" forState:UIControlStateNormal];
                self.joinButtonOutlet.backgroundColor = [UIColor colorWithRed:0 green:0.471 blue:1 alpha:1];
                
                [community[@"participants"] removeObject:[[PFUser currentUser] objectId]];
            } else {
                [self.joinButtonOutlet setTitle:@"leave community" forState:UIControlStateNormal];
                self.joinButtonOutlet.backgroundColor = [UIColor redColor];
                
                [community[@"participants"] addObject:[[PFUser currentUser] objectId]];
            }
            
            [community saveInBackground];
        }
        
    }];
    
    
//    [joinCommunityRequest saveInBackground];
}

@end