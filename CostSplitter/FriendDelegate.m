//
//  FriendDelegate.m
//  CostSplitter
//
//  Created by Michael Zhao on 6/28/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import "FriendDelegate.h"

@implementation FriendDelegate

NSMutableArray *friends;
NSMutableArray *autocompleteFriends;

- (instancetype)initWithTableView:(UITableView *)table andFriends:(NSMutableArray *)arr
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.tableView = table;
        self.tableView.scrollEnabled = YES;
        self.tableView.hidden = YES;
        friends = arr;
        autocompleteFriends = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Populate cells with autocomplete friends.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    
    cell.textLabel.text = [autocompleteFriends objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return autocompleteFriends.count;
}

// Refresh the autocomplete friends array.
- (void)showAutocompleteFriendsFromSubstring:(NSString *)substring{
    [autocompleteFriends removeAllObjects];
    
    for (NSString *curString in friends) {
        NSRange substringRange = [curString.lowercaseString rangeOfString:substring.lowercaseString];
        if (substringRange.location == 0)
            [autocompleteFriends addObject:curString];

    }
    
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

@end
