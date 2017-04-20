//
//  STProgressHUD.m
//  12345ForAdministrators
//
//  Created by 文君 on 16/7/5.
//  Copyright © 2016年 文君. All rights reserved.
//

#import "STProgressHUD.h"

@implementation STProgressHUD

+(void) showDefaultHUDAddedTo:(UIView*)view animated:(BOOL)animated
{
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}
+(void) hideDefaultHUDForView:(UIView*)view animated:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}


+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}
#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

#pragma mark - 新加的
+ (void)show:(NSString*)text view:(UIView*)view animated:(BOOL)animated{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
}

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //    hud.labelText = text;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15];
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.0];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}
#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    // 1秒之后再消失
    [hud hide:YES afterDelay:1];
    return hud;
}
- (void)doSomeWorkWithProgressObject:(NSProgress *)progressObject {
    // This just increases the progress indicator in a loop.
    while (progressObject.fractionCompleted < 1.0f) {
        if (progressObject.isCancelled) break;
        [progressObject becomeCurrentWithPendingUnitCount:1];
        [progressObject resignCurrent];
        usleep(50000);
    }
}
#pragma mark - 长传
+ (void)uploadHUBMessage:(NSString*)message toView:(UIView*)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = @"上传";
    
//    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    // Set up NSProgress
//    NSProgress *progressObject = [NSProgress progressWithTotalUnitCount:100];
   

//
//    // Configure a cancel button.
//    [hud.button setTitle:NSLocalizedString(@"Cancel", @"HUD cancel button title") forState:UIControlStateNormal];
//    [hud.button addTarget:progressObject action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
//    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
//        [self doSomeWorkWithProgressObject:hud.progress];
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hideAnimated:YES];
        });
    });

}
@end
