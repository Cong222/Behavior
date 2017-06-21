//
//  MotionType.h
//  20-3-MotionMonitor
//
//  Created by Cong on 2017/3/30.
//  Copyright © 2017年 Cong. All rights reserved.
//

#ifndef MotionType_h
#define MotionType_h

typedef NS_ENUM (uint32_t, MotionType){
    staticState,
    walkState,
    runState,
    phoneUpState,   // 手机拿起
    phoneDownState, // 手机放下
    driveState,  //驾驶模式
    shakeState,
    userStaticStete,
    
};

#endif /* MotionType_h */



