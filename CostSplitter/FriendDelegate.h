//
//  FriendDelegate.h
//  CostSplitter
//
//  Created by Michael Zhao on 6/28/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendDelegate : UITableViewController <UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithTableView:(UITableView *)table andFriends:(NSMutableArray *)friends;

- (void)showAutocompleteFriendsFromSubstring:(NSString *)substring;

@end
