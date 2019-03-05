//
//  JYRoomListModel.h
//  JUYUAN
//
//  Created by 小香菜 on 2019/3/4.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYRoomListModel : NSObject
/* 房间id */
@property (nonatomic, assign) NSInteger room_id;
/* 房间号 */
@property (nonatomic, strong) NSString *num;
/* 公寓类型名称 */
@property (nonatomic, strong) NSString *type_name;
/* 公寓图像 */
@property (nonatomic, strong) NSString *img;
/* 公寓类型 */
@property (nonatomic, assign) NSInteger type;
/* 月租金 */
@property (nonatomic, assign) NSInteger rent;
/* 是否出租  1:未出租 2:已出租 */
@property (nonatomic, assign) NSInteger status;


@end

NS_ASSUME_NONNULL_END
