//
//  LoginManager.h
//  Behavior_iOS
//
//  Created by Calvix on 2017/4/20.
//  Copyright © 2017年 Calvix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginUser.h"

typedef enum : NSUInteger {
    LoginStateLogined,
    LoginStateLogouted,
} LoginState;

@interface LoginManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic, strong) LoginUser *currentUser;
@property (nonatomic, assign) LoginState loginState;

- (BOOL)loginUser:(LoginUser *)user;
- (BOOL)logout;

@end
