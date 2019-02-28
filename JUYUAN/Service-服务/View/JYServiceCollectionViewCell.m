//
//  JYServiceCollectionViewCell.m
//  JUYUAN
//
//  Created by 小香菜 on 2019/2/27.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYServiceCollectionViewCell.h"

@implementation JYServiceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
// 边界添加阴影效果
//-(void)layoutSubviews{
//
//[super layoutSubviews];
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOpacity = 0.6;
//    self.layer.shadowRadius = 2.0;
//    self.layer.shouldRasterize = YES;
//    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    CGPathRef path = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.bounds.size.height, [UIScreen mainScreen].bounds.size.width,2)].CGPath;
//    [self.layer setShadowPath:path];
//
//}


// 添加分割线
//-(void)drawRect:(CGRect)rect{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextFillRect(context, rect);
//    CGContextSetStrokeColorWithColor(context,[UIColor redColor].CGColor);
//    CGContextStrokeRect(context, CGRectMake(14, rect.size.height - 0.5, rect.size.width-14, 0.5));
//
//}


@end
