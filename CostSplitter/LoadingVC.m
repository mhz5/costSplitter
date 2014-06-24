//
//  LoadingVC.m
//  CostSplitter
//
//  Created by Michael Zhao on 6/18/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import "LoadingVC.h"
#import <Parse/Parse.h>

@interface LoadingVC ()

@end

@implementation LoadingVC

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
        [self performSegueWithIdentifier:@"AlreadyLoggedIn" sender:self];
    else
        [self performSegueWithIdentifier:@"NotLoggedIn" sender:self];
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
