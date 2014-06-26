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
    
    // Array to store all friend names and profile photos.
    friends = [[NSMutableArray alloc] init];
    autocompleteFriends = [[NSMutableArray alloc] init];
    [self getFriends];
    [self setupFriendAutocomplete];
    // PFUser *curUser = [PFUser currentUser];
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

- (void)getFriends {
    [PFCloud callFunctionInBackground:@"getFriends"
                       withParameters:@{}
                                block:^(NSMutableArray *result, NSError *error) {
                                    if (!error)
                                       // NSLog(@"%@", result);
                                        [self storeFriends:result];
                                    for (int i = 0; i < [friends count]; i++)
                                        NSLog(@"%@", [friends objectAtIndex:i]);
                                }];
    
}

- (void)storeFriends:(NSMutableArray *) friendList {
//    NSData *data = [friendList dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *friendDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//    
//    NSArray *friendArr = [friendDict objectForKey:@"data"];
//    
//    NSString *friendName;
//    for (int i = 0; i < [friendArr count]; i++) {
//        friendName = [[friendArr objectAtIndex:i] objectForKey:@"display_name"];
//        [friends addObject:friendName];
//    }
    friends = friendList;
}

- (void)setupFriendAutocomplete {
    acTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, 320, 200) style:UITableViewStylePlain];
    acTableView.delegate = self;
    acTableView.dataSource = self;
    acTableView.scrollEnabled = YES;
    acTableView.hidden = YES;
    [self.view addSubview:acTableView];
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    acTableView.hidden = YES;
    return YES;
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
