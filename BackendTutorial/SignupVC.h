//
//  SignupVC.h
//  BackendTutorial
//
//  Created by Michael Zhao on 6/17/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupVC : UIViewController

- (IBAction)signUpUserPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *userText;

@property (strong, nonatomic) IBOutlet UITextField *passText;

@end
