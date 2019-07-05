//
//  CZUpdataView.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/16.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZUpdataView : UIView
+ (instancetype)updataView;
/** 更新数据 */
@property (nonatomic, strong) NSDictionary *versionMessage;

@end

NS_ASSUME_NONNULL_END
