//
//  FirstViewController.m
//  Behavior_iOS
//
//  Created by Calvix on 2017/4/20.
//  Copyright © 2017年 Calvix. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCellModel.h"
#import "MotionDetectionViewController.h"
#import "MPSkewedCell.h"
#import "MPSkewedParallaxLayout.h"
#import "ElasticTransition.h"
#import "BaseAnimationViewController.h"
#import "JDMinimalTabBar.h"
#import "JDMinimalTabBarController.h"
#import "AppDelegate.h"
#import "FCAlertView.h"


static NSString *kCellId = @"cellId";

@interface HomeViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource
, FCAlertViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray<HomeCellModel *> *dataSource;

@property (nonatomic, strong) ElasticTransition *transition;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MainTableViewCell"];
    UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    [backgroundView setImage:[UIImage imageNamed:@"mb_3"]];
    [self.view addSubview:backgroundView];
   
    self.navigationController.navigationBarHidden = YES;
    
    MPSkewedParallaxLayout *layout = [[MPSkewedParallaxLayout alloc] init];
    layout.lineSpacing = 2;
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 250);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
////    CGRect rect = self.collectionView.frame;
//    self.collectionView.backgroundColor = [UIColor clearColor];
////    rect.size = CGSizeMake(rect.size.width, rect.size.height-44);
////    self.collectionView.frame = rect;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[MPSkewedCell class] forCellWithReuseIdentifier:kCellId];
    [self.view addSubview:self.collectionView];
    [self performSelector:@selector(checkIfPerfectUserInfo) withObject:nil afterDelay:0.5];
}

#pragma mark - 检测是否第一次使用

- (void)checkIfPerfectUserInfo {
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAMEKEY];
    if (name && ![name isEqualToString:@""]) {
        return;
    }
    FCAlertView *alert = [[FCAlertView alloc] init];
    UIImage *image = [UIImage imageNamed:@"github-icon"];
//    alert.avoidCustomImageTint = 1;
//    alert.blurBackground = 1; //背景虚化
    [alert addTextFieldWithPlaceholder:@"你的姓名" andTextReturnBlock:^(NSString *text) {
        NSLog(@"TextField Returns: %@", text); // Do what you'd like with the text returned from the field
    }];
//    [alert addTextFieldWithPlaceholder:@"年龄" andTextReturnBlock:^(NSString *text) {
//        NSLog(@"TextField Returns: %@", text); // Do what you'd like with the text returned from the field
//    }];
//    [alert addTextFieldWithPlaceholder:@"身高" andTextReturnBlock:^(NSString *text) {
//        NSLog(@"TextField Returns: %@", text); // Do what you'd like with the text returned from the field
//    }];
//    [alert addTextFieldWithPlaceholder:@"体重" andTextReturnBlock:^(NSString *text) {
//        NSLog(@"TextField Returns: %@", text); // Do what you'd like with the text returned from the field
//    }];
    alert.darkTheme = YES;
    alert.detachButtons = YES;
//    alert.fullCircleCustomImage = YES;
    alert.animateAlertInFromTop = YES;
    alert.animateAlertOutToLeft = YES;
    alert.delegate = self;
    [alert showAlertInView:[UIApplication sharedApplication].keyWindow.rootViewController
                 withTitle:@"友情提醒"
              withSubtitle:@"这是你第一次使用我们的软件，为了更好的用户体验，请告诉我们你的名字哦~~. 😊😊"
           withCustomImage:image
       withDoneButtonTitle:nil
                andButtons:nil];
}

- (void)FCAlertDoneButtonClicked:(FCAlertView *)alertView {
    NSString *name = alertView.textField.text;
    if (!name || [name isEqualToString:@""]) {
        [self checkIfPerfectUserInfo];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:USERNAMEKEY];
}

- (ElasticTransition *)transition {
    if (!_transition) {
        _transition = [[ElasticTransition alloc] init];
        
        _transition.sticky           = YES;
        _transition.showShadow       = YES;
        _transition.panThreshold     = 0.55;
        _transition.radiusFactor     = 0.3;
        _transition.transformType    = ROTATE;
    }
    return _transition;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [(MPSkewedParallaxLayout *)self.collectionView.collectionViewLayout setItemSize:CGSizeMake(CGRectGetWidth(self.view.bounds), 250)];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.item % 5 + 1;
    MPSkewedCell* cell = (MPSkewedCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    cell.image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd", index]];
    cell.text = self.dataSource[indexPath.row].title;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    self.transition.startingPoint = cell.center;
    self.transition.edge = RIGHT;
    if (indexPath.row == 0) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Motion" bundle:nil];
        BaseAnimationViewController *vc = (BaseAnimationViewController *)[sb instantiateViewControllerWithIdentifier:@"MotionInformationViewController"];
        vc.transition = self.transition;
        vc.transitioningDelegate = self.transition;
        vc.modalPresentationStyle = UIModalPresentationCustom;
        [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    }else if (indexPath.row == 1){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Motion" bundle:nil];
        BaseAnimationViewController *vc = (BaseAnimationViewController *)[sb instantiateViewControllerWithIdentifier:@"MotionNowJudgementViewController"];
        vc.transition = self.transition;
        vc.transitioningDelegate = self.transition;
        vc.modalPresentationStyle = UIModalPresentationCustom;
        [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    }else if (indexPath.row == 2){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Motion" bundle:nil];
        BaseAnimationViewController *vc = (BaseAnimationViewController *)[sb instantiateViewControllerWithIdentifier:@"MotionJudgementViewController"];
        vc.transition = self.transition;
        vc.transitioningDelegate = self.transition;
        vc.modalPresentationStyle = UIModalPresentationCustom;
        [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
    }else if (indexPath.row == 3) {
        [self showMotionDetectionViewController:indexPath];
    }
}

- (void)showMotionDetectionViewController:(NSIndexPath *)indexPath {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MotionDetectionViewController" bundle:nil];
    BaseAnimationViewController *vc = (BaseAnimationViewController *)[sb instantiateViewControllerWithIdentifier:@"MotionDetectionViewController"];
    vc.transitioningDelegate = self.transition;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transition = self.transition;
//    [self presentViewController:vc animated:YES completion:nil];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

#pragma mark - data

- (NSArray<HomeCellModel *> *)dataSource {
    if (!_dataSource) {
        HomeCellModel *model1 = [[HomeCellModel alloc] initWithImageName:@"home_move" title:@"传感器\n实时信息"];
        HomeCellModel *model2 = [[HomeCellModel alloc] initWithImageName:@"home_move" title:@"手机行为\n预测"];
        HomeCellModel *model3 = [[HomeCellModel alloc] initWithImageName:@"home_move" title:@"动作行为\n预测"];
        HomeCellModel *model4 = [[HomeCellModel alloc] initWithImageName:@"home_move" title:@"实时监测\n"];
        _dataSource = @[model1, model2, model3, model4];
    }
    return _dataSource;
}


@end
