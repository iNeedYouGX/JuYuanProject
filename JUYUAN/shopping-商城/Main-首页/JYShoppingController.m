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
#import "JYLoginController.h"

@interface JYShoppingController ()<UITableViewDelegate, UITableViewDataSource>
/** 选着房间的按钮 */
@property (nonatomic, strong) UIView *titlesView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JYShoppingHeaderView *headerView;
/** <#注释#> */
@property (nonatomic, strong) NSArray *HeaderTitleArr;
/** <#注释#> */
@property (nonatomic, strong) NSString *userHouseNumber;
/** 热卖数据 */
@property (nonatomic, strong) NSMutableArray *hotSaleDataArr;
/** 房间号数组 */
@property (nonatomic, strong) NSArray *storeyArray;
/** 最开始的位置 */
@property (nonatomic, assign) CGFloat titlesH;
/** 蒙版 */
@property (nonatomic, strong) UIView *masksView;
/** 最开始的的高度 */
@property (nonatomic, assign) BOOL isUnfold;
/** 房间号的按钮 */
@property (nonatomic, strong) CZMutContentButton *rightBtn;
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
    NSMutableArray *imageArrId = [NSMutableArray array];
    for (NSDictionary *imageStr in images) {
        [imageArr addObject:imageStr[@"ad_code"]];
        [imageArrId addObject:imageStr[@"ad_code"]];
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

// 有房间号显示一个按钮
- (CZMutContentButton *)setupUserNumberBtn:(NSString *)title
{
    CZMutContentButton *rightBtn = [CZMutContentButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(UserNumberBtn:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"WX20190411-0"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"7"] forState:UIControlStateSelected];
    [self.headerView addSubview:rightBtn];
    [rightBtn sizeToFit];
    rightBtn.center = CGPointMake(self.headerView.topView.width / 2.0, self.headerView.topView.height / 2.0);
    self.rightBtn = rightBtn;
    return rightBtn;
}

- (UIView *)titlesView
{
    if (_titlesView == nil) {
        
        CGFloat btnW = 60;
        CGFloat btnH = 25;
        NSInteger cols = 4;
        
        NSInteger row = (self.storeyArray.count + (cols - 1)) / cols;
        UIView *titlesView = [[UIView alloc] init];
        titlesView.backgroundColor = [UIColor whiteColor];
        titlesView.width = SCR_WIDTH;
        titlesView.height = 0;
        self.titlesH = (row + row + 1) * btnH;
        titlesView.y = - (kNavBarAndStatusBarHeight + self.titlesH);
        titlesView.x = 0;
        _titlesView = titlesView;
        
        self.masksView = [[UIView alloc] init];
        self.masksView.y = self.titlesH;
        self.masksView.width = SCR_WIDTH;
        self.masksView.height = SCR_HEIGHT - self.masksView.y;
        [self.view addSubview:self.masksView];
        self.masksView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.masksView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTapAction)];
        [self.masksView addGestureRecognizer:tap];
        
        CGFloat space = (SCR_WIDTH - (38 * 2) - (cols * btnW)) /  (cols - 1);
        for (int i = 0; i < self.storeyArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.width = btnW;
            btn.height = btnH;
            btn.x = 38 + (i % cols) * (btnW + space);
            btn.y = btnH + (i / cols) * (btnH + btnH);
            [btn setTitle:self.storeyArray[i][@"store_name"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitleColor: [UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1.00]forState:UIControlStateNormal];
            btn.layer.cornerRadius = 2;
            [_titlesView addSubview:btn];
            [self changeBtnUI:btn index:i];
            btn.tag = [self.storeyArray[i][@"user_house_id"] integerValue];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    return _titlesView;
}

- (void)changeBtnUI:(UIButton *)btn index:(NSInteger)i{
    if ([self.userHouseNumber integerValue] == [self.storeyArray[i][@"user_house_id"] integerValue]) {
        btn.backgroundColor = [UIColor colorWithRed:0.99 green:0.82 blue:0.26 alpha:1.00];
        [btn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.borderWidth = 0;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
    } else {
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor: [UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1.00]forState:UIControlStateNormal];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1.00].CGColor;
    }
}

#pragma mark -- end


#pragma mark - 数据
// 获取信息
- (void)getNotice
{
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"/api/v1/notice"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [JYUserInfoManager getUserToken];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            NSArray *images = result[@"bizobj"];
            if (images.count > 0) {
                self.headerView.unreaderCount = 1;
            } else {
                self.headerView.unreaderCount = 1;
            }
        }
    } failure:^(NSError *error) {

    }];
}

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
                // 有房间号
                self.storeyArray = result[@"bizobj"];
                if (!self.rightBtn) {                
                    [self setupUserNumberBtn:result[@"bizobj"][0][@"store_name"]]; 
                    [self.view addSubview:self.titlesView];
                    [self changeButtonUI];
                } 
                self.userHouseNumber = result[@"bizobj"][0][@"user_house_id"];
                [JYUserInfoManager saveUserHouseNumber:self.userHouseNumber];
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
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"File" ofType:@"json"];
//            // 将文件数据化
//            NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//            // 对数据进行JSON格式化并返回字典形式
//            NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            /////////////////////////////////////////////////////
            
            
          
            
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
            dataDic[@"list"] = result[@"bizobj"][@"list"];
//            dataDic[@"list"] = jsonArr;
            dataDic[@"title"] = @{@"name" : @"热卖商品"};
            [self.hotSaleDataArr removeAllObjects];
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
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"File" ofType:@"json"];
//            // 将文件数据化
//            NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//            // 对数据进行JSON格式化并返回字典形式
//            NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            /////////////////////////////////////////////////////
            
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
            dataDic[@"list"] = result[@"bizobj"][@"list"];
//            dataDic[@"list"] = jsonArr;
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


#pragma mark - 周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // 表
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 获取信息
    [self getNotice];
    if ([JYUserInfoManager getUserToken].length > 0) {
        // 获取轮播图数据
        [self getDataSource];
        // 获取房间号数据和热卖数据
        [self getUser_houseDataSource];
    } else {
        JYLoginController *loginView = [[JYLoginController alloc] init];
        [self presentViewController:loginView animated:YES completion:^{
            UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
            tabbar.selectedIndex = 0;
        }];
    }
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

// 房间号
- (void)UserNumberBtn:(UIButton *)sender
{
    [self contorlTopView];
}

// 点击选择楼层
- (void)btnAction:(UIButton *)btn {
    self.userHouseNumber = [NSString stringWithFormat:@"%ld", btn.tag];;
    [self changeButtonUI];
    for (int i = 0; i < self.storeyArray.count; i++) {
        if ([self.storeyArray[i][@"user_house_id"] integerValue] == btn.tag) {
            [self.rightBtn setTitle:self.storeyArray[i][@"store_name"] forState:UIControlStateNormal];
            [self.rightBtn sizeToFit];
            self.userHouseNumber = self.storeyArray[i][@"user_house_id"];
            // 获取热卖数据
            [self getHotSaleDataSource];
        }
    }
    
    [self contorlTopView];
}

// 选择楼层箭头 展开/收起
- (void)contorlTopView {
    if (!self.isUnfold) {
        [UIView animateWithDuration:0.25 animations:^{
            self.titlesView.y = kNavBarAndStatusBarHeight;
            self.titlesView.height = self.titlesH;
        } completion:^(BOOL finished) {
            self.masksView.hidden = NO;;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.titlesView.y = - (kNavBarAndStatusBarHeight + self.titlesH);
            self.titlesView.height = 0;
        } completion:^(BOOL finished) {
            self.masksView.hidden = YES;
        }];
    }
    self.isUnfold = !self.isUnfold;
}

- (void)changeButtonUI {
    for (int i = 0; i < self.storeyArray.count; i++) {
        UIButton *btn = (UIButton *)self.titlesView.subviews[i];
        [self changeBtnUI:btn index:i] ;
    }
}

-(void)maskViewTapAction{
    [self contorlTopView];
}

#pragma mark -- end

@end
