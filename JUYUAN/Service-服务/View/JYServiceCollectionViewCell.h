//
//  JYServiceCollectionViewCell.h
//  JUYUAN
//
//  Created by 小香菜 on 2019/2/27.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYServiceCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleChLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleEnLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@end


NS_ASSUME_NONNULL_END
