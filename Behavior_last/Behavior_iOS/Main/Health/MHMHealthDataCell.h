//
//  MHMHealthDataCell.h
//  MyHealthModule
//
//  Created by 陈宪栋 on 16/2/27.
//  Copyright © 2016年. All rights reserved.
//

#import "MHMBaseTableViewCell.h"

@class MHMHealthModel;

@interface MHMHealthDataCell : MHMBaseTableViewCell

@property (nonatomic, strong) MHMHealthModel *healthModel;

@end
