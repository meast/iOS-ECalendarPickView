//
//  AppDelegate.h
//  ECalendarPickerViewDemo
//
//  Created by measta on 2016/12/4.
//  Copyright © 2016年 meast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

