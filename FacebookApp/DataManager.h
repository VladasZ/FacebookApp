//
//  DataManager.h
//  FacebookApp
//
//  Created by Vladas Zakrevskis on 21/02/16.
//  Copyright © 2016 Vladas Zakrevskis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VZUser;

@protocol DataManagerDelegate;

@interface DataManager : NSObject

@property (nonatomic, strong) NSMutableArray *allVZUsersData;

@property (nonatomic, weak) id<DataManagerDelegate> delegate;

+ (DataManager *)sharedManager;

- (void)generateData:(NSNumber *)numberOfUsers;

- (NSArray *)getAllUsersFromDatabase;
- (VZUser *)userFromDatabaseAtIndex:(NSUInteger)index;
- (void)loadVZUsersFromDatabase;
- (void)createRandomRelationships;

@end

@protocol DataManagerDelegate <NSObject>

- (void)dataManagerDidFinishLoadData;

@end
