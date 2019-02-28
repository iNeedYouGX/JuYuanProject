//
//  JYRoomListCollectionViewCell.m
//  JUYUAN
//
//  Created by 小香菜 on 2019/2/28.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYRoomListCollectionViewCell.h"

@implementation JYRoomListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}
- (void)setupUI{
    self.circleView.clipsToBounds = YES;
    self.circleView.layer.cornerRadius = 32;
    self.bgView.layer.cornerRadius = 4;
    self.circleView.backgroundColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:0.61];
}
@end
