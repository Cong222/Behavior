//
//  LoginUser.m
//  Behavior_iOS
//
//  Created by Calvix on 2017/4/20.
//  Copyright © 2017年 Calvix. All rights reserved.
//

#import "LoginUser.h"

static NSString *userNameKey = @"cn.edu.scnu.username";
static NSString *pwKey = @"cn.edu.scnu.password";

@implementation LoginUser

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.userName forKey:userNameKey];
    [aCoder encodeObject:self.password forKey:pwKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.userName = [aDecoder decodeObjectForKey:userNameKey];
        self.password = [aDecoder decodeObjectForKey:pwKey];
    }
    return self;
}

@end
