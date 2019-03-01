//
//  UIView+GXExtension.h
//  百思不得姐
//
//  Created by JasonBourne on 2018/7/23.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GXExtension)
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat centerX;
/** 给view添加单边的圆角 */
- (void)setRounderCorners:(UIRectCorner)corners withRadii:(CGSize)radii viewRect:(CGRect)rect;
@end
