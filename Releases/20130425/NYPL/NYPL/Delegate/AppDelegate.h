//
//  AppDelegate.h
//  NYPL   -fno-objc-arc
//
//  Created by shahnwaz on 10/23/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@class NYPLMenuViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) NYPLMenuViewController* nyplMenuViewController;

- (void)addTabBar;
@end
