//
//  VenmoPermissionsVC.m
//  CostSplitter
//
//  Created by Michael Zhao on 6/29/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import "VenmoPermissionsVC.h"
#import "WallVC.h"

@interface VenmoPermissionsVC ()

@end

@implementation VenmoPermissionsVC

NSString *_token;
PFUser *_curUser;

- (void)setPFUser:(PFUser *)user {
    _curUser = user;
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    NSLog(@"%@", url);
    // Extract the code. Use code to get access token.
    NSArray *split = [url componentsSeparatedByString:@"code="];
    if (split.count > 1) {
        NSString *code = [split objectAtIndex:1];
        NSLog(@"Code: %@", code);
        [self getToken:code];
        return NO;
    }
    else
        return YES;
}

//- (void)webViewDidFinishLoad:(UIWebView *)aWebView
//{
//    NSString *url = _webView.request.URL.absoluteString;
//    NSLog(@"%@", url);
//    // Extract the code. Use code to get access token.
//    NSArray *split = [url componentsSeparatedByString:@"code="];
//    if (split.count > 1) {
//        NSString *code = [split objectAtIndex:1];
//                NSLog(@"Code: %@", code);
//        [self getToken:code];
//    }
//}

- (void)getToken:(NSString *) code {
    [PFCloud callFunctionInBackground:@"requestAccessToken"
                       withParameters:@{@"code":code,
                                        @"userID":_curUser.objectId}
                                block:^(NSString *result, NSError *error) {
                                    if (!error)
                                        _token = result;
                                    
                                    [self performSegueWithIdentifier:@"BackToWall" sender:self];
                                }];
}

- (void)loadAuthURL {
    NSURL *venmoAuthURL = [NSURL URLWithString:@"https://api.venmo.com/v1/oauth/authorize?client_id=1777&scope=access_friends%20access_profile%20access_email%20access_phone%20access_balance&response_type=code"];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:venmoAuthURL]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _webView.delegate = self;
    [self loadAuthURL];
    
//    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"BackToWall"]) {
        [[segue destinationViewController] setAccessToken:_token];
    }
}


@end
