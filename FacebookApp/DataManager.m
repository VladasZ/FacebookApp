//
//  DataManager.m
//  FacebookApp
//
//  Created by Vladas Zakrevskis on 21/02/16.
//  Copyright © 2016 Vladas Zakrevskis. All rights reserved.
//

#import "DataManager.h"
#import "VZUser.h"
#import "MUser.h"
#import "CoreDataManager.h"

@implementation DataManager

+ (DataManager *)sharedManager
{
    static DataManager *sharedManager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[DataManager alloc] init];
        sharedManager.allVZUsersData = [[NSMutableArray alloc] init];
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
        
         MUser *newUser =
        [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([MUser class])
                                      inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
        
        [newUser initWithVZUser:[VZUser newRandomUser]];
        
        
    }
    
    [[CoreDataManager sharedManager] saveContext];
    
    [self.delegate dataManagerDidFinishLoadData];
}

- (NSArray *)getAllUsersFromDatabase
{
    NSFetchRequest *fetchRequest =
    [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([MUser class])];
    
    NSError *error = nil;
    
    NSArray *mUsers = [[[CoreDataManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest
                                                                          error:&error];
    
    NSMutableArray *vZUsers = [[NSMutableArray alloc] init];
    
    for (MUser *mUser in mUsers) {
        
        [vZUsers addObject:[[VZUser alloc] initWithMUser:mUser]];
        
    }
    
    
    return vZUsers;
}

- (VZUser *)userFromDatabaseAtIndex:(NSUInteger)index
{
    NSFetchRequest *fetchRequest =
    [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([MUser class])];
    
    NSError *error = nil;
    
    NSArray *mUsers = [[[CoreDataManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest
                                                                                            error:&error];
    
    return [[VZUser alloc] initWithMUser:[mUsers objectAtIndex:index]];
}

- (void)loadVZUsersFromDatabase
{
    self.allVZUsersData = [self getAllUsersFromDatabase].copy;
}

- (void)createRandomRelationships
{
    for (VZUser *user in self.allVZUsersData) {
        
        for (NSUInteger i = 0; arc4random_uniform(20); i++) {
            
            [user addFriend:
             [self.allVZUsersData objectAtIndex:
              arc4random_uniform((int)self.allVZUsersData.count)]];
            
        }
        
    }
}


@end
