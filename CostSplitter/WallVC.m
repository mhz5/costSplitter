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
//    NSArray *friends = @[@[@"Brian", @"3364140402"], @[@"Alan", @"5734894023"], @[@"Ben", @"5853509206"]];
    //    NSString *randomFriend = [[friends objectAtIndex:r] objectAtIndex:1];
//    NSString *friendName = [[friends objectAtIndex:r] objectAtIndex:0];
//    NSLog(@"Trying to pay %@", randomFriend);
    NSArray *quotes = @[@"So we beat on, boats against the current, borne back ceaselessly into the past.",
                          @"I hope she'll be a fool -- that's the best thing a girl can be in this world, a beautiful little fool.",
                          @"Angry, and half in love with her, and tremendously sorry, I turned away.",
                          @"The loneliest moment in someone’s life is when they are watching their whole world fall apart, and all they can do is stare blankly.",
                          @"And so with the sunshine and the great bursts of leaves growing on the trees, just as things grow in fast movies, I had that familiar conviction that life was beginning over again with the summer.",
                          @"He smiled understandingly-much more than understandingly. It was one of those rare smiles with a quality of eternal reassurance in it, that you may come across four or five times in life. It faced--or seemed to face--the whole eternal world for an instant, and then concentrated on you with an irresistible prejudice in your favor. It understood you just as far as you wanted to be understood, believed in you as you would like to believe in yourself, and assured you that it had precisely the impression of you that, at your best, you hoped to convey.",
                          @"And I like large parties. They’re so intimate. At small parties there isn’t any privacy.",
                          @"I wasn't actually in love, but I felt a sort of tender curiosity.",
                          @"You see I usually find myself among strangers because I drift here and there trying to forget the sad things that happened to me.",
                          @"Let us learn to show our friendship for a man when he is alive and not after he is dead.",
                          @"There are only the pursued, the pursuing, the busy and the tired.",
                          @"I was within and without. Simultaneously enchanted and repelled by the inexhaustible variety of life.",
                          @"Reserving judgements is a matter of infinite hope.",
                          @"Can’t repeat the past?…Why of course you can!", 
                          @"In my younger and more vulnerable years my father gave me some advice that I've been turning over in my mind ever since.",
                          @"\"Whenever you feel like criticizing any one,\" he told me, \"just remember that all the people in this world haven't had the advantages that you've had.\""
                        ];

    int r = rand() % [quotes count];
    NSString *choiceQuote = [quotes objectAtIndex:r];
    [[Venmo sharedInstance] sendPaymentTo:@"5734894023"
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
