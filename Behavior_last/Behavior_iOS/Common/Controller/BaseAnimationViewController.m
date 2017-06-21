//
//  BaseAnimationViewController.m
//  Behavior_iOS
//
//  Created by Calvix on 2017/6/20.
//  Copyright © 2017年 Calvix. All rights reserved.
//

#import "BaseAnimationViewController.h"

@interface BaseAnimationViewController () {
    UIScreenEdgePanGestureRecognizer *lgr;
}

@end

@implementation BaseAnimationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // gesture recognizer
    lgr = [[UIScreenEdgePanGestureRecognizer alloc] init];
    [lgr addTarget:self action:@selector(handleLeftPan:)];
    lgr.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:lgr];
    
}


-(void)handleLeftPan:(UIPanGestureRecognizer*)pan{
    
    if (pan.state == UIGestureRecognizerStateBegan){
        
        [self.transition dismissInteractiveTransitionViewController:self GestureRecognizer:pan Completion:nil];
    }else{
        
        [self.transition updateInteractiveTransitionWithGestureRecognizer:pan];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
