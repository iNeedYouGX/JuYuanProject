//
//  JYAlipayTool.m
//  JUYUAN
//
//  Created by JasonBourne on 2019/3/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYAlipayTool.h"
#import "AlipaySDK/AlipaySDK.h"


@implementation JYAlipayTool

+ (void)alipayOrder:(NSString *)orderString
{
    if (orderString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"juyuanaliPay";
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}


@end
