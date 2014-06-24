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
    
    PFUser *curUser = [PFUser currentUser];
    if (curUser)
        _greeting.text = [NSString stringWithFormat:@"Hello %@", [curUser username]];
    else
        ;
    
    
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

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"Logout" sender:self];
}

- (IBAction)payAlanOneDollar:(id)sender {


    int r = rand() % [quotes count];
    NSString *choiceQuote = [quotes objectAtIndex:r];
    [[Venmo sharedInstance] sendPaymentTo:@""
                                   amount:1 * 100
                                     note:choiceQuote
                        completionHandler:^(VENTransaction *transaction, BOOL success, NSError *error) {
                            if (success) {
                                UIAlertView *successView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Paid Alan a dollor" delegate:nil cancelButtonTitle:@"Booyah baby" otherButtonTitles:nil, nil];
                                [successView show];
                                NSLog(@"Transaction succeeded! Paid Alan a dolla dolla bill.");
                            }
                            else {
                                NSString *errMsg = [error localizedDescription];
                                UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Grr :(" message:errMsg delegate:nil cancelButtonTitle:@"Aww" otherButtonTitles:nil, nil];
                                [errorView show];
                                NSLog(@"Transaction failed with error: %@", [error localizedDescription]);
                            }
                        }];
}
@end
