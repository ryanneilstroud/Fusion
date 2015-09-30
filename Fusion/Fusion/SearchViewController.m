//
//  ViewController.m
//  Fusion
//
//  Created by Ryan Neil Stroud on 14/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCustomCell.h"
#import "PersonDetailViewController.h"
#import "GroupDetailViewController.h"
#import "NewPublishArticleViewController.h"

@interface SearchViewController ()

@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSMutableArray *arrayImages;

@property (strong, nonatomic) NSMutableArray *identifier;

@property (strong, nonatomic) NSString *selectedPerson;

@end

@implementation SearchViewController
@synthesize rowHeight;
@synthesize fromPublishArticleView;
@synthesize delegate;

-(void)viewWillDisappear:(BOOL)animated {
    [delegate sendDataToA:self.selectedPerson];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchResults = [[NSArray alloc] init];
    self.array = [[NSMutableArray alloc] init];
    self.arrayImages = [[NSMutableArray alloc] init];
    
    self.identifier = [[NSMutableArray alloc] init];

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) { /// iOS 7 or above
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,
                                    [UIFont fontWithName:@"Roboto-Light" size:20.0f], NSFontAttributeName,
                                    nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma Table View Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"searchResultFriendCell";
    
    SearchCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell){
        [tableView registerNib:[UINib nibWithNibName:@"SearchResultFriendCell" bundle:nil] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SearchCustomCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [cell refreshCellWithSearchResultsPerson:[self.searchResults objectAtIndex:indexPath.row]];
    }
    
    if (self.searchResults.count > 10) {
        [self.array removeAllObjects];
        self.searchResults = nil;
        [self.identifier removeAllObjects];
    }
}

#pragma Search Methods

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"fullName" containsString:searchText];
    [query findObjectsInBackgroundWithBlock:^(NSArray *pArray, NSError *error) {
    
//        for (int i = 0; i < pArray.count; i++) {
//            if ([[pArray[i] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
//                
//            } else if (![self.array containsObject:[pArray[i] objectId]]) {
//                [self.array addObject:[pArray[i] objectId]];
//                [self.identifier addObject:@"0"];
//            }
//        }
        
        for (int i = 0; i < pArray.count; i++) {
            if ([pArray[i][@"fullName"] isEqualToString:[PFUser currentUser][@"fullName"]]) {
            
            } else if (![self.array containsObject:pArray[i][@"fullName"]]) {
                [self.array addObject:pArray[i][@"fullName"]];
                [self.identifier addObject:@"0"];
            }
        }
    }];
    
    PFQuery *groupQuery = [PFQuery queryWithClassName:@"CommunityGroup"];
    [groupQuery whereKey:@"name" containsString:searchText];
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray *pArray, NSError *error) {
        
        
        for (int i = 0; i < pArray.count; i++) {
            if (![self.array containsObject:pArray[i][@"name"]]) {
                [self.array addObject:pArray[i][@"name"]];
                [self.identifier addObject:@"1"];
            }
        }
    }];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", searchText];
    self.searchResults = [self.array filteredArrayUsingPredicate:predicate];

}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (fromPublishArticleView == YES) {
        self.selectedPerson = [self.array objectAtIndex:indexPath.row];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSString *str = [NSString stringWithFormat:@"%@", [self.identifier objectAtIndex:indexPath.row]];
        
        if ([str isEqualToString:@"0"]) {
            //person
            __block NSString *outgoingPersonId = @"";
            PFQuery *query = [PFUser query];
            [query whereKey:@"fullName" equalTo:self.searchResults[indexPath.row]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
                if (!error) {
                    outgoingPersonId = [array[0] objectId];
                    PersonDetailViewController *personDetailViewController = [[PersonDetailViewController alloc] initWithNibName:@"PersonDetailViewController" bundle:nil];
                    personDetailViewController.incomingPersonId = outgoingPersonId;
                    [self.navigationController pushViewController:personDetailViewController animated:YES];
                }
            }];
        } else if ([str isEqualToString:@"1"]) {
            __block NSString *outgoingGroupId = @"";
            PFQuery *query = [PFQuery queryWithClassName:@"CommunityGroup"];
            [query whereKey:@"name" equalTo:self.searchResults[indexPath.row]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
                if (!error) {
                    outgoingGroupId = [array[0] objectId];
                    GroupDetailViewController *groupDetailViewController = [[GroupDetailViewController alloc] initWithNibName:@"GroupDetailView" bundle:nil];
                    groupDetailViewController.name = [self.searchResults objectAtIndex:indexPath.row];
                    groupDetailViewController.incomingGroupId = outgoingGroupId;
                    [self.navigationController pushViewController:groupDetailViewController animated:YES];
                }
            }];
        }
    }
}

- (IBAction)cancelSearch:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end