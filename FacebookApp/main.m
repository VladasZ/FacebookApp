//
//  main.m
//  FacebookApp
//
//  Created by Vladas Zakrevskis on 19/02/16.
//  Copyright © 2016 Vladas Zakrevskis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException* exception) {
            NSLog(@"Uncaught exception %@", exception);
            NSLog(@"Stack trace: %@", [exception callStackSymbols]);
        }
    }
}
