//
//  ViewController.m
//  20-3-MotionMonitor
//
//  Created by Cong on 2017/3/15.
//  Copyright © 2017年 Cong. All rights reserved.
//

#import "MotionInformationViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface MotionInformationViewController ()

@property (weak, nonatomic) IBOutlet UILabel *gyroscopeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelerometerLabel;
@property (weak, nonatomic) IBOutlet UILabel *attitudeLabel;

@property (retain, nonatomic) CMMotionManager *motionManager;

@property (strong, nonatomic) NSTimer *updateTimer;



@end

@implementation MotionInformationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.motionManager = [[CMMotionManager alloc] init];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 判断设备motion是否有效
    if (self.motionManager.deviceMotionAvailable) {
        self.motionManager.deviceMotionUpdateInterval = 0.1;
        [self.motionManager startDeviceMotionUpdates];
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateDisplay) userInfo:nil repeats:YES];
        
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.motionManager.deviceMotionAvailable) {
        [self.motionManager stopDeviceMotionUpdates];
        [self.updateTimer invalidate];
        self.updateTimer = nil;
    }
}

// 刷新界面
- (void)updateDisplay{
    CMDeviceMotion *motion = self.motionManager.deviceMotion;
    if (motion != nil) {
        CMRotationRate rotationRate = motion.rotationRate;
        CMAcceleration gravity = motion.gravity;
        CMAcceleration userAcc= motion.userAcceleration;
        CMAttitude *attitude = motion.attitude;
        
        NSString *gyroscopeText = [NSString stringWithFormat:@"Rotation Rate:\n -----------------\n"
                                   "x: %+.2f\ny: %+.2f\nz: %+.2f\n",rotationRate.x,rotationRate.y,rotationRate.z];
        
        NSString *acceleratorText = [NSString stringWithFormat:@"Acceleration Rate:\n -----------------\n"
                                     "Gravity x: %+.2f\t\tUser x: %+.2f\n"
                                     "Gravity y: %+.2f\t\tUser y: %+.2f\n"
                                     "Gravity z: %+.2f\t\tUser z: %+.2f\n",gravity.x,userAcc.x,gravity.y,userAcc.y,gravity.z,userAcc.z];
        
        NSString *attitudeText = [NSString stringWithFormat:@"Attitude Rate:\n -----------------\n"
                                  "Roll: %+.2f\nPitch: %+.2f\nYaw: %+.2f\n",attitude.roll,attitude.pitch,attitude.yaw]; // roll:翻转（绕y轴） pitch:倾斜（绕x轴） yaw:偏移（绕z轴）
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.gyroscopeLabel.text = gyroscopeText;
            self.accelerometerLabel.text = acceleratorText;
            self.attitudeLabel.text = attitudeText;
        });

    }
}




@end
