//
//  VZUser.m
//  FacebookApp
//
//  Created by Vladas Zakrevskis on 20/02/16.
//  Copyright © 2016 Vladas Zakrevskis. All rights reserved.
//

#import "VZUser.h"
#import <UIKit/UIKit.h>


@implementation VZUser

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                           gender:(NSString *)gender
                            email:(NSString *)email
                         phone:(NSString *)phone
                           avatar:(NSData *)avatar
{
    self = [super init];
    if (self) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.gender = gender;
        self.email = email;
        self.phone = phone;
        self.avatar = avatar;
    }
    return self;
}

- (void)addFriend:(VZUser *)friend
{
    [self.rlsFriends addObject:friend];
}

- (void)addFriends:(NSSet<VZUser *> *)friends
{
    [self.rlsFriends addObjectsFromArray:friends.mutableCopy];
}

+ (VZUser *)newRandomUser
{
    return [self userFromUserData:[self getRandomUserData]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n%@ \n%@\n%@\n%@\n%@",
            self.firstName,
            self.lastName,
            self.gender,
            self.email,
            self.phone];
}

#pragma mark - Internal methods

+ (NSDictionary *)getRandomUserDataFromUrl:(NSString *)newRandomUserURLString
{
    NSURL *newRandomUserURL = [NSURL URLWithString:newRandomUserURLString];
    
    
    NSData *newRandomUserData = [NSData dataWithContentsOfURL:newRandomUserURL];
    
    if (newRandomUserData == nil) {
        NSLog(@"failed to recieve newRandomUserData");
        return nil;
    }
    
    NSError *error = nil;
    id object =
    [NSJSONSerialization JSONObjectWithData:newRandomUserData
                                    options:0
                                      error:&error];
    
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    
    return [object valueForKeyPath:@"results.user"];
}

+ (NSDictionary *)getRandomUserData
{
    return [self getRandomUserDataFromUrl:@"http://api.randomuser.me"];
}

+ (NSDictionary *)getRandomUsersData:(NSUInteger)count
{
    return [self getRandomUserDataFromUrl:
            [NSString stringWithFormat:@"http://api.randomuser.me/?results=%lu", count]];
}

+ (VZUser *)userFromUserData:(NSDictionary *)userData
{
    UIImage *avatarImage =
    [UIImage imageWithData:
    [NSData dataWithContentsOfURL:
    [NSURL URLWithString:[[userData valueForKeyPath:@"picture.large"] firstObject]]]];

    
    VZUser * user =
    [[VZUser alloc] initWithFirstName:[[userData valueForKeyPath:@"name.first"] firstObject]
                             lastName:[[userData valueForKeyPath:@"name.last"] firstObject]
                               gender:[[userData valueForKeyPath:@"gender"] firstObject]
                                email:[[userData valueForKeyPath:@"email"] firstObject]
                                phone:[[userData valueForKeyPath:@"phone"] firstObject]
                               avatar:UIImageJPEGRepresentation(avatarImage, 1)];

    return user;
}


@end
