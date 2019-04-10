//
//  JYShoppingDetailController.h
//  JUYUAN
//
//  Created by JasonBourne on 2019/4/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYShoppingDetailController : UIViewController
/** 房间号 */
@property (nonatomic, strong) NSString *userHouseNumber;
/** 参数 */
@property (nonatomic, strong) NSDictionary *param;
@end

NS_ASSUME_NONNULL_END
