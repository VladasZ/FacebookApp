//
//  DataManager.m
//  FacebookApp
//
//  Created by Vladas Zakrevskis on 21/02/16.
//  Copyright © 2016 Vladas Zakrevskis. All rights reserved.
//

#import "DataManager.h"
#import "VZUser.h"

@implementation DataManager

+ (DataManager *)sharedManager
{
    static DataManager *sharedManager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[DataManager alloc] init];
        sharedManager.data = [[NSMutableArray alloc] init];
    });
    
    return sharedManager;
}

- (void)generateData:(NSNumber *)numberOfUsers
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadData:numberOfUsers];
    });
    
}

- (void)loadData:(NSNumber *)numberOfUsers
{
    for (int i = 0; i < numberOfUsers.intValue; i++) {
        [self.data addObject:[VZUser newRandomUser]];
    }
    
    [self.delegate dataManagerDidFinishLoadData];
}


@end
