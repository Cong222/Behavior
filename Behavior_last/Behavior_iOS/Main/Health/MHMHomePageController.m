//
//  MHMHomePageController.m
//  MyHealthModule
//
//  Created by ChenWeidong on 16/2/26.
//  Copyright © 2016年. All rights reserved.
//

#import "MHMHomePageController.h"
#import "UtilsMacro.h"
#import "MHMDetailInfoController.h"
#import "MHMInfoSourceController.h"
#import <ReactiveCocoa.h>
#import "UIView+Layout.h"
#import "MHMLineChartView.h"
#import "MHMHealthManager.h"
#import "MHMHelper.h"
#import "EPieChart.h"

static NSInteger const topViewHeight = 40;
static NSInteger const topChartHeight = 250;
static NSInteger const lineChartHeight = 300;
static NSString *kMHMNormalCellIdentifier = @"MHMNormalCellIdentifier";

@interface MHMHomePageController () <UITableViewDataSource, UITableViewDelegate, EPieChartDelegate, EPieChartDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *jumpControllers;
@property (nonatomic, strong) UISegmentedControl *dateSegmentControl;

@property (nonatomic, strong) MHMLineChartView *lineChartView;
@property (nonatomic, strong) MHMHealthManager *healthManager;

@property (nonatomic, strong) NSArray *listModels;
@property (nonatomic, strong) NSDictionary *dayResultDict;//存储日数据
@property (nonatomic, strong) NSDictionary *weekResultDict;//存储周数据
@property (nonatomic, strong) NSDictionary *monthResultDict;//存储月数据
@property (nonatomic, strong) NSDictionary *yearResultDict;//存储年数据
@property (nonatomic, assign) NSInteger dayAverage;//日/周对应的日平均值
@property (nonatomic, assign) NSInteger yearAverage;//年对应的日平均值

@property (nonatomic, assign) BOOL isShowAlert;

@property (nonatomic, strong) EPieChart *todayChart;

@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation MHMHomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"步数";
    //setupView、setupData、bindingData这三个方法是放在基类中的viewDidLoad调用的，
    //子类中调用[super viewDidLoad]时会自动调用这三个方法
}

- (void)setupView {
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.todayChart];
    [self.scrollView addSubview:[self segmentControlView]];
    [self.scrollView addSubview:self.lineChartView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)setupData {
    //一次性获取 日/周/月/年 数据并存储
    @weakify(self);
    [self fetchHealthData:MHMHealthIntervalUnitDay resultBlock:^(NSDictionary *queryResultDict) {
        @strongify(self);
        self.dayResultDict = queryResultDict;
    }];
    
    [self fetchHealthData:MHMHealthIntervalUnitWeek resultBlock:^(NSDictionary *queryResultDict) {
        @strongify(self);
        self.weekResultDict = queryResultDict;
        if (((NSArray *)queryResultDict[kResultModelsKey]).count <= 0) {
            return;
        }
        //日对应的日平均值和周一样
        self.lineChartView.averageStepCount = [queryResultDict[kTotalStepCountKey] integerValue] / ((NSArray *)queryResultDict[kResultModelsKey]).count;
        self.dayAverage = self.lineChartView.averageStepCount;//存储日/周对应的日平均值
    }];
    
    [self fetchHealthData:MHMHealthIntervalUnitMonth resultBlock:^(NSDictionary *queryResultDict) {
        @strongify(self);
        self.monthResultDict = queryResultDict;
    }];
    
    [self fetchHealthData:MHMHealthIntervalUnitYear resultBlock:^(NSDictionary *queryResultDict) {
        @strongify(self);
        self.yearResultDict = queryResultDict;
        if (((NSArray *)queryResultDict[kResultModelsKey]).count <= 1) {
            return;
        }
        //存储年对应的日平均值
        self.yearAverage = [queryResultDict[kTotalStepCountKey] integerValue] / (self.listModels.count - 1);
    }];
    [self performSelector:@selector(updateTodayChartData) withObject:nil afterDelay:2.0];
}

- (void)updateTodayChartData {
    NSNumber *currentCount = (NSNumber *)self.dayResultDict[kMaxStepCountKey];
    NSInteger estimateCount = [self estimateCountBy:[currentCount integerValue]];
    EPieChartDataModel *ePieChartDataModel = [[EPieChartDataModel alloc] initWithBudget:estimateCount current:[currentCount integerValue] estimate:self.dayAverage];
    [self.todayChart.frontPie setEPieChartDataModel:ePieChartDataModel];
}

//根据已走的步数估算今天还会走多少步
- (NSInteger)estimateCountBy:(NSInteger)passCount {
    NSInteger estimateCount = 0;
    NSDate *date = [NSDate date]; // 获得时间对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =@"yyyy-MM-dd HH:mm:ss";
    NSString *str = [formatter stringFromDate:date];
    NSArray<NSString *> *arr1 = [str componentsSeparatedByString:@" "];
    NSArray<NSString *> *arr2 = [arr1[1] componentsSeparatedByString:@":"];
    NSInteger hour = [arr2[0] intValue];
    NSInteger minute = [arr2[1] intValue];
    NSInteger second = [arr2[2] intValue];
    double passSecond = 0;
    if (hour < 6) {
        passSecond = 6 * 3600;
    }else {
        passSecond = hour * 3600 + minute * 60 + second;
    }
    estimateCount = (passCount / passSecond) * (24 * 3600);
    return estimateCount;
}

- (void)bindingData {
    @weakify(self);
    [[self.dateSegmentControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl *segmentControl) {
        @strongify(self);
        __block NSDictionary *dict;
        switch (segmentControl.selectedSegmentIndex) {
            case 0:
                dict = self.dayResultDict;
                break;
            case 1:
                dict = self.weekResultDict;
                break;
            case 2:
                dict = self.monthResultDict;
                break;
            case 3:
                dict = self.yearResultDict;
                break;
        }
        if (dict) {
            [self.lineChartView setupChartWithDictionary:dict index:segmentControl.selectedSegmentIndex];
        } else {
            [self fetchHealthData:segmentControl.selectedSegmentIndex resultBlock:^(NSDictionary *queryResultDict) {
                dict = queryResultDict;
            }];
        }
        //选择为 日/年 的话，手动修改对应日平均值
        if (segmentControl.selectedSegmentIndex == 0) {
            self.lineChartView.averageStepCount = self.dayAverage;
        } else if (segmentControl.selectedSegmentIndex == 3) {
            self.lineChartView.averageStepCount = self.yearAverage;
        }
    }];
}

#pragma mark - custom Method
- (void)fetchHealthData:(MHMHealthIntervalUnit)unit
            resultBlock:(void (^)(NSDictionary *queryResultDict))resultBlock {
    if (![self.healthManager isHealthDataAvailable]) {
        [self showAlert:@"当前系统不支持健康数据获取"];
    } else {
        @weakify(self);
        [self.healthManager authorizateHealthKit:^(BOOL isAuthorizateSuccess) {
            @strongify(self);
            if (isAuthorizateSuccess) {
                if (!self.listModels) {//全部数据获取 这里只获取一次
                    [self.healthManager fetchAllHealthDataByDay:^(NSArray *modelArray) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (modelArray) {
                                self.listModels = modelArray;
                            }
                        });
                    }];
                }
                
                [self.healthManager fetchHealthDataForUnit:unit queryResultBlock:^(NSDictionary *queryResultDict) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (resultBlock) {
                            resultBlock(queryResultDict);
                        }
                        if (self.dateSegmentControl.selectedSegmentIndex == unit) {
                            [self.lineChartView setupChartWithDictionary:queryResultDict index:self.dateSegmentControl.selectedSegmentIndex];
                        }
                    });
                }];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showAlert:F(@"请在隐私健康APP中允许%@读取数据", AppName)];
                });
            }
        }];
    }
}

- (void)showAlert:(NSString *)prompt {
    if (self.isShowAlert) {//提示语只显示一次，之后获取信息出现则不提示
        return;
    }
    
    ALERT(prompt, nil);
    self.isShowAlert = YES;
}

- (UIView *)segmentControlView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 250, self.view.width, topViewHeight)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    
    [topView addSubview:self.dateSegmentControl];
//    self.dateSegmentControl.center = topView.center;
    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom - 0.5, topView.width, 0.5)];
//    line.backgroundColor = RGB(185, 185, 185);
//    [topView addSubview:line];
    return topView;
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMHMNormalCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:kMHMNormalCellIdentifier];
    }
    
    cell.textLabel.text = self.titles[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];

    cell.detailTextLabel.textColor = HEXCOLOR(0x0262bc);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.row == 1) {
        cell.textLabel.textColor = HEXCOLOR(0x0262bc);
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = @"步";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.textLabel.textColor = HEXCOLOR(0x2a2a2a);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = @"";
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    return cell;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        return;
    }
    
    if (indexPath.row == 0) {
        MHMDetailInfoController *vc = [[MHMDetailInfoController alloc] initWithListModels:self.listModels];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    Class class = self.jumpControllers[indexPath.row];
    MHMBaseViewController *vc = [[class alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, self.view.height - topViewHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (UISegmentedControl *)dateSegmentControl {
    if (!_dateSegmentControl) {
        NSArray *items = @[ @"日", @"周", @"月", @"年" ];
        _dateSegmentControl = [[UISegmentedControl alloc] initWithItems:items];
        _dateSegmentControl.selectedSegmentIndex = 0;
        _dateSegmentControl.frame = CGRectMake(4, 0, ScreenWidth - 8, topViewHeight);
        _dateSegmentControl.layer.cornerRadius = 5;
//        _dateSegmentControl.tintColor = RGB(255, 45, 85);
        _dateSegmentControl.tintColor = [UIColor whiteColor];
        
    }
    return _dateSegmentControl;
}

- (MHMLineChartView *)lineChartView {
    if (!_lineChartView) {
        _lineChartView = [[MHMLineChartView alloc] initWithFrame:CGRectMake(4, topChartHeight + topViewHeight, self.view.width - 8, lineChartHeight)];
    }
    return _lineChartView;
}

- (EPieChart *)todayChart {
    if (!_todayChart) {
        EPieChartDataModel *ePieChartDataModel = [[EPieChartDataModel alloc] initWithBudget:0 current:0 estimate:0];
        
        _todayChart = [[EPieChart alloc] initWithFrame:CGRectMake(100, 150, topChartHeight-10, topChartHeight-10)
                                   ePieChartDataModel:ePieChartDataModel];
        
        _todayChart.center = CGPointMake(CGRectGetMidX(self.view.bounds), topChartHeight / 2.0);
        //    [ePieChart.frontPie setLineWidth:1];
        //    [ePieChart.frontPie setRadius:30];
        //    ePieChart.frontPie.currentColor = [UIColor redColor];
        //    ePieChart.frontPie.budgetColor = [UIColor grayColor];
        //    ePieChart.frontPie.estimateColor = [UIColor blueColor];
        [_todayChart setDelegate:self];
        [_todayChart setDataSource:self];
        [_todayChart setMotionEffectOn:YES];
    }
    return _todayChart;
}

#pragma -mark- EPieChartDataSource
- (UIView *)backViewForEPieChart:(EPieChart *)ePieChart
{
    UIView *customizedView = [[UIView alloc] initWithFrame:ePieChart.backPie.bounds];
    customizedView.layer.cornerRadius = CGRectGetWidth(customizedView.bounds) / 2;
    
    UILabel *label = [[UILabel alloc] initWithFrame:customizedView.frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 3;
    label.font = [UIFont fontWithName:@"Menlo" size:15];
    label.text = @"这是背面\n 没有东西啦~\n 点击回去";
    [customizedView addSubview:label];
    
    return customizedView;
}

- (MHMHealthManager *)healthManager {
    if (!_healthManager) {
        _healthManager = [[MHMHealthManager alloc] init];
    }
    return _healthManager;
}

- (NSArray *)titles {
    return @[ @"显示所有数据", @"单位", @"数据来源" ];
}

- (NSArray *)jumpControllers {
    return @[ [MHMDetailInfoController class], @"", [MHMInfoSourceController class] ];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 10);
    }
    return _scrollView;
}

@end
