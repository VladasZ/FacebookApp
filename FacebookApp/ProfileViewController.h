//
//  ProfileViewController.h
//  FacebookApp
//
//  Created by Vladas Zakrevskis on 21/02/16.
//  Copyright © 2016 Vladas Zakrevskis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ViewController;

@interface ProfileViewController : UIViewController

@property (nonatomic) NSUInteger userID;
@property (nonatomic, weak) ViewController *parentController;

@end
