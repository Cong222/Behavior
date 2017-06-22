//
//  MotionJudgementViewController.m
//  20-3-MotionMonitor
//
//  Created by Cong on 2017/3/30.
//  Copyright © 2017年 Cong. All rights reserved.
//

#import "MotionJudgementViewController.h"
#import "MotionManager.h"

@interface MotionJudgementViewController ()

@property (nonatomic, strong) MotionManager *motionManager;
@property (weak, nonatomic) IBOutlet UILabel *motionStateLabel; //当前动作
@property (weak, nonatomic) IBOutlet UILabel *deviceMotionInformationLabel; //设备传感器信息
@property (weak, nonatomic) IBOutlet UIButton *startButton; // 开始按钮

@property (strong, nonatomic) NSTimer *updateTimer;

@end

@implementation MotionJudgementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    

    // Do any additional setup after loading the view.
    
}

- (void)viewDidDisappear:(BOOL)animated{
    self.motionStateLabel.text = @"点击开始";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDisplay{
    
    CMRotationRate rotationRate = self.motionManager.deviceMotion.rotationRate;
    CMAcceleration gravity = self.motionManager.deviceMotion.gravity;
    CMAcceleration userAcc= self.motionManager.deviceMotion.userAcceleration;
    CMAttitude *attitude = self.motionManager.deviceMotion.attitude;
    self.deviceMotionInformationLabel.text = [NSString stringWithFormat:@"Acceleration Rate:\n -----------------\n"
                                              "Gravity x: %+.2f\t\tUser x: %+.2f\n"
                                              "Gravity y: %+.2f\t\tUser y: %+.2f\n"
                                              "Gravity z: %+.2f\t\tUser z: %+.2f\n",gravity.x,userAcc.x,gravity.y,userAcc.y,gravity.z,userAcc.z];
    
    int type = [self.motionManager judgeMotionForPeriod];
    switch (type) {
        case phoneUpState:
            self.motionStateLabel.text = @"你可能拿起了手机";
            break;
        case staticState:
            self.motionStateLabel.text = @"手机可能静止～";
            break;
        case phoneDownState:
            self.motionStateLabel.text = @"你可能放下了手机";
            break;
        case runState:
            self.motionStateLabel.text = @"你可能在跑步";
            break;
        case walkState:
            self.motionStateLabel.text = @"你可能在走";
            break;
        case driveState:
            self.motionStateLabel.text = @"你可能在开车";
            break;
            
        default:
            break;
    }
//    if ( type == phoneUpState ) {
//        self.motionStateLabel.text = @"你可能拿起了手机";
////        [self.motionManager stopJudging];
//    } else if (type == staticState ){
//        self.motionStateLabel.text = @"手机可能静止～";
//    } else if (type == phoneDownState ){
//        self.motionStateLabel.text = @"你可能放下了手机";
//    }
//    
}

- (IBAction)judgingIfStart:(id)sender{
    if( !_motionManager.isStartJudge ){
        self.motionManager = [MotionManager sharedInstance];
        [self.motionManager startToJudgeWithInterval:0.1];
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateDisplay) userInfo:nil repeats:YES];
//        [self updateDisplay];
        [self.startButton setTitle:@"正在判断" forState:UIControlStateNormal];
    } else {
        [self.motionManager stopJudging];
        [self.motionManager stopDeviceMotionUpdates];
        [self.updateTimer invalidate];
        [self.startButton setTitle:@"点击开始" forState:UIControlStateNormal];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
