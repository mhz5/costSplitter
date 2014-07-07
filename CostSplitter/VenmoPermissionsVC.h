//
//  VenmoPermissionsVC.h
//  CostSplitter
//
//  Created by Michael Zhao on 6/29/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface VenmoPermissionsVC : UIViewController <UIWebViewDelegate>


@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (void)setPFUser:(PFUser *)user;


@end
