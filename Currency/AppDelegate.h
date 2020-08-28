//
//  AppDelegate.h
//  Currency
//
//  Created by Bruno Meneghin on 27/08/20.
//  Copyright © 2020 Bruno Meneghin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentCloudKitContainer *persistentContainer;

- (void)saveContext;


@end

