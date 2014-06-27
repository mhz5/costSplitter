//
//  WallVC.m
//  CostSplitter
//
//  Created by Michael Zhao on 6/18/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import <stdlib.h>
#import "WallVC.h"
#import <Parse/Parse.h>
#import <Venmo-iOS-SDK/Venmo.h>

@interface WallVC () 

@end

@implementation WallVC

NSMutableArray *friends;
NSMutableArray *autocompleteFriends;
UITableView * acTableView;
PFUser *curUser;
NSString *code;
NSString *token;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    curUser = [PFUser currentUser];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.venmo.com/v1/oauth/authorize?client_id=1777&scope=access_friends%20access_profile%20access_email%20access_phone%20access_balance&response_type=code"]]];
    _webView.scalesPageToFit = YES;
    // Array to store all friend names and profile photos.
    friends = [[NSMutableArray alloc] init];
    autocompleteFriends = [[NSMutableArray alloc] init];
    [self getFriends];
    [self setupFriendAutocomplete];
}
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"Logout" sender:self];
}

- (IBAction)cancelPermissions:(id)sender {
    [[Venmo sharedInstance] logout];
    if ([[Venmo sharedInstance] isSessionValid] == false) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log Out" message:@"No longer have Venmo permissions" delegate:nil cancelButtonTitle:@"What a shame" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

- (void)getFriends {
    [PFCloud callFunctionInBackground:@"getFriends"
                       withParameters:@{@"userID":curUser.objectId}
     
     
                                block:^(NSMutableArray *result, NSError *error) {
                                    if (!error)
                                       // NSLog(@"%@", result);
                                        [self storeFriends:result];
                                    for (int i = 0; i < [friends count]; i++)
                                        NSLog(@"%@", [friends objectAtIndex:i]);
                                }];
}

- (void)storeFriends:(NSMutableArray *) friendList {
    friends = friendList;
}

#pragma mark - Autocomplete
- (void)setupFriendAutocomplete {
    acTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, 320, 200) style:UITableViewStylePlain];
    acTableView.delegate = self;
    acTableView.dataSource = self;
    acTableView.scrollEnabled = YES;
    acTableView.hidden = YES;
    [self.view addSubview:acTableView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    acTableView.hidden = YES;
    return YES;
}

- (BOOL)textField:(UITextField *)textField
        shouldChangeCharactersInRange:(NSRange)range
        replacementString:(NSString *)string {

    acTableView.hidden = NO;
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self searchFriendsForAutocompleteWithSubstring:substring];
    
    return YES;
}

- (void)searchFriendsForAutocompleteWithSubstring:(NSString *)substring {
    [autocompleteFriends removeAllObjects];
    
    for (NSString *curString in friends) {
        NSRange substringRange = [curString.lowercaseString rangeOfString:substring.lowercaseString];
        if (substringRange.location == 0)
            [autocompleteFriends addObject:curString];
    }
    
    [acTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return autocompleteFriends.count;
}



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
