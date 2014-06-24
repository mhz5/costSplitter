//
//  LoginVC.m
//  CostSplitter
//
//  Created by Michael Zhao on 6/17/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import "LoginVC.h"
#import <Parse/Parse.h>
#import <Venmo-iOS-SDK/Venmo.h>

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
- (IBAction)buttonPress:(id)sender {
    [[Venmo sharedInstance] logout];
    if ([[Venmo sharedInstance] isSessionValid] == false) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log Out" message:@"No longer have Venmo permissions" delegate:nil cancelButtonTitle:@"What a shame" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

- (IBAction)apiCall:(id)sender {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:nil];
    
//    NSURL *url = [NSURL URLWithString:@"https://api.venmo.com/v1/me?access_token=wCUpZsyUJG2n42A7cr3UL4CVNpG9ckNZ"];
//    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//
//        
//        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        
//        NSString *userID = [[[dict objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"id"];
//        int myID = [userID intValue];
//        NSLog(@"Completed call\nData:\n%@", dataStr);
//        NSLog(@"Dict:%@", dict);
//        NSLog(@"User:%@", userID);
//        
//       
//                                      
//
//        
//    }];
//    
//    [task resume];
    
    NSURL *url = [NSURL URLWithString:@"https://api.venmo.com/v1/users/1179328259817472900/friends?access_token=wCUpZsyUJG2n42A7cr3UL4CVNpG9ckNZ&before=1130502752829440517"];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    [task resume];
            
}

- (IBAction)hello:(id)sender {
    [PFCloud callFunctionInBackground:@"goodbye"
                       withParameters:@{}
                                block:^(NSString *result, NSError *error) {
                                    if (!error)
                                        NSLog(@"Yea baby! %@", result);
                                }];
}

@end
