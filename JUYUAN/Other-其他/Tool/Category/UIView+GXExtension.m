//
//  UIView+GXExtension.m
//  百思不得姐
//
//  Created by JasonBourne on 2018/7/23.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "UIView+GXExtension.h"

@implementation UIView (GXExtension)

- (void)setSize:(CGSize)size
{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (void)setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (void)setHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (void)setX:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (void)setY:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (CGSize)size
{
    return self.frame.size;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint point = self.center;
    point.x = centerX;
    self.center = point;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint point = self.center;
    point.y = centerY;
    self.center = point;
}

- (CGFloat)centerY
{
    return self.center.y;
}


- (void)setRounderCorners:(UIRectCorner)corners withRadii:(CGSize)radii viewRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:path.CGPath];
    self.layer.mask = shape;
}






@end
