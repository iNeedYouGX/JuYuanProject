//
//  CZGuideTool.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/16.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZGuideTool.h"
#import "CZTabBarController.h"
#import "CZGuideController.h"
#define CZVERSION @"CZVersion"
#import "GXNetTool.h"

@implementation CZGuideTool
+ (void)chooseRootViewController:(UIWindow *)window
{
    //获取当前的版本号
    NSString *curVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    
    //获取存储的版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:CZVERSION];
    //比较
    if ([curVersion isEqualToString:lastVersion]) {
        //没有新版本
        window.rootViewController = [[CZTabBarController alloc] init];
    } else {
        //有新版本
        [[NSUserDefaults standardUserDefaults] setObject:curVersion forKey:CZVERSION];
        CZGuideController *vc = [[CZGuideController alloc] init];
        window.rootViewController = vc;
    }
}

@end
