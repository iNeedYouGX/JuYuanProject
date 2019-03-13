//
//  JYServiceController.m
//  JUYUAN
//
//  Created by JasonBourne on 2019/2/27.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYServiceController.h"
#import "JYServiceTableViewCell.h"
#import "JYServiceHeaderView.h"
#import "JYUserInfoManager.h"
#import "GXNetTool.h"
#import "JYHtmlDetailViewController.h"
#import "JYLoginController.h"
@interface JYServiceController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JYServiceHeaderView *headerView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) JYHtmlDetailViewController *htmlVC;
@end

@implementation JYServiceController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([JYUserInfoManager getUserToken].length > 0) {
        [self getUserInfomation];
    } else {
        [self.headerView controlMegButtonHide:YES];
    }
    
}

- (void)getBrandImage
{
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/v1/brand"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"status"] = @(1);
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            NSArray *images = result[@"bizobj"];
            NSMutableArray *mutArr = [NSMutableArray array];
            for (NSDictionary *dic in images) {
                [mutArr addObject:dic[@"logo"]];
            }
            NSLog(@"%@", mutArr);
            self.headerView.imageList = mutArr;
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 获取个人信息
- (void)getUserInfomation {
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"/api/v1/users/getUserInfo"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [JYUserInfoManager getUserToken];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            NSDictionary *dic = result[@"bizobj"][@"data"][@"user_info"];
            // 是否有合同
            
            NSInteger has_contract = [dic[@"has_contract"] integerValue];
            if (has_contract == 1) {
                [self.headerView controlMegButtonHide:NO];
            } else {
                [self.headerView controlMegButtonHide:YES];
                [CZProgressHUD showProgressHUDWithText:@"没有履行中的合同"];
                [CZProgressHUD hideAfterDelay:1.5];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getBrandImage];
     self.titleArray = @[@"账单查询",@"水电费查询",@"我要开门",@"报修",@"我要续租",@"退房申请",@"投诉建议"];
    [self.view addSubview:self.tableView];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, SCR_WIDTH, SCR_HEIGHT - kTabBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        if (SCR_HEIGHT >= 667) {
             _tableView.scrollEnabled = NO;
        }
        [_tableView registerNib:[UINib nibWithNibName:@"JYServiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"JYServiceTableViewCell"];
        
    }
    return _tableView;
}
- (JYServiceHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"JYServiceHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, SCR_WIDTH, 205);
        _headerView.block = ^{
            if ([JYUserInfoManager getUserToken].length > 0) {
                
                self.htmlVC.urlString = [NSString stringWithFormat:@"https://apartment.pinecc.cn/public/frontend/index.html#/information?token=%@",[JYUserInfoManager getUserToken]];
                NSLog(@"%@",self.htmlVC.urlString);
                [self.navigationController pushViewController:self.htmlVC animated:true];
            } else {
                JYLoginController *loginView = [[JYLoginController alloc] init];
                [self presentViewController:loginView animated:YES completion:nil];
            }
        };
        
    }
//    _headerView.imageList =  @[@"http://jipincheng.cn/0d2e3f4e51374ed1ab31ee6210b9fccf", @"http://jipincheng.cn/fa6fd46617d4427e82d4117dc0015364", @"http://jipincheng.cn/0f429dc482af4c0795aeea773f936579"];
    return _headerView;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    JYServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYServiceTableViewCell"];
    
    cell.block = ^(NSInteger row) {
        if ([JYUserInfoManager getUserToken].length > 0) {
            self.htmlVC = [[JYHtmlDetailViewController alloc] init];
            self.htmlVC.urlString = [NSString stringWithFormat:@"https://apartment.pinecc.cn/public/frontend/index.html#/%@?token=%@",[self getHTMLUrlWithIndex:row], [JYUserInfoManager getUserToken]];
            [self.navigationController pushViewController:self.htmlVC animated:YES];
        } else {
            JYLoginController *loginView = [[JYLoginController alloc] init];
            [self presentViewController:loginView animated:YES completion:nil];
        }
    };
    return cell;
}
- (NSString *)getHTMLUrlWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @"bill";
        case 1:
            return @"electricity";
        case 2:
            return @"myHouses";
        case 3:
            return @"Service";
        case 4:
            return @"reneval";
        case 5:
            return @"checkout";
        case 6:
            return @"complaint";
            
        default:
            return @"";
    }
    
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH , 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCR_WIDTH - 20, 50)];
    label.text = @"品质服务";
    label.font = [UIFont boldSystemFontOfSize:22];
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = self.titleArray.count % 2 == 0 ? self.titleArray.count / 2 : self.titleArray.count / 2 + 1;
    return count * (10 + 70);
}

@end
