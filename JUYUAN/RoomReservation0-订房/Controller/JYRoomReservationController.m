//
//  JYRoomReservationController.m
//  JUYUAN
//
//  Created by JasonBourne on 2019/2/27.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYRoomReservationController.h"
#import "JYHomeTableViewCell.h"
#import "JYRoomListViewController.h"
#import "CZHotSearchView.h"
#import "GXNetTool.h"

#import "JYRoomReservationModel.h"
#import "JYRoomReservationSubModel.h"


@interface JYRoomReservationController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
/** 搜索框 */
@property (nonatomic, strong) CZHotSearchView *search;

/** 公寓数组 */
@property (nonatomic, strong) NSArray <JYRoomReservationModel *> *roomsArray;
@end

@implementation JYRoomReservationController
{
    NSInteger page ;
    NSInteger page_size ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    page = 1;
    page_size = 10;
    [self getNetwork];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSearchView];
    [self.view addSubview:self.tableView];
    
    
    
}

- (void)setupSearchView
{
    self.search = [[CZHotSearchView alloc] initWithFrame:CGRectMake(14, IsiPhoneX ? 54 : 30, SCR_WIDTH - 28, 34) msgAction:^(NSString *title){
        NSLog(@"哈哈哈哈");
    }];
    self.search.textFieldActive = NO;
    [self.view addSubview:self.search];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSearchController)];
    [self.search addGestureRecognizer:tap];
}

#pragma mark - 响应事件
- (void)pushSearchController
{
    NSLog(@"啦啦啦啦");
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight + 10, SCR_WIDTH, SCR_HEIGHT - kNavAndTabHeight - 10 - 10) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        [_tableView registerNib:[UINib nibWithNibName:@"JYHomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"JYHomeTableViewCell"];
        
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 50)];
        _headerView.backgroundColor = [UIColor whiteColor];
        UILabel *name = [[UILabel alloc] init];
        name.text = @"全部公寓";
        name.font = [UIFont boldSystemFontOfSize:22];
        name.frame = CGRectMake(20, 10, 100, 40);
        [_headerView addSubview:name];
    }
    return _headerView;
}
#pragma mark - 网络请求
- (void)getNetwork {
    
    /** 胖糊: 这个是将 模型中的数组 中的内容 转成其他类 */
    [JYRoomReservationModel setupObjectClassInArray:^NSDictionary *{
        return  @{
                  @"storey_list" : @"JYRoomReservationSubModel"
                  }; 
    }];
    [JYRoomReservationModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"apartment_id" : @"id"
                 };
    }];
     /** 胖糊: 这个是将 数据中的key 转换成模型中的属性名 */
    [JYRoomReservationSubModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"storeyId" : @"id"
                 };
    }];
    
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"/api/v1/apts"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"house_name"] = self.search.searchText;
    param[@"page"] = @(page);
    param[@"page_size"] = @(page_size);
    
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            
            /**胖糊: 数组转化模型 */
            self.roomsArray = [JYRoomReservationModel objectArrayWithKeyValuesArray:result[@"bizobj"][@"data"][@"apartment_list"]];
            
//            NSString *idid = self.roomsArray[0].storey_list[0].storeyId;
//            NSLog(@"%@", idid);
            [self.tableView reloadData];
            
        }
    } failure:^(NSError *error) {
        
    }];
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    JYHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYHomeTableViewCell"];
    [cell updateData:self.roomsArray[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.roomsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (SCR_WIDTH - 30 ) / 1.7 + 75;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JYRoomListViewController *vc = [[JYRoomListViewController alloc] init];
    // 最低楼层
    vc.storey_id = self.roomsArray[indexPath.row].storey_list.firstObject.storeyId;
    vc.apt_id = self.roomsArray[indexPath.row].apartment_id;
    vc.name = self.roomsArray[indexPath.row].storey_list.firstObject.name;
    vc.apartmentName = self.roomsArray[indexPath.row].name;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
