//
//  FirstViewController.m
//  Behavior_iOS
//
//  Created by Calvix on 2017/4/20.
//  Copyright © 2017年 Calvix. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCellModel.h"

@interface HomeViewController ()

@property (nonatomic, strong) NSArray<HomeCellModel *> *dataSource;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MainTableViewCell"];
    [self configData];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = @"运动";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)configData{
    HomeCellModel *model1 = [[HomeCellModel alloc] initWithImageName:@"home_move" title:@"传感器实时信息"];
    HomeCellModel *model2 = [[HomeCellModel alloc] initWithImageName:@"home_move" title:@"当前动作"];
    self.dataSource = @[model1, model2];
    [self.tableView reloadData];
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
    static NSString *cellIdentifier = @"MainTableViewCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    HomeCellModel *cellModel = self.dataSource[indexPath.row];
    
    cell.textLabel.text = cellModel.title;
    [cell.imageView setImage:[UIImage imageNamed:cellModel.imageName]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Motion" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MotionJudgementViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Motion" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MotionInformationViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
