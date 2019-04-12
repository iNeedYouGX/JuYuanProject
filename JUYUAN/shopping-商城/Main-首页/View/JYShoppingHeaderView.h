//
//  JYShoppingHeaderView.h
//  JUYUAN
//
//  Created by JasonBourne on 2019/4/2.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^HeaderBlock)(void);
@interface JYShoppingHeaderView : UIView
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *topView;
+ (instancetype)shoppingHeaderView;
- (void)setupSearchView;
/** 轮播图数组 */
@property (nonatomic, strong) NSArray *imageList;
@property (nonatomic, copy) HeaderBlock block;

/** 图片ID数组 */
@property (nonatomic, strong) NSArray *imageListId;
/** 未读数量 */
@property (nonatomic, assign) NSInteger unreaderCount;
@end

NS_ASSUME_NONNULL_END
