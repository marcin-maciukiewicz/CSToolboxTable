//
//  DemoAppAppDelegate.h
//  DemoApp
//
//  Created by Beata Maciukiewicz on 22/06/11.
//  Copyright 2011 Blue Pocket Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DemoAppViewController;

@interface DemoAppAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DemoAppViewController *viewController;

@end
