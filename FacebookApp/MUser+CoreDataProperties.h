//
//  MUser+CoreDataProperties.h
//  FacebookApp
//
//  Created by Vladas Zakrevskis on 20/02/16.
//  Copyright © 2016 Vladas Zakrevskis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface MUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *mobFirstName;
@property (nullable, nonatomic, retain) NSString *mobLastName;
@property (nullable, nonatomic, retain) NSString *mobGender;
@property (nullable, nonatomic, retain) NSString *mobEmail;
@property (nullable, nonatomic, retain) NSString *mobPhone;
@property (nullable, nonatomic, retain) NSData *mobAvatar;
@property (nullable, nonatomic, retain) NSSet<MUser *> *rlsFriends;

@end

@interface MUser (CoreDataGeneratedAccessors)

- (void)addRlsFriendsObject:(MUser *)value;
- (void)removeRlsFriendsObject:(MUser *)value;
- (void)addRlsFriends:(NSSet<MUser *> *)values;
- (void)removeRlsFriends:(NSSet<MUser *> *)values;

@end

NS_ASSUME_NONNULL_END
