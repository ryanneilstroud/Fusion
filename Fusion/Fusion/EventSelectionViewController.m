//
//  EventSelectionViewController.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 13/9/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "EventSelectionViewController.h"
#import "CommunityCell.h"
#import "EditEventViewController.h"

@interface EventSelectionViewController ()
@property (strong, nonatomic) NSMutableArray *names;
@property (strong, nonatomic) NSMutableArray *profilePics;
@property (strong, nonatomic) NSMutableArray *details;
@property (strong, nonatomic) NSMutableArray *rsvpImages;

@end

@implementation EventSelectionViewController
@synthesize incomingEventId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.profilePic.image = self.incomingProfilePic;
    self.place.text = self.incomingPlace;
    self.dateAndTime.text = self.incomingDateAndTime;
    
    self.profilePic.layer.cornerRadius = 50;
    self.profilePic.clipsToBounds = YES;
    
    self.place.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
    self.dateAndTime.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];
    self.numberOfPeopleGoingLabel.font = [UIFont fontWithName:@"Roboto-Light" size:18.0f];

    self.names = [[NSMutableArray alloc] init];
    self.profilePics = [[NSMutableArray alloc] init];
    self.details = [[NSMutableArray alloc] init];
    self.rsvpImages = [[NSMutableArray alloc] init];
    
    [self.tableview setTranslatesAutoresizingMaskIntoConstraints:YES];
    self.tableview.frame = CGRectMake(0, self.tableview.frame.origin.y, screenRect.size.width, self.tableview.frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated {
    
    PFQuery *query = [PFQuery queryWithClassName:@"PublicEvent"];
    [query getObjectInBackgroundWithId:incomingEventId block:^(PFObject *event, NSError *error){
        if (!error) {
            
            self.navigationItem.title = event[@"eventName"];
            
            self.eventName.text = @"";
            self.place.text = event[@"location"];
            self.dateAndTime.text = event[@"dateTime"];
            
            [self.names removeAllObjects];
            [self.profilePics removeAllObjects];
            [self.details removeAllObjects];
            [self.rsvpImages removeAllObjects];
            
            [self setUpTable: event];
            
            if ([event[@"going"] containsObject:[[PFUser currentUser] objectId]]) {
                self.rsvpSegmentControl.selectedSegmentIndex = 0;
            } else if ([event[@"maybe"] containsObject:[[PFUser currentUser] objectId]]) {
                self.rsvpSegmentControl.selectedSegmentIndex = 1;
            } else if ([event[@"notGoing"] containsObject:[[PFUser currentUser] objectId]]) {
                self.rsvpSegmentControl.selectedSegmentIndex = 2;
            }
            
            if ([event[@"going"] count] == 1) {
                self.numberOfPeopleGoingLabel.text = [NSString stringWithFormat:@"%lu person is going", [event[@"going"] count]];
            } else {
                self.numberOfPeopleGoingLabel.text = [NSString stringWithFormat:@"%lu people are going", [event[@"going"] count]];
            }
            
            if (event[@"creator"] == [PFUser currentUser]) {
                NSLog(@"the creator!");
                UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"edit" style:UIBarButtonItemStylePlain target:self action:@selector(editEvent)];
                self.navigationItem.rightBarButtonItem = rightButton;
                [self.navigationController.navigationBar pushNavigationItem:self.navigationItem animated:YES];
                
            } else {
                NSLog(@"whos that?");
            }
        }
    }];
}

- (void)editEvent {
    EditEventViewController *vc = [[EditEventViewController alloc] initWithNibName:@"EditEventView" bundle:nil];
    vc.incomingEventName = self.incomingEventName;
    vc.incomingLocation = self.incomingPlace;
    vc.incomingDateAndTime = self.incomingDateAndTime;
    vc.incomingEventId = self.incomingEventId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)confirmRsvp:(UISegmentedControl *)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"PublicEvent"];
    [query getObjectInBackgroundWithId:incomingEventId block:^(PFObject *event, NSError *error){
        if (!error) {
            
            [event[@"going"] removeObject:[[PFUser currentUser] objectId]];
            [event[@"maybe"] removeObject:[[PFUser currentUser] objectId]];
            [event[@"notGoing"] removeObject:[[PFUser currentUser] objectId]];
            
            NSString *rsvp = @"";
            
            if (sender.selectedSegmentIndex == 0) {
                rsvp = @"going";
            } else if (sender.selectedSegmentIndex == 1) {
                rsvp = @"maybe";
            } else if (sender.selectedSegmentIndex == 2) {
                rsvp = @"notGoing";
            }
            
            [event[rsvp] addObject:[[PFUser currentUser] objectId]];
        
            if ([event[@"going"] count] == 1) {
                self.numberOfPeopleGoingLabel.text = [NSString stringWithFormat:@"%lu person is going", [event[@"going"] count]];
            } else {
                self.numberOfPeopleGoingLabel.text = [NSString stringWithFormat:@"%lu people are going", [event[@"going"] count]];
            }
            [event saveInBackgroundWithBlock:^(BOOL success, NSError *error){
                if (success) {
                    [self.names removeAllObjects];
                    [self.profilePics removeAllObjects];
                    [self.details removeAllObjects];
                    [self.rsvpImages removeAllObjects];
                    
                    [self setUpTable:event];
                }
            }];
            
        }
    }];
}

- (void)setUpTable:(PFObject *)_event {
    NSArray *array = [[NSArray alloc] initWithObjects:@"going", @"maybe", @"notGoing", nil];
    
    for (int j = 0; j < array.count; j++) {
        
        for (int i = 0; i < [_event[array[j]] count]; i++) {
            PFQuery *query = [PFUser query];
            [query getObjectInBackgroundWithId:_event[array[j]][i] block:^(PFObject *person, NSError *error){
                if (!error){
                    
                    PFFile *file = person[@"profilePic"];
                    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if (!error) {
                            
                            UIImage *image = [UIImage imageWithData:data];
                            
                            [self.names addObject:person[@"fullName"]];
                            [self.details addObject:person[@"communityGroupName"]];
                            [self.profilePics addObject:image];
                            
                            if ([array[j] isEqualToString:@"going"]) {
                                [self.rsvpImages addObject:[UIImage imageNamed:@"check-circle_26ff03_32.png"]];
                            } else if ([array[j] isEqualToString:@"maybe"]) {
                                [self.rsvpImages addObject:[UIImage imageNamed:@"question-circle_ffc700_32.png"]];
                            } else {
                                [self.rsvpImages addObject:[UIImage imageNamed:@"times-circle_fa4141_32.png"]];
                            }
                            
                            if (self.names.count > 0) {
                                [self.tableview reloadData];
                            }
                        }
                    }];
                }
            }];
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.names count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* segmentedCell = @"friendCell";
    NSString* nibName = @"FriendCell";
    
    CommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:segmentedCell];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:segmentedCell];
        cell = [tableView dequeueReusableCellWithIdentifier:segmentedCell];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(CommunityCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell refreshCellWithUserAttendance:[self.names objectAtIndex:indexPath.row]
                                       :[self.details objectAtIndex:indexPath.row]
                                       :[self.profilePics objectAtIndex:indexPath.row]
                                       :[self.rsvpImages objectAtIndex:indexPath.row]];
}


@end