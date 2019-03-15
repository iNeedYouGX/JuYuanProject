//
//  JYRoomListCollectionViewCell.m
//  JUYUAN
//
//  Created by 小香菜 on 2019/2/28.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYRoomListCollectionViewCell.h"
#import   "UIImageView+WebCache.h"
@implementation JYRoomListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}
- (void)setupUI{
    self.circleView.clipsToBounds = YES;
    self.circleView.layer.cornerRadius = 32;
    
    self.circleView.backgroundColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:0.61];
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
    //添加阴影
//    self.bgView.layer.shadowColor = [[UIColor grayColor] CGColor];
//    self.bgView.layer.shadowOffset = CGSizeMake(0, 0); //阴影向右及向下偏移量
//    self.bgView.layer.shadowRadius = 5; //阴影宽度
//    self.bgView.layer.shadowOpacity = 0.2;//阴影透明度
    
    self.backView.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.backView.layer.shadowOffset = CGSizeMake(0, 0);
    self.backView.layer.shadowRadius = 5;
    self.backView.layer.shadowOpacity = 0.3;
    self.backView.layer.cornerRadius = 5;
    
    
    
    self.layer.masksToBounds = NO;
    
}
- (void)updateData:(JYRoomListModel *)model {
    if (model.status == 1) {
        // 未出租
        self.hasOrderLabel.text = @"";
        self.circleView.hidden = YES;
    } else if (model.status == 2) {
        // 已出租
        self.hasOrderLabel.text = @"已出租";
        self.circleView.hidden = NO;
    }
    if ([model.type_name isEqualToString:@""]) {
        self.roomNumberLabel.text = [NSString stringWithFormat:@"%@",model.num];
    } else {
        self.roomNumberLabel.text = [NSString stringWithFormat:@"%@・%@",model.num,model.type_name];
    }
    
    self.priceLabel.text = [NSString stringWithFormat:@"%ld元/月",(long)model.rent];
    [self.roomImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
}

@end
