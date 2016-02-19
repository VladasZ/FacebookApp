//
//  ViewController.m
//  FacebookApp
//
//  Created by Vladas Zakrevskis on 19/02/16.
//  Copyright © 2016 Vladas Zakrevskis. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *newRandomUserURL = [NSURL URLWithString:@"http://api.randomuser.me/?results=10"];

    NSData *newRandomUserData = [NSData dataWithContentsOfURL:newRandomUserURL];
    
    if (newRandomUserData == nil) return;
    
    NSError *error = nil;
    id object =
    [NSJSONSerialization JSONObjectWithData:newRandomUserData
                                    options:0
                                      error:&error];
    
    if(error) { /* JSON was malformed, act appropriately here */ }
    
    // the originating poster wants to deal with dictionaries;
    // assuming you do too then something like this is the first
    // validation step:
    if([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *results = object;
       
        NSLog(@"%@", [results valueForKeyPath:@"results.user.name"]);
        
        NSLog(@"\n\n\n\n\n\n\n%@", results);

        
        
    }
    else
    {
        /* there's no guarantee that the outermost object in a JSON
         packet will be a dictionary; if we get here then it wasn't,
         so 'object' shouldn't be treated as an NSDictionary; probably
         you need to report a suitable error condition */
    }
    
   
}


@end

