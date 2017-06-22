//
//  LoginUser.h
//  Behavior_iOS
//
//  Created by Calvix on 2017/4/20.
//  Copyright © 2017年 Calvix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginUser : NSObject<NSCoding>

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;

@end
