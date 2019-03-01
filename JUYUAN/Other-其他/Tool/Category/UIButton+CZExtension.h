//
//  UIButton+CZExtension.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/25.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CZExtension)
+ (instancetype)buttonWithFrame:(CGRect)frame backImage:(NSString *)backImage target:(id)vc action:(SEL)action;

@end
