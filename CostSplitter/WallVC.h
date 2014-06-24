//
//  WallVC.h
//  CostSplitter
//
//  Created by Michael Zhao on 6/18/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WallVC : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *greeting;

- (IBAction)logout:(id)sender;
- (IBAction)payAlanOneDollar:(id)sender;

@end
