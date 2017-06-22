//
//  AppDelegate.m
//  Behavior_iOS
//
//  Created by Calvix on 2017/4/20.
//  Copyright © 2017年 Calvix. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginManager.h"
#import "LoginViewController.h"
#import "JDMinimalTabBarController.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import "MHMHomePageController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor blackColor]];
    [self.window makeKeyAndVisible];
//    if ([[LoginManager shareManager] loginState] == LoginStateLogined) {
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController *mainTabBarVC = [sb instantiateViewControllerWithIdentifier:@"mainTabBarVC"];
//        [self.window setRootViewController:mainTabBarVC];
//    }else {
//        UIViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//        [self.window setRootViewController:[[UINavigationController alloc] initWithRootViewController:loginVC]];
//    }
//    self.window.backgroundColor = [UIColor blackColor];
    [self setRootVCToMainTabBarVC];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setRootVCToMainTabBarVC {
    JDMinimalTabBarController *minimalTabBarViewController = [[JDMinimalTabBarController alloc] init];
    
    UIImageView *sectionOneBackground = [[UIImageView alloc]initWithFrame:self.window.frame];
    [sectionOneBackground setImage:[UIImage imageNamed:@"mb_3"]];
    
    UIImageView *sectionTwoBackground = [[UIImageView alloc]initWithFrame:self.window.frame];
    [sectionTwoBackground setImage:[UIImage imageNamed:@"mb_3"]];
    
    
    UITabBarItem* tabBarItemOne = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"icon_1"] selectedImage:[UIImage imageNamed:@"icon_5"]];
    UITabBarItem* tabBarItemTwo = [[UITabBarItem alloc] initWithTitle:@"步数" image:[UIImage imageNamed:@"icon_6"] selectedImage:[UIImage imageNamed:@"icon_5"]];

    UIViewController *sectionOneVC = [HomeViewController new];
    sectionOneVC.tabBarItem = tabBarItemOne;
    CGRect rect = sectionOneVC.view.frame;
    rect.size = CGSizeMake(rect.size.width, rect.size.height - 44);
    sectionOneVC.view.frame = rect;

    MHMHomePageController *sectionTwoVC = [MHMHomePageController new];
    [sectionTwoVC.view insertSubview:sectionTwoBackground atIndex:0];
    sectionTwoVC.tabBarItem = tabBarItemTwo;
    
    [self.window setRootViewController:minimalTabBarViewController];
    self.tabBarVC = minimalTabBarViewController;
    // Highlight selected section -- DONE
    // Toggle Titles -- DONE
    // Main menu icon or logo -- DONE
    // Navigation controller check -- DONE
    // Menu Icon -- DONE
    // Background Color -- DONE
    // Hide titles when selected toggle -- DONE
    // On release change image icon
    
    
    // Landscape view
    // GIF -- Quicktime, or
    // Cocoapod -- http://blog.grio.com/2014/11/creating-a-private-cocoapod.html?utm_source=TapFame&utm_campaign=TapFame+newsletter&utm_medium=email
    
    UIImageView *sectionThreeBackground = [[UIImageView alloc]initWithFrame:self.window.frame];
    [sectionThreeBackground setImage:[UIImage imageNamed:@"mb_3"]];
    UITabBarItem* tabBarItemThree = [[UITabBarItem alloc] initWithTitle:@"我的信息" image:[UIImage imageNamed:@"icon_7"] selectedImage:[UIImage imageNamed:@"icon_5"]];
    UIViewController *sectionThreeVC = [[MineViewController alloc] init];
//    sectionTwoVC.tabBarItem = tabBarItemTwo;
    sectionThreeVC.tabBarItem = tabBarItemThree;
//    [sectionThreeVC.view addSubview:sectionThreeBackground];
    
    
    minimalTabBarViewController.minimalBar.defaultTintColor = [UIColor whiteColor];
    minimalTabBarViewController.minimalBar.selectedTintColor = [UIColor colorWithRed:222.0f/255.f green:157.0f/255.f blue:0.0f/255.f alpha:1.f];
    minimalTabBarViewController.minimalBar.showTitles = YES;
    minimalTabBarViewController.minimalBar.hidesTitlesWhenSelected = YES;
    minimalTabBarViewController.minimalBar.backgroundColor = [UIColor clearColor];
    [minimalTabBarViewController setViewControllers:@[sectionOneVC, sectionTwoVC, sectionThreeVC]];
    
}

@end
