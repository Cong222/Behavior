//
//  LoginManager.m
//  Behavior_iOS
//
//  Created by Calvix on 2017/4/20.
//  Copyright © 2017年 Calvix. All rights reserved.
//

#import "LoginManager.h"

static NSString *loginUserKey = @"cn.edu.scnu.loginUser";

@implementation LoginManager

+ (instancetype)shareManager{
    static LoginManager *_instance;
    static dispatch_once_t _token;
    dispatch_once(&_token, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init{
    if (self = [super init]) {
        [self autoLogin];
    }
    return self;
}

- (void)autoLogin{
    self.currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:loginUserKey];
    if (self.currentUser) {
        self.loginState = LoginStateLogined;
    }else {
        self.loginState = LoginStateLogouted;
    }
}

- (BOOL)loginUser:(LoginUser *)user{
    [[NSUserDefaults standardUserDefaults] setValue:self.currentUser forKey:loginUserKey];
    return YES;
}

- (BOOL)logout{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:loginUserKey];
    self.loginState = LoginStateLogouted;
    self.currentUser = nil;
    return YES;
}

@end
