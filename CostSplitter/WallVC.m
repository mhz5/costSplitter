//
//  WallVC.m
//  CostSplitter
//
//  Created by Michael Zhao on 6/18/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import <stdlib.h>
#import "WallVC.h"
#import "FriendDelegate.h"
#import <Parse/Parse.h>
#import <Venmo-iOS-SDK/Venmo.h>
#import "VenmoPermissionsVC.h"

@interface WallVC () 

@end

@implementation WallVC

NSDictionary *friends;
UITableView *friendTableView;
FriendDelegate *friendDelegate;
PFUser *curUser;
NSString *_token;

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"Logout" sender:self];
}

# pragma mark - authentication


#pragma mark - Friends
- (void) getFriends {
    [PFCloud callFunctionInBackground:@"getFriends"
                       withParameters:@{@"userID":curUser.objectId}
                                block:^(NSDictionary *result, NSError *error) {
                                    if (!error) {
                                        friends = result;

                                        [self setupAutocomplete];
                                        NSLog(@"Friends result:\n%@", friends);
                                    }
                                    else {
                                        NSLog(@"Error: %@", error.userInfo);

                                        [self performSegueWithIdentifier:@"SeekVenmoPermissions" sender:self];
                                    }
                                }];
}

- (void)setupAutocomplete {
    friendTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, 320, 200) style:UITableViewStylePlain];
    friendDelegate = [[FriendDelegate alloc] initWithTableView:friendTableView andFriends:friends modifyingTextView:_groupTextView];
    
    friendTableView.delegate = friendDelegate;
    friendTableView.dataSource = friendDelegate;
    _groupTextView.delegate = friendDelegate;
    
    [self.view addSubview:friendTableView];
}

#pragma mark - Text Field

#pragma mark - Venmo permissions

- (BOOL) seekVenmoPermissions {
    // If user doesn't have access token yet, request Venmo permissions.

    NSString *accessToken = [curUser objectForKey:@"access_token"];
    NSLog(@"Access token: %@", accessToken);
    if (!_token && !accessToken) {
        [self performSegueWithIdentifier:@"SeekVenmoPermissions" sender:self];
        return true;
    }
    
    return false;
}

#pragma mark - prepared methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    curUser = [PFUser currentUser];

    [self getFriends];
    
    
//    [PFCloud callFunctionInBackground:@"addGroup"
//                       withParameters:@{@"userID": curUser.objectId,
//                                        @"members": @[@"test1", @"test2"]}
//                                block:^(id object, NSError *error) {
//                                    if (!error)
//                                        NSLog(@"Added a group");
//                                    else
//                                        NSLog(@"%@", error.userInfo);
//                                }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SeekVenmoPermissions"]) {
        [[segue destinationViewController] setPFUser:curUser];
    }
}

- (void)setAccessToken:(NSString *)token {
    _token = token;
}

@end
