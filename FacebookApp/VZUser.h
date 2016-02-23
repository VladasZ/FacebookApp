//
//  VZUser.h
//  FacebookApp
//
//  Created by Vladas Zakrevskis on 20/02/16.
//  Copyright © 2016 Vladas Zakrevskis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MUser;

@interface VZUser : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSData *avatar;
@property (nonatomic, strong) NSMutableSet<VZUser *> *rlsFriends;

+ (VZUser *)newRandomUser;
- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                           gender:(NSString *)gender
                            email:(NSString *)email
                            phone:(NSString *)phone
                           avatar:(NSData *)avatar;
- (instancetype)initWithMUser:(MUser *)mUser;
- (void)addFriend:(VZUser *)newFriend;

@end
