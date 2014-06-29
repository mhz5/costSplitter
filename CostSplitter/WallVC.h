//
//  WallVC.h
//  CostSplitter
//
//  Created by Michael Zhao on 6/18/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WallVC : UIViewController <UITextFieldDelegate, UIWebViewDelegate, NSURLConnectionDelegate>


- (IBAction)logout:(id)sender;
- (IBAction)cancelPermissions:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *friendTextField;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
