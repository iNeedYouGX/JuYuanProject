//
//  JYUserInfoManager.m
//  JUYUAN
//
//  Created by 小香菜 on 2019/3/4.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYUserInfoManager.h"
#import "NSDictionary+Addition.h"
@implementation JYUserInfoManager
// 保存房间号
+ (void)saveUserHouseNumber:(NSString *)number
{
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"UserHouseNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 读取房间号
+ (NSString *)getUserHouseNumber {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserHouseNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return token;
}


// 保存token
+ (void)saveUserToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// 读取token
+ (NSString *)getUserToken {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return token;
}
// 保存Refresh_token
+ (void)saveUserRefreshtoken:(NSString *)refresh_token {
    [[NSUserDefaults standardUserDefaults] setObject:refresh_token forKey:@"refresh_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// 读取Refresh_token
+ (NSString *)getUserRefreshToken {
    NSString *refresh_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"refresh_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return refresh_token;
}
// 保存个人用户信息
+ (void)saveUserInfos:(NSDictionary *)dic {
    NSDictionary *dictionary =  [NSDictionary changeType:dic];
    [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// 读取个人用户信息
+ (NSDictionary *)getUserInfos {
    id userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return userInfo;
}
// 清除NSUserDefaults所有信息
+ (void)removeAllUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refresh_token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refresh_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];;
    
}
@end
