//
//  JYServiceTableViewCell.h
//  JUYUAN
//
//  Created by 小香菜 on 2019/2/27.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^CellBlock)(NSInteger);
@interface JYServiceTableViewCell : UITableViewCell
@property (nonatomic, copy) CellBlock block;
@end

NS_ASSUME_NONNULL_END
