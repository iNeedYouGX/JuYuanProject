//
//  JYAlipayTool.h
//  JUYUAN
//
//  Created by JasonBourne on 2019/3/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYAlipayTool : NSObject
+ (void)alipayOrder:(NSString *)orderString;
@end

NS_ASSUME_NONNULL_END
