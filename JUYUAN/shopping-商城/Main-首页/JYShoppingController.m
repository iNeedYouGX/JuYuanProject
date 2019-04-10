//
//  JYShoppingController.m
//  JUYUAN
//
//  Created by JasonBourne on 2019/4/2.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYShoppingController.h"
#import "JYShoppingHeaderView.h"
//#import "JYHtmlDetailViewController.h" // webView
#import "JYUserInfoManager.h" // 用户信息
//#import "JYLoginController.h" // 登录
#import "GXNetTool.h"
#import "CZMutContentButton.h"
#import "JYShoppingCell.h"
#import "UIImageView+webCache.h"

#import "JYShoppingDetailController.h" // 详情

@interface JYShoppingController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JYShoppingHeaderView *headerView;
/** <#注释#> */
@property (nonatomic, strong) NSArray *HeaderTitleArr;
/** <#注释#> */
@property (nonatomic, strong) NSString *userHouseNumber;
/** 热卖数据 */
@property (nonatomic, strong) NSMutableArray *hotSaleDataArr;
@end

@implementation JYShoppingController
#pragma mark - 数据
- (NSMutableArray *)hotSaleDataArr
{
    if (_hotSaleDataArr == nil) {
        _hotSaleDataArr = [NSMutableArray array];
    }
    return _hotSaleDataArr;
}


#pragma mark - 视图 
// 表
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, SCR_WIDTH, SCR_HEIGHT - kTabBarHeight - kStatusBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        
        [_tableView registerNib:[UINib nibWithNibName:@"JYServiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"JYServiceTableViewCell"];
    }
    return _tableView;
}

// 创建轮播图
- (void)setupBanner:(NSArray *)images
{
    NSMutableArray *imageArr = [NSMutableArray array];
    for (NSDictionary *imageStr in images) {
        [imageArr addObject:imageStr[@"ad_code"]];
    }
    self.headerView.imageList = imageArr;
}

// 顶部视图 
- (JYShoppingHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [JYShoppingHeaderView shoppingHeaderView];
        _headerView.frame = CGRectMake(0, (IsiPhoneX ? 44 : 20), SCR_WIDTH, 219 + 35);
        [_headerView setupSearchView];
    }
    return _headerView;
}
// headerView
- (UIView *)setupTopNavView:(NSDictionary *)titleDic
{
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 60)];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    
    UILabel *navLabel = [[UILabel alloc] init];
    navLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 20];
    navLabel.text = titleDic[@"name"];
    [navLabel sizeToFit];
    navLabel.x = 14;
    navLabel.centerY = 30;
    [navigationView addSubview:navLabel];
    
    CZMutContentButton *rightBtn = [CZMutContentButton buttonWithType:UIButtonTypeCustom];
    rightBtn.btnParam = titleDic;
    [rightBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(moreTrialReport:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"right-ash1"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
    [rightBtn setTitleColor:UIColorFromRGB(0x9598A1) forState:UIControlStateNormal];
    [navigationView addSubview:rightBtn];
    [rightBtn sizeToFit];
    rightBtn.x = navigationView.width - 85;
    rightBtn.centerY = navLabel.centerY;
    
    if (![titleDic[@"name"] isEqual:@"热卖商品"]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:titleDic[@"image"]]];
        imageView.x = 14;
        imageView.y = CZGetY(navLabel) + 15;
        imageView.width = SCR_WIDTH - 28;
        imageView.height = 127;
        [navigationView addSubview:imageView];
    }
    
    
    return navigationView;
}
#pragma mark -- end


#pragma mark - 数据
// 获取轮播图数据
- (void)getDataSource
{
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"/api/v1/mall/ad"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [JYUserInfoManager getUserToken];
    
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            // 创建轮播图
            [self setupBanner:result[@"bizobj"]];
        }
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}

// 获取房间号数据
- (void)getUser_houseDataSource
{
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"/api/v1/mall/user_house"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [JYUserInfoManager getUserToken];
    
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            if ([result[@"bizobj"] count] != 0) {
                self.userHouseNumber = result[@"bizobj"][0][@"user_house_id"];
                // 获取热卖数据
                [self getHotSaleDataSource];
            } else {
                self.tableView.tableHeaderView = nil;
                [self.view addSubview:self.headerView];
                self.headerView.y = (IsiPhoneX ? 44 : 20);
                UIView *backView = [[UIView alloc] init];
                backView.backgroundColor = [UIColor whiteColor];
                backView.y = CZGetY(self.headerView) - 125 - 20;
                backView.x = 0;
                backView.width = SCR_WIDTH;
                backView.height = 500;
                UIImageView *image = [[UIImageView alloc] init];
                image.image = [UIImage imageNamed:@"WX20190410-95854"];
                image.size = CGSizeMake(300, 300);
                image.center = CGPointMake(backView.width / 2.0, backView.height / 2.0);
                [backView addSubview:image];
                [self.view addSubview:backView];
            }
        }
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}

// 获取热卖数据
- (void)getHotSaleDataSource
{
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"/api/v1/mall/goods"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [JYUserInfoManager getUserToken];
    param[@"is_hot"] = @(1);
    param[@"store_id"] = self.userHouseNumber;
    
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            
        
            
            /////////////////////////////////////////////////////
            // 获取文件路径
            NSString *path = [[NSBundle mainBundle] pathForResource:@"File" ofType:@"json"];
            // 将文件数据化
            NSData *data = [[NSData alloc] initWithContentsOfFile:path];
            // 对数据进行JSON格式化并返回字典形式
            NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            /////////////////////////////////////////////////////
            
            
          
            
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
//            dataDic[@"list"] = result[@"bizobj"][@"list"];
            dataDic[@"list"] = jsonArr;
            dataDic[@"title"] = @{@"name" : @"热卖商品"};
            [self.hotSaleDataArr addObject:dataDic];
            // 获取header标题数据
            [self getHeaderTitleDataSource];
            [self.tableView reloadData];
        }
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}

// 获取分类标题数据
- (void)getHeaderTitleDataSource
{
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"/api/v1/mall/category"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [JYUserInfoManager getUserToken];
    
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            self.HeaderTitleArr = result[@"bizobj"];
            for (NSDictionary *dic in self.HeaderTitleArr) {
               // 获取类目数据
                [self getCategoryDataSource:dic];
            }
            [self.tableView reloadData];
        }
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}

// 获取类目数据
- (void)getCategoryDataSource:(NSDictionary *)category
{
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"/api/v1/mall/goods"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [JYUserInfoManager getUserToken];
    param[@"store_id"] = self.userHouseNumber; // 房间号
    param[@"category_id"] = category[@"id"]; // 类目数据
    param[@"is_recommend"] = @(1); // 默认数据 不传全部数据
        
    
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            
            /////////////////////////////////////////////////////
            // 获取文件路径
            NSString *path = [[NSBundle mainBundle] pathForResource:@"File" ofType:@"json"];
            // 将文件数据化
            NSData *data = [[NSData alloc] initWithContentsOfFile:path];
            // 对数据进行JSON格式化并返回字典形式
            NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            /////////////////////////////////////////////////////
            
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
//            dataDic[@"list"] = result[@"bizobj"][@"list"];
            dataDic[@"list"] = jsonArr;
            dataDic[@"title"] = category;
            [self.hotSaleDataArr addObject:dataDic];
        }
        [self.tableView reloadData];
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark -- end


#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // 表
    [self.view addSubview:self.tableView];
    
    // 获取轮播图数据
    [self getDataSource];
    
    // 获取房间号数据和热卖数据
    [self getUser_houseDataSource];
}

#pragma mark -- end



#pragma mark - 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.hotSaleDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"JYShoppingCell";
    JYShoppingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[JYShoppingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.hotSaleDataArr = self.hotSaleDataArr[indexPath.section][@"list"];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [self setupTopNavView:self.hotSaleDataArr[section][@"title"]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0) {    
        return 60;
    } else {
        return 60 + 127;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] init];
    return footer;
}
#pragma mark -- end

#pragma mark - 事件
- (void)moreTrialReport:(CZMutContentButton *)sender
{
    JYShoppingDetailController *vc = [[JYShoppingDetailController alloc] init];
    vc.userHouseNumber = self.userHouseNumber;
    vc.param = sender.btnParam;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -- end

@end
