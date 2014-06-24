//
//  LoginVC.h
//  CostSplitter
//
//  Created by Michael Zhao on 6/17/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController

- (IBAction)logInPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *userText;

@property (strong, nonatomic) IBOutlet UITextField *passText;

- (IBAction)buttonPress:(id)sender;
- (IBAction)apiCall:(id)sender;
- (IBAction)hello:(id)sender;

@end
