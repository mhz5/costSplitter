//
//  FriendDelegate.m
//  CostSplitter
//
//  Created by Michael Zhao on 6/28/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import "FriendDelegate.h"

@implementation FriendDelegate
NSDictionary *_friends;
NSMutableArray *_autocompleteFriends;

- (instancetype)initWithTableView:(UITableView *)table andFriends:(NSDictionary *)friends modifyingTextView:(UITextView *)textView
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.tableView = table;
        self.tableView.scrollEnabled = YES;
        self.tableView.hidden = YES;
        _friends = friends;

        _autocompleteFriends = [[NSMutableArray alloc] init];
        _textView = textView;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    cell.textLabel.text = [_autocompleteFriends objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _autocompleteFriends.count;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *curText = _textView.text;
    _textView.text = [NSString stringWithFormat:@"%@%@, ", curText, [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text];
}

#pragma mark - autocomplete friends
// Refresh the autocomplete friends array.
- (void)showAutocompleteFriendsFromSubstring:(NSString *)substring{
    [_autocompleteFriends removeAllObjects];
    
    for (NSString *curString in [_friends allKeys]) {
        NSRange substringRange = [curString.lowercaseString rangeOfString:substring.lowercaseString];
        if (substringRange.location == 0)
            [_autocompleteFriends addObject:curString];
    }
    
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

#pragma mark - UITextViewDelegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    // To disable keyboard.
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        self.tableView.hidden = YES;
        return NO;
    }
    
    NSString *substring = [NSString stringWithString:textView.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:text];
    
    [self showAutocompleteFriendsFromSubstring:substring];
    
    return YES;
}


@end
