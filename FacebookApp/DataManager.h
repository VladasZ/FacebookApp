//
//  DataManager.h
//  FacebookApp
//
//  Created by Vladas Zakrevskis on 21/02/16.
//  Copyright © 2016 Vladas Zakrevskis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataManagerDelegate;

@interface DataManager : NSObject

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, weak) id<DataManagerDelegate> delegate;

+ (DataManager *)sharedManager;

- (void)generateData:(NSNumber *)numberOfUsers;

@end

@protocol DataManagerDelegate <NSObject>

- (void)dataManagerDidFinishLoadData;

@end
