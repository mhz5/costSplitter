//
//  LoginVC.m
//  BackendTutorial
//
//  Created by Michael Zhao on 6/17/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import "LoginVC.h"
#import <Parse/Parse.h>

@interface LoginVC ()

@end

@implementation LoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    [self.navigationItem setHidesBackButton:YES];
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

- (IBAction)logInPressed:(id)sender {
    [PFUser logInWithUsernameInBackground:_userText.text password:_passText.text block:^(PFUser *user, NSError *error) {
        if (user)
        {
            [self performSegueWithIdentifier:@"LoginSuccess" sender:self];
            [user setObject:@"SDF" forKey:@"testfield"];
            [user saveInBackground];
        }
        else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok dude" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}
@end
