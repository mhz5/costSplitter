//
//  CostAppDelegate.h
//  CostSplitter
//
//  Created by Michael Zhao on 6/17/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CostAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
