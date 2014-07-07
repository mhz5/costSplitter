//
//  WallVC.h
//  CostSplitter
//
//  Created by Michael Zhao on 6/18/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendDelegate.h"

@interface WallVC : UIViewController <UITextFieldDelegate, NSURLConnectionDelegate>


- (IBAction)logout:(id)sender;

- (void)setAccessToken:(NSString *)token;

@property (strong, nonatomic) IBOutlet UITextView *groupTextView;

@end
