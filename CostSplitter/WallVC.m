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

@interface WallVC () 

@end

@implementation WallVC

NSMutableArray *autocompleteFriends;
UITableView *friendTableView;
FriendDelegate *friendDelegate;
PFUser *curUser;
NSString *code;
NSString *token;

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"Logout" sender:self];
}

# pragma mark - authentication

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    NSString *url = _webView.request.URL.absoluteString;
    // Extract the code. Use code to get access token.
    NSArray *split = [url componentsSeparatedByString:@"code="];
    if (split.count > 1) {
        code = [split objectAtIndex:1];
        //        NSLog(@"Code: %@", code);
        [self getToken:code];
    }
}

- (void)getToken:(NSString *) code {
    [PFCloud callFunctionInBackground:@"getAccessToken"
                       withParameters:@{@"code":code,
                                        @"userID":curUser.objectId}
                                block:^(NSString *result, NSError *error) {
                                    if (!error)
                                        token = result;
                                }];
}

- (IBAction)cancelPermissions:(id)sender {
    [[Venmo sharedInstance] logout];
    if ([[Venmo sharedInstance] isSessionValid] == false) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log Out" message:@"No longer have Venmo permissions" delegate:nil cancelButtonTitle:@"What a shame" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

#pragma mark - Friends
- (void)getFriends {
    [PFCloud callFunctionInBackground:@"getFriends"
                       withParameters:@{@"userID":curUser.objectId}
                                block:^(NSMutableArray *result, NSError *error) {
                                    if (!error)
                                        [self setupAutocompleteWithFriends:result];
                                }];
}

- (void)setupAutocompleteWithFriends:(NSMutableArray *) friends {
    friendTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, 320, 200) style:UITableViewStylePlain];
    friendDelegate = [[FriendDelegate alloc] initWithTableView:friendTableView andFriends:friends];
    friendTableView.delegate = friendDelegate;
    friendTableView.dataSource = friendDelegate;
    [self.view addSubview:friendTableView];
    NSLog(@"Added table view");
}











#pragma mark - Text Field
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    friendTableView.hidden = YES;
    return YES;
}

- (BOOL)textField:(UITextField *)textField
        shouldChangeCharactersInRange:(NSRange)range
        replacementString:(NSString *)string {
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];

    [friendDelegate showAutocompleteFriendsFromSubstring:substring];
    
    return YES;
}

#pragma mark - prepared methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    curUser = [PFUser currentUser];
    
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.venmo.com/v1/oauth/authorize?client_id=1777&scope=access_friends%20access_profile%20access_email%20access_phone%20access_balance&response_type=code"]]];
//    _webView.scalesPageToFit = YES;
    
    [self getFriends];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
