//
//  JYHomeTableViewCell.m
//  JUYUAN
//
//  Created by 小香菜 on 2019/2/27.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYHomeTableViewCell.h"
#import   "UIImageView+WebCache.h"
@implementation JYHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bgImageView.clipsToBounds = YES;
    self.bgImageView.layer.cornerRadius = 4;
}
- (void)updateData:(JYRoomReservationModel *)model {
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%ld-%ld元/月",model.min_rent,model.max_rent];
    self.addressLabel.text =[ NSString stringWithFormat:@"地址:%@",model.address];
    self.statueLabel.text = [ NSString stringWithFormat:@"%ld个房型 | %ld套在租",model.house_type,model.rent_num];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
