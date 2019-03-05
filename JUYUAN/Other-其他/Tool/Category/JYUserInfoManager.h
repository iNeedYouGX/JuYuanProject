//
//  JYUserInfoManager.h
//  JUYUAN
//
//  Created by 小香菜 on 2019/3/4.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYUserInfoManager : NSObject
// 保存token
+ (void)saveUserToken:(NSString *)token;
// 读取token
+ (NSString *)getUserToken;
// 保存Refresh_token
+ (void)saveUserRefreshtoken:(NSString *)refresh_token;
// 读取Refresh_token
+ (NSString *)getUserRefreshToken;
// 保存个人用户信息
+ (void)saveUserInfos:(NSDictionary *)dic;
// 读取个人用户信息
+ (NSDictionary *)getUserInfos;
/** 清除NSUserDefaults所有信息 */
+ (void)removeAllUserInfo;
@end

NS_ASSUME_NONNULL_END
