//
//  SecondViewController.m
//  Behavior_iOS
//
//  Created by Calvix on 2017/4/20.
//  Copyright © 2017年 Calvix. All rights reserved.
//

#import "MineViewController.h"
#import "HKHealthStore+AAPLExtensions.h"
@import HealthKit;

typedef enum : NSUInteger {
    ProfileKeyHeight = 1000,
    ProfileKeyWeight = 1001,
    ProfileKeyAge = 1002,
} ProfileKey;

@interface MineViewController ()

@property (nonatomic, strong) NSArray<NSString *> *dataSource;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) HKHealthStore *healthStore;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, NSString *> *dataDic;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    [backgroundView setImage:[UIImage imageNamed:@"mb_3"]];
    [self.view addSubview:backgroundView];
    [self.view addSubview:self.tableView];
    [self configData];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = @"我的信息";
    
    if ([HKHealthStore isHealthDataAvailable]) {
//        NSSet *writeDataTypes = [self dataTypesToWrite];
        NSSet *readDataTypes = [self dataTypesToRead];
        
        [self.healthStore requestAuthorizationToShareTypes:nil readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
            if (!success) {
                NSLog(@"You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: %@. If you're using a simulator, try it on a device.", error);
                
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the user interface based on the current user's health information.
                [self getAge];
                [self getHeight];
                [self getWeight];
            });
        }];
    }
}

- (NSSet *)dataTypesToRead {
    HKQuantityType *dietaryCalorieEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKCharacteristicType *birthdayType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
    HKCharacteristicType *biologicalSexType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    return [NSSet setWithObjects:dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType, birthdayType, biologicalSexType,stepType, nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)configData{
    self.dataSource = @[@"姓名", @"年龄", @"身高", @"体重"];
    [self.tableView reloadData];
}

- (NSMutableDictionary<NSNumber *, NSString *> *)dataDic {
    if (!_dataDic) {
        _dataDic = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    return _dataDic;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 400) style:UITableViewStylePlain];
        _tableView.center = self.view.center;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MineTableViewCell"];
        _tableView.layer.cornerRadius = 10;
        _tableView.layer.masksToBounds = YES;
        _tableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _tableView.layer.shadowColor = [UIColor whiteColor].CGColor;
        _tableView.layer.shadowOpacity = 0.8;
        _tableView.layer.shadowOffset = CGSizeMake(4, 4);
        _tableView.layer.shadowRadius = 4;
        
        _tableView.allowsSelection = NO;
    }
    return _tableView;
}

- (HKHealthStore *)healthStore {
    if (!_healthStore) {
        _healthStore = [[HKHealthStore alloc] init];
    }
    return _healthStore;
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MineTableViewCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    NSString *title = self.dataSource[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = title;
    switch (indexPath.row) {
        case 1: {
            NSString *str = self.dataDic[[NSNumber numberWithInteger:ProfileKeyAge]];
            if (!str) {
                str = @"不可用";
            }
            if (![str isEqualToString:@"不可用"]) {
                str = [str stringByAppendingString:@" 岁"];
            }
            cell.detailTextLabel.text = str;
            break;
        }
        case 2:{
            NSString *str = self.dataDic[[NSNumber numberWithInteger:ProfileKeyHeight]];
            if (!str) {
                str = @"不可用";
            }
            if (![str isEqualToString:@"不可用"]) {
                str = [str stringByAppendingString:@" cm"];
            }
            cell.detailTextLabel.text = str;
            break;
        }
        case 3:{
            NSString *str = self.dataDic[[NSNumber numberWithInteger:ProfileKeyWeight]];
            if (!str) {
                str = @"不可用";
            }
            if (![str isEqualToString:@"不可用"]) {
                str = [str stringByAppendingString:@" kg"];
            }
            cell.detailTextLabel.text = str;
            break;
        }
            
        default: {
            NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAMEKEY];
            cell.detailTextLabel.text = name;
        }
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Reading HealthKit Data

- (void)getAge {
    // Set the user's age unit (years).
    
    NSError *error;
    NSDate *dateOfBirth = [self.healthStore dateOfBirthWithError:&error];
    
    if (!dateOfBirth) {
        NSLog(@"Either an error occured fetching the user's age information or none has been stored yet. In your app, try to handle this gracefully.");
        
        [self.dataDic setObject:@"不可用" forKey:[NSNumber numberWithInteger:ProfileKeyAge]];
        [self.tableView reloadData];
    }
    else {
        // Compute the age of the user.
        NSDate *now = [NSDate date];
        
        NSDateComponents *ageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:dateOfBirth toDate:now options:NSCalendarWrapComponents];
        
        NSUInteger usersAge = [ageComponents year];
        
        NSString *age = [NSNumberFormatter localizedStringFromNumber:@(usersAge) numberStyle:NSNumberFormatterNoStyle];
        [self.dataDic setObject:age forKey:[NSNumber numberWithInteger:ProfileKeyAge]];
        [self.tableView reloadData];
    }
}

- (void)getHeight {
    // Fetch user's default height unit in inches.
    
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    
    // Query to get the user's latest height, if it exists.
    [self.healthStore aapl_mostRecentQuantitySampleOfType:heightType predicate:nil completion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        if (!mostRecentQuantity) {
            NSLog(@"Either an error occured fetching the user's height information or none has been stored yet. In your app, try to handle this gracefully.");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *height = NSLocalizedString(@"Not available", nil);
                [self.dataDic setObject:height forKey:[NSNumber numberWithInteger:ProfileKeyHeight]];
                [self.tableView reloadData];
            });
        }
        else {
            // Determine the height in the required unit.
            HKUnit *heightUnit = [HKUnit meterUnit];
            double usersHeight = [mostRecentQuantity doubleValueForUnit:heightUnit] * 100;
            
            // Update the user interface.
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *height = [NSNumberFormatter localizedStringFromNumber:@(usersHeight) numberStyle:NSNumberFormatterNoStyle];
                [self.dataDic setObject:height forKey:[NSNumber numberWithInteger:ProfileKeyHeight]];
                [self.tableView reloadData];
            });
        }
    }];
}

- (void)getWeight {
    
    // Query to get the user's latest weight, if it exists.
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    [self.healthStore aapl_mostRecentQuantitySampleOfType:weightType predicate:nil completion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        if (!mostRecentQuantity) {
            NSLog(@"Either an error occured fetching the user's weight information or none has been stored yet. In your app, try to handle this gracefully.");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *weight = @"不可用";
                [self.dataDic setObject:weight forKey:[NSNumber numberWithInteger:ProfileKeyWeight]];
                [self.tableView reloadData];
            });
        }
        else {
            // Determine the weight in the required unit.
            HKUnit *weightUnit = [HKUnit gramUnit];
            double usersWeight = [mostRecentQuantity doubleValueForUnit:weightUnit] / 1000;
        
            // Update the user interface.
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *weight = [NSNumberFormatter localizedStringFromNumber:@(usersWeight) numberStyle:NSNumberFormatterNoStyle];
                [self.dataDic setObject:weight forKey:[NSNumber numberWithInteger:ProfileKeyWeight]];
                [self.tableView reloadData];
            });
        }
    }];
}


@end
