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
#import "JYUserInfoManager.h"
#import "JYHtmlDetailViewController.h"
#import "JYLoginController.h"

#import "JYAlipayTool.h"

@interface JYRoomReservationController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
/** 搜索框 */
@property (nonatomic, strong) CZHotSearchView *search;

/** 公寓数组 */
@property (nonatomic, strong) NSMutableArray <JYRoomReservationModel *> *roomsArray;
@property (nonatomic, strong) JYHtmlDetailViewController *htmlVC;
@end

@implementation JYRoomReservationController
{
    NSInteger page ;
    NSInteger page_size ;
}
- (JYHtmlDetailViewController *)htmlVC {
    if (_htmlVC == nil) {
        _htmlVC = [[JYHtmlDetailViewController alloc] init];
    }
    return _htmlVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    [JYRoomReservationSubModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"storeyId" : @"id"
                 };
    }];
    [self setupSearchView];
    [self.view addSubview:self.tableView];
    //创建刷新控件
    [self setupRefresh];
}

- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewDiscover)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDiscover)];
}

// 加载数据
- (void)reloadNewDiscover
{
    page = 1;
    page_size = 10;
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"/api/v1/apts"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"house_name"] = self.search.searchText;
    param[@"page"] = @(page);
    param[@"page_size"] = @(page_size);
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            self.roomsArray = [JYRoomReservationModel objectArrayWithKeyValuesArray:result[@"bizobj"][@"data"][@"apartment_list"]];
            [self.tableView reloadData];
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
        }
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

// 加载更多数据
- (void)loadMoreDiscover
{
    // 结束刷新
    [self.tableView.mj_header endRefreshing];
    
    page++;
    page_size = 10;
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"/api/v1/apts"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"house_name"] = self.search.searchText;
    param[@"page"] = @(page);
    param[@"page_size"] = @(page_size);
    
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            NSArray *newArr = [JYRoomReservationModel objectArrayWithKeyValuesArray:result[@"bizobj"][@"data"][@"apartment_list"]];
            [self.roomsArray addObjectsFromArray:newArr];
            [self.tableView reloadData];
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
        }
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}




- (void)setupSearchView
{
    self.search = [[CZHotSearchView alloc] initWithFrame:CGRectMake(14, IsiPhoneX ? 54 : 30, SCR_WIDTH - 28, 34) msgAction:^(NSString *title){
        if ([JYUserInfoManager getUserToken].length > 0) {
            self.htmlVC.urlString = [NSString stringWithFormat:@"https://apartment.pinecc.cn/public/frontend/index.html#/information?token=%@",[JYUserInfoManager getUserToken]];
            [self.navigationController pushViewController:self.htmlVC animated:true];
        } else {
            JYLoginController *loginView = [[JYLoginController alloc] init];
            [self presentViewController:loginView animated:YES completion:nil];
        }
    } confirmAction:^(NSString *title) {
        [self.view endEditing:YES];
        if (title.length == 0) return;
        [self reloadNewDiscover];
    }];
    self.search.textFieldActive = YES;
    [self.view addSubview:self.search];

}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight + 10, SCR_WIDTH, SCR_HEIGHT - kNavAndTabHeight - 10 - 10) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
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
//    JYRoomListViewController *vc = [[JYRoomListViewController alloc] init];
//    // 最低楼层
//    vc.storey_id = self.roomsArray[indexPath.row].storey_list.firstObject.storeyId;
//    vc.apt_id = self.roomsArray[indexPath.row].apartment_id;
//    vc.name = self.roomsArray[indexPath.row].storey_list.firstObject.name;
//    vc.apartmentName = self.roomsArray[indexPath.row].name;
//    [self.navigationController pushViewController:vc animated:YES];
    
    [JYAlipayTool alipayOrder:@"dafdasfasdfasd"];
}
@end
