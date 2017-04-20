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

- (MotionType)judgeMotionForNow;

- (void)startToJudgeWithInterval:(NSTimeInterval)timeInterval;

- (void)stopJudging;

@end
