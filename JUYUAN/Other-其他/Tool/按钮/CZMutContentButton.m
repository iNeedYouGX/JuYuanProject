//
//  CZMutContentButton.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMutContentButton.h"

@implementation CZMutContentButton

- (void)layoutSubviews
{
    [super layoutSubviews];
//    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.frame.size.width + 20, 0, 0)];
//    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,(self.imageView.frame.size.width))];
    self.titleLabel.x = 0;
    self.imageView.x = self.titleLabel.width + 5;
}

@end
