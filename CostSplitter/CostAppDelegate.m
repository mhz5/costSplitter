//
//  CostAppDelegate.m
//  CostSplitter
//
//  Created by Michael Zhao on 6/17/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import "CostAppDelegate.h"
#import <Parse/Parse.h>
#import <Venmo-iOS-SDK/Venmo.h>

@implementation CostAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [Parse setApplicationId:@"XhBCYQfquO8FfRdl4ERsPAdr7FWx7aEY8D4Tcowu"
                  clientKey:@"k6ITiTSxXuAOwfowOEfKhMcKIZ91Q1fUlzk5WTtI"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    [Venmo startWithAppId:@"1777" secret:@"tXmuusxSDhex8FTVvUjUkQtRZmv3td7q" name:@"Cost Splitter"];

    [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAPI];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[Venmo sharedInstance] handleOpenURL:url]) {
        return YES;
    }
    // You can add your app-specific url handling code here if needed
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)requestPermissions {
    [[Venmo sharedInstance] requestPermissions:@[VENPermissionAccessFriends,
                                                 VENPermissionAccessProfile,
                                                 VENPermissionAccessPhone,
                                                 VENPermissionAccessEmail,
                                                 VENPermissionAccessBalance,
                                                 VENPermissionMakePayments]
                         withCompletionHandler:^(BOOL success, NSError *error) {
                             if (success) {
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Good" message:@"User granted permissions!" delegate:nil cancelButtonTitle:@":)" otherButtonTitles:nil, nil];
                                 [alert show];
                                 
                                 PFUser *curUser = [PFUser currentUser];
                                 NSLog(@"User granted permissions!");
                                 NSLog(@"Current user: %@", curUser[@"username"]);
                                 curUser[@"access_token"] = [Venmo sharedInstance].session.accessToken;
                                 [curUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                     if (succeeded)
                                         NSLog(@"Successfully stored user's access token.");
                                     else
                                         NSLog(@"ERROR: Couldn't store user's access token.");
                                 }];

                             }
                             else {
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bad" message:@"User did not grant permissions" delegate:nil cancelButtonTitle:@":(" otherButtonTitles:nil, nil];
                                 [alert show];
                                 NSLog(@"User didn't grant permissions. Their loss.");
                             }
                         }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self becomeFirstResponder];

//    if ([[Venmo sharedInstance] isSessionValid] == false)
//        [self requestPermissions];

//    NSLog(@"%@", [Venmo sharedInstance].session.accessToken);
//    NSLog(@"Expiration date: %@", [Venmo sharedInstance].session.expirationDate);
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
        NSLog(@"Shake!!");
    
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CostSplitter" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CostSplitter.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
