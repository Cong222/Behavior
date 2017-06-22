//
//  HomeCellModel.m
//  Behavior_iOS
//
//  Created by Calvix on 2017/4/20.
//  Copyright © 2017年 Calvix. All rights reserved.
//

#import "HomeCellModel.h"

@implementation HomeCellModel

- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title{
    if (self = [super init]) {
        self.imageName = imageName;
        self.title = title;
    }
    return self;
}

@end
