//
//  main.m
//  DemoApp
//
//  Created by Beata Maciukiewicz on 22/06/11.
//  Copyright 2011 Blue Pocket Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DemoAppAppDelegate.h"

int main(int argc, char *argv[])
{
    int retVal = 0;
    @autoreleasepool {
        retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([DemoAppAppDelegate class]));
    }
    return retVal;
}
