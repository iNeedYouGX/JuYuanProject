//
//  CZScollerImageTool.h
//  BestCity
//
//  Created by JasonBourne on 2019/1/10.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CZScollerImageToolBlock)(NSInteger);

@interface CZScollerImageTool : UIView
/** 图片数组 */
@property (nonatomic, strong) NSArray *imgList;
/** <#注释#> */
@property (nonatomic, copy) CZScollerImageToolBlock block;
@end

NS_ASSUME_NONNULL_END
