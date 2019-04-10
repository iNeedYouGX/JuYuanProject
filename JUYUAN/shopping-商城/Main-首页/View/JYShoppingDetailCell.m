//
//  JYShoppingDetailCell.m
//  JUYUAN
//
//  Created by JasonBourne on 2019/4/10.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYShoppingDetailCell.h"
#import "UIImageView+WebCache.h"

@interface JYShoppingDetailCell ()
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImage;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 价格 */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@end

@implementation JYShoppingDetailCell

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:dataDic[@"original_img"]]];
    self.titleLabel.text = dataDic[@"goods_name"];
    self.priceLabel.text =  [NSString stringWithFormat:@"¥%@", dataDic[@"shop_price"]] ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
