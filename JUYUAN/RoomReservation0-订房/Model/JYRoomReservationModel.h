//
//  JYRoomReservationModel.h
//  JUYUAN
//
//  Created by 小香菜 on 2019/3/4.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYRoomReservationSubModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface JYRoomReservationModel : NSObject
/* 公寓id */
@property (nonatomic, assign) NSInteger apartment_id;
/* 公寓name */
@property (nonatomic, strong) NSString *name;
/* 公寓图片 */
@property (nonatomic, strong) NSString *img;
/* 公寓地址 */
@property (nonatomic, strong) NSString *address;
/* 最大租金 */
@property (nonatomic, assign) NSInteger max_rent;
/* 最小租金 */
@property (nonatomic, assign) NSInteger min_rent;
/* 几个房型 */
@property (nonatomic, assign) NSInteger house_type;
/* 在租数量*/
@property (nonatomic, assign) NSInteger rent_num;
/* 公寓list */
@property (nonatomic, strong) NSArray <JYRoomReservationSubModel *> *storey_list;


@end



NS_ASSUME_NONNULL_END
