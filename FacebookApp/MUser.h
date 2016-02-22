//
//  MUser.h
//  FacebookApp
//
//  Created by Vladas Zakrevskis on 20/02/16.
//  Copyright © 2016 Vladas Zakrevskis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "VZUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface MUser : NSManagedObject

- (void)initWithVZUser:(VZUser *)user;

@end

NS_ASSUME_NONNULL_END

#import "MUser+CoreDataProperties.h"
