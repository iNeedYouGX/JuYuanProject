//
//  GXNetTool.h
//  GXAtlanticOceanCar
//  Copyright © 2016年 LGX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "MJExtension.h" // 数据转换
#import "MJRefresh.h"

typedef void(^blockOfSuccess)(id result);
typedef void(^blockOfFailure)(NSError *error);

typedef NS_ENUM(NSUInteger, GXResponseStyle) {
    GXResponseStyleJSON,
    GXResponseStyleDATA,
    GXResponseStyleXML,
};

typedef NS_ENUM(NSUInteger, GXRequsetStyle) {
    GXRequsetStyleBodyJSON,
    GXRequsetStyleBodyString,
    GXRequsetStyleBodyHTTP,
};


@interface GXNetTool : NSObject
+(AFHTTPSessionManager *)GetNetWithUrl:(NSString *)url
                 body:(id)body
               header:(NSDictionary *)headers
             response:(GXResponseStyle)response
              success:(blockOfSuccess)success
              failure:(blockOfFailure)failure;

+(void)PostNetWithUrl:(NSString *)url
                 body:(id)body
             bodySytle:(GXRequsetStyle)bodyStyle
               header:(NSDictionary *)headers
             response:(GXResponseStyle)response
              success:(blockOfSuccess)success
              failure:(blockOfFailure)failure;

+ (void)uploadNetWithUrl:(NSString *)url fileSource:(id)fileSource success:(blockOfSuccess)success failure:(blockOfFailure)failure;

- (GXNetTool *(^)(NSString *))url;
- (GXNetTool *(^)(NSDictionary *))header;
- (GXNetTool *(^)(id))body;
- (GXNetTool *(^)(GXRequsetStyle))bodySytle;
- (GXNetTool *(^)(GXResponseStyle))responseStyle;
+ (void)netWorkMaker:(void (^)(GXNetTool *))maker success:(blockOfSuccess)success failure:(blockOfFailure)failure;
@end
