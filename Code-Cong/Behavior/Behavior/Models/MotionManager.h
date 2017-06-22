//
//  MotionManage.h
//  20-3-MotionMonitor
//
//  Created by Cong on 2017/3/30.
//  Copyright © 2017年 Cong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "MotionType.h"

@interface MotionManager : CMMotionManager

@property (nonatomic) BOOL isStartJudge;

+ (instancetype)sharedInstance;

- (MotionType)judgeMotionForNow; // 判断当前动作

- (MotionType)judgeMotionForPeriod; // 判断一段时间的动作

- (void)startToJudgeWithInterval:(NSTimeInterval)timeInterval;

- (void)stopJudging;

@end
