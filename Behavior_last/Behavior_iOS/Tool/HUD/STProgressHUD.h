//
//  STProgressHUD.h
//  12345ForAdministrators
//
//  Created by 文君 on 16/7/5.
//  Copyright © 2016年 文君. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface STProgressHUD : NSObject

#pragma mark -XR
+(void) showDefaultHUDAddedTo:(UIView*)view animated:(BOOL)animated;
+(void) hideDefaultHUDForView:(UIView*)view animated:(BOOL)animated;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;


+ (void)show:(NSString*)text view:(UIView*)view animated:(BOOL)animated;

+ (void)uploadHUBMessage:(NSString*)message toView:(UIView*)view;
@end
