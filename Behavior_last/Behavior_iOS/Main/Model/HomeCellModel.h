//
//  HomeCellModel.h
//  Behavior_iOS
//
//  Created by Calvix on 2017/4/20.
//  Copyright © 2017年 Calvix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeCellModel : NSObject

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *title;

- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title;

@end
