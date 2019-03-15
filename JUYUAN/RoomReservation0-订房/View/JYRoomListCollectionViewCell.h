//
//  JYRoomListCollectionViewCell.h
//  JUYUAN
//
//  Created by 小香菜 on 2019/2/28.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYRoomListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JYRoomListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *roomImageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *hasOrderLabel;
/** 最外面的图层 */
@property (nonatomic, weak) IBOutlet UIView *backView;
- (void)updateData:(JYRoomListModel *)model;
@end

NS_ASSUME_NONNULL_END
