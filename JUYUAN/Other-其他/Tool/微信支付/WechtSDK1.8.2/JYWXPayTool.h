//
//  JYWXPayTool.h
//  JUYUAN
//
//  Created by JasonBourne on 2019/3/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYWXPayTool : NSObject <WXApiDelegate>
+ (instancetype)WXPayTool;
- (NSString *)wxPay;
- (void)wxSendAuth;
@end

NS_ASSUME_NONNULL_END
