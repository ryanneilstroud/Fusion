//
//  ViewController.h
//  Fusion
//
//  Created by Ryan Neil Stroud on 14/8/15.
//  Copyright (c) 2015 Ryan Stroud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol senddataProtocol <NSObject>

-(void)sendDataToA:(NSString *)selectedPerson;

@end

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate>

@property int rowHeight;

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic) BOOL fromPublishArticleView;

@property(nonatomic,assign)id delegate;

- (IBAction)cancelSearch:(id)sender;
@end