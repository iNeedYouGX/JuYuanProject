//
//  CZTabBarController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZTabBarController.h"
#import "CZNavigationController.h"
//#import "CZLoginController.h"
#import "JYRoomReservationController.h"
#import "JYServiceController.h"
#import "JYMeController.h"
#import "JYShoppingController.h"

#import "JYShoppingDetailController.h"

@interface CZTabBarController ()<UITabBarControllerDelegate>

@end

@implementation CZTabBarController

+(void)initialize
{
    NSMutableDictionary *normalAttr = [NSMutableDictionary dictionary];
    normalAttr[NSForegroundColorAttributeName] = CZRGBColor(158, 158, 161);
    normalAttr[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    NSMutableDictionary *selectedAttr = [NSMutableDictionary dictionary];
    selectedAttr[NSForegroundColorAttributeName] = [UIColor blackColor];
    selectedAttr[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    [[UITabBarItem appearance] setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
    
    [[UITabBar appearance] setBarTintColor: [UIColor whiteColor]];
    // 设配iOS12, tabbar抖动问题
    [[UITabBar appearance] setTranslucent:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self setupWithController:[[JYRoomReservationController alloc] init] title:@"定房" image:@"index" selectedImage:@"index2"];
    [self setupWithController:[[JYServiceController alloc] init] title:@"服务" image:@"fw2" selectedImage:@"fw"];
    [self setupWithController:[[JYShoppingController alloc] init] title:@"商城" image:@"WX20190411-normal" selectedImage:@"WX20190411-selected"];
    [self setupWithController:[[JYMeController alloc] init] title:@"我的" image:@"grzx" selectedImage:@"grzx2"];
    
    self.selectedIndex = 0;
//    self.tabBar.clipsToBounds = YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"%lu", (unsigned long)tabBarController.selectedIndex);
}

- (void)setupWithController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CZNavigationController *nav = [[CZNavigationController alloc] initWithRootViewController:vc];
//    [vc.navigationController setNavigationBarHidden:YES];
    [self addChildViewController:nav];
}

@end
