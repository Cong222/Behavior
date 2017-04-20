//
//  MotionManage.m
//  20-3-MotionMonitor
//
//  Created by Cong on 2017/3/30.
//  Copyright © 2017年 Cong. All rights reserved.
//

#import "MotionManager.h"


@interface MotionManager ()

@property (nonatomic, strong) NSTimer *updateTimer;

@end

@implementation MotionManager

static MotionManager *motionManager;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        motionManager = [super allocWithZone:zone];
    });
    return motionManager;
}

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        motionManager = [[self alloc] init];
    });
    return motionManager;
}

//- (id)copyWithZone:(NSZone *)zone
//{
//    return motionManager;
//}
//- (id)mutableCopyWithZone:(NSZone *)zone {
//    return motionManager;
//}

- (instancetype)init{
    self = [super init];
    if (self) {
        CMDeviceMotion *motion = self.deviceMotion;
        if (motion != nil) {
            CMRotationRate rotationRate = motion.rotationRate;
            CMAcceleration gravity = motion.gravity;
            CMAcceleration userAcc= motion.userAcceleration;
            CMAttitude *attitude = motion.attitude;
        }
        
    }
    return self;
}

//- (void)updateData{
//    if (self.deviceMotion.userAcceleration.z > 0.05) {
//        
//    }
//}

- (void)startToJudgeWithInterval:(NSTimeInterval)timeInterval{
    
     _isStartJudge = YES;
    if (!timeInterval) {
        timeInterval = 0.1;
    }
    self.deviceMotionUpdateInterval = timeInterval;
    
    [self startDeviceMotionUpdates];
}

// 判断当前动作
- (MotionType)judgeMotionForNow{
    
    CMRotationRate rotationRate = self.deviceMotion.rotationRate;
    CMAcceleration gravity = self.deviceMotion.gravity;
    CMAcceleration userAcc= self.deviceMotion.userAcceleration;
    CMAttitude *attitude = self.deviceMotion.attitude;
    
    //    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(judgeMotionForNow) userInfo:nil repeats:YES];
   
    
    
    static int type = staticState;
    
    
    if ( userAcc.z > 0.10) {
        type = phoneUpState;
    } else if ( userAcc.z < -0.10 ){
        type = phoneDownState;
    } else if ( fabs( userAcc.x ) <= 0.01 &&  fabs( userAcc.y ) <= 0.01 && fabs( userAcc.z ) <= 0.01 ){
        if ( (fabs(attitude.roll) +  fabs(attitude.pitch) ) <= 0.5 ) {
            NSLog(@"%f",(fabs(attitude.roll) +  fabs(attitude.pitch) ));
            type = staticState;
        }
    }
    
    return type;
}

- (void)stopJudging{
    [self stopDeviceMotionUpdates];
    _isStartJudge = NO;
}



@end
