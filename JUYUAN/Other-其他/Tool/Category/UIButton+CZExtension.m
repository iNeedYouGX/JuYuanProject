//
//  UIButton+CZExtension.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/25.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "UIButton+CZExtension.h"

@implementation UIButton (CZExtension)

+ (instancetype)buttonWithFrame:(CGRect)frame backImage:(NSString *)backImage target:(id)vc action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
    btn.frame = frame;
    [btn addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
@end
