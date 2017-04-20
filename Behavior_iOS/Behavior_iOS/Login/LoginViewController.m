//
//  LoginViewController.m
//  Behavior_iOS
//
//  Created by Calvix on 2017/4/20.
//  Copyright © 2017年 Calvix. All rights reserved.
//

#import "LoginViewController.h"
#import "STProgressHUD.h"
#import "LoginManager.h"
#import "LoginUser.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
#ifdef DEBUG
    self.userNameTextField.text = @"scnu";
    self.passwordTextField.text = @"scnupw";
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    if (self.userNameTextField.text.length <= 0) {
        [STProgressHUD showError:@"账号不能为空"];
        return;
    }
    if (self.passwordTextField.text.length <= 0) {
        [STProgressHUD showError:@"密码不能为空"];
        return;
    }
    LoginUser *user = [[LoginUser alloc] init];
    [user setUserName:self.userNameTextField.text];
    [user setPassword:self.passwordTextField.text];
    if ([[LoginManager shareManager] loginUser:user]) {
        [self showMainViewController];
        [STProgressHUD showSuccess:@"登录成功"];
    }else {
        [STProgressHUD showError:@"登录失败"];
    }
}

- (void)showMainViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainTabBarVC = [sb instantiateViewControllerWithIdentifier:@"mainTabBarVC"];
     AppDelegate *appdDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdDelegate.window setRootViewController:mainTabBarVC];
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
