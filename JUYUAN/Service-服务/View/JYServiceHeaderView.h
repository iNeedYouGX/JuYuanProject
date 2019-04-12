//
//  JYServiceHeaderView.h
//  JUYUAN
//
//  Created by 小香菜 on 2019/2/27.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^HeaderBlock)(void);
@interface JYServiceHeaderView : UIView
/** <#注释#> */
@property (nonatomic, strong) NSArray *imageList;
- (void)controlMegButtonHide:(BOOL)hide;
@property (nonatomic, copy) HeaderBlock block;
/** 未读数量 */
@property (nonatomic, assign) NSInteger unreaderCount;
@end

NS_ASSUME_NONNULL_END
