//
//  MUser.m
//  FacebookApp
//
//  Created by Vladas Zakrevskis on 20/02/16.
//  Copyright © 2016 Vladas Zakrevskis. All rights reserved.
//

#import "MUser.h"

@implementation MUser

- (void)initWithVZUser:(VZUser *)user
{
    self.mobAvatar = user.avatar;
    self.mobEmail = user.email;
    self.mobFirstName = user.firstName;
    self.mobGender = user.gender;
    self.mobLastName = user.lastName;
    self.mobPhone = user.phone;
}

@end
