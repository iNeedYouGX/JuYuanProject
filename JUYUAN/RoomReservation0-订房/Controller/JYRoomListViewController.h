//
//  JYRoomListViewController.h
//  JUYUAN
//
//  Created by 小香菜 on 2019/2/28.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYRoomListViewController : UIViewController
// 公寓id
@property (nonatomic, assign) NSInteger apt_id;
//楼层id
 @property (nonatomic, assign) NSInteger storey_id;
//楼层名字
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *apartmentName;
@end

NS_ASSUME_NONNULL_END
