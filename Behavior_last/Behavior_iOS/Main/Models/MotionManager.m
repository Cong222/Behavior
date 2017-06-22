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

@property (nonatomic, strong) CMMotionActivityManager *motionActivityManager;
//@property (nonatomic, strong) NSDateFormatter *dateFormatter;

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


- (instancetype)init{
    self = [super init];
    if (self) {
        self.motionActivityManager=[[CMMotionActivityManager alloc]init];
        CMDeviceMotion *motion = self.deviceMotion;
        if (motion != nil) {
//            CMRotationRate rotationRate = motion.rotationRate;
//            CMAcceleration gravity = motion.gravity;
//            CMAcceleration userAcc= motion.userAcceleration;
//            CMAttitude *attitude = motion.attitude;
        }
        
    }
    return self;
}

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
    
    static int type = staticState;

    if ((fabs(rotationRate.x)+fabs(rotationRate.y)+fabs(rotationRate.z))<=4.0){
        if ( userAcc.z > 0.10) {
            type = phoneUpState;
        } else if ( userAcc.z < -0.10 ){
            type = phoneDownState;
        } else if ( fabs( userAcc.x ) <= 0.01 &&  fabs( userAcc.y ) <= 0.01 && fabs( userAcc.z ) <= 0.01 ){
            if ( (fabs(attitude.roll) +  fabs(attitude.pitch) ) <= 0.5 ) {
                NSLog(@"%f",(fabs(attitude.roll) +  fabs(attitude.pitch) ));
                type = staticState;}
        }
    };
    
    if ( (fabs(rotationRate.x)+fabs(rotationRate.y)+fabs(rotationRate.z))>4.0 ) {
        type = shakeState;
    }
    
    
    return type;
}

// 判断一段时间的动作
- (MotionType)judgeMotionForPeriod{
    
    CMRotationRate rotationRate = self.deviceMotion.rotationRate;
    CMAcceleration gravity = self.deviceMotion.gravity;
    CMAcceleration userAcc= self.deviceMotion.userAcceleration;
    CMAttitude *attitude = self.deviceMotion.attitude;
    
    //    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(judgeMotionForNow) userInfo:nil repeats:YES];
    
    
    
    static int type = userStaticStete;
    
    
    //    self.dateFormatter = [[NSDateFormatter alloc] init];
    //    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //    __weak typeof (self)weakSelf = self;
    [self.motionActivityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMotionActivity *activity)
     {
         
         if (activity.unknown) {
             //未知状态
             type = userStaticStete;
       
         } else if (activity.walking) {
             //步行
             type = walkState;
             
         } else if (activity.running) {
             // 跑步
             type = runState;
         } else if (activity.automotive) {
             // 驾车
             type = driveState;
         } else if (activity.stationary) {
             // 静止
             type = userStaticStete;
         }
         //         if (activity.confidence == CMMotionActivityConfidenceLow) {
         //             weakSelf.confidenceLabel.text = @"准确度  低";
         //         } else if (activity.confidence == CMMotionActivityConfidenceMedium) {
         //             weakSelf.confidenceLabel.text = @"准确度  中";
         //         } else if (activity.confidence == CMMotionActivityConfidenceHigh) {
         //             weakSelf.confidenceLabel.text = @"准确度  高";
         //         }
         
     }];
    return type;
}


- (void)stopJudging{
    [self stopDeviceMotionUpdates];
    [self.motionActivityManager stopActivityUpdates];
    _isStartJudge = NO;
}



@end
