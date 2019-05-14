//
//  JYMeController.m
//  JUYUAN
//
//  Created by JasonBourne on 2019/2/27.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYMeController.h"
#import "JYLoginController.h"
#import "JYUserInfoManager.h"
#import "JYHtmlDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "GXNetTool.h"
@interface JYMeController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UIButton *msgButton;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
/** 我的订单 */
@property (nonatomic, weak) IBOutlet UIView *orderView;
@property (weak, nonatomic) IBOutlet UIView *personInfoView;
@property (weak, nonatomic) IBOutlet UIView *mineContract;
@property (weak, nonatomic) IBOutlet UIView *roomManager;
@property (weak, nonatomic) IBOutlet UIView *discountCoupon;
@end

@implementation JYMeController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [self checkLoginStatue];
    
//    self.photoImageView.layer.cornerRadius = self.photoImageView.width / 2.0;
//    self.photoImageView.layer.masksToBounds = YES;
}

#pragma mark -- 获取个人信息
- (void)getUserInfomation {
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"/api/v1/users/getUserInfo"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [JYUserInfoManager getUserToken];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            NSDictionary *dic = result[@"bizobj"][@"data"][@"user_info"];
            [JYUserInfoManager saveUserInfos:dic];
            NSString *head_img = [JYUserInfoManager getUserInfos][@"head_img"];
            if ([head_img hasPrefix:@"http"]) {
                [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"head_img"]] placeholderImage:[UIImage imageNamed:@"tx"]];
            }
            [self refreshUserName];
        } else {
            [JYUserInfoManager removeAllUserInfo];
            JYLoginController *loginView = [[JYLoginController alloc] init];
            [self presentViewController:loginView animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderViewAction)];
    [self.orderView addGestureRecognizer:tap0];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPersonInfoView)];
    [self.personInfoView addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMineContract)];
    [self.mineContract addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRoomManager)];
    [self.roomManager addGestureRecognizer:tap3];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDiscountCoupon)];
    [self.discountCoupon addGestureRecognizer:tap4];
    
}

- (void)checkLoginStatue {
    if ([JYUserInfoManager getUserToken].length == 0) {
        [self.loginButton setTitle:@"点击登录" forState:UIControlStateNormal];
        self.photoImageView.image = [UIImage imageNamed:@"tx"];
        self.loginButton.enabled = YES;
    } else {
        self.loginButton.enabled = NO;
        [self getUserInfomation];
    }
}

- (void)refreshUserName{
    NSString *user_name = [JYUserInfoManager getUserInfos][@"user_name"];
    if (user_name.length > 0) {
        [self.loginButton setTitle:user_name forState:UIControlStateNormal];
    } else {
        [self.loginButton setTitle:@"已登录" forState:UIControlStateNormal];
    }
}

#pragma mark - 点击方法
/** 登录 */
- (IBAction)LoginAction
{
    JYLoginController *loginView = [[JYLoginController alloc] init];
    [self presentViewController:loginView animated:YES completion:nil];
}

// 设置
- (IBAction)setAction:(id)sender {
    if ([JYUserInfoManager getUserToken].length > 0) {
        JYHtmlDetailViewController *htmlVc = [[JYHtmlDetailViewController alloc] init];
        htmlVc.urlString = [NSString stringWithFormat:@"https://apartment.pinecc.cn/public/frontend/index.html#/setting?token=%@",[JYUserInfoManager getUserToken]];
        [self.navigationController pushViewController:htmlVc animated:true];
    } else {
        [self LoginAction];
    }
    
}
#pragma mark -- 消息
- (IBAction)messageAction:(id)sender {
    if ([JYUserInfoManager getUserToken].length > 0) {
        JYHtmlDetailViewController *htmlVc = [[JYHtmlDetailViewController alloc] init]; 
        htmlVc.urlString = [NSString stringWithFormat:@"https://apartment.pinecc.cn/public/frontend/index.html#/information?token=%@",[JYUserInfoManager getUserToken]];
        [self.navigationController pushViewController:htmlVc animated:true];
    } else {
        [self LoginAction];
    }
    
}

#pragma mark -- 我的订单
- (void)orderViewAction
{
    if ([JYUserInfoManager getUserToken].length > 0) {
        JYHtmlDetailViewController *htmlVc = [[JYHtmlDetailViewController alloc] init]; 
        htmlVc.urlString = [NSString stringWithFormat:@"https://apartment.pinecc.cn/public/frontend/index.html#/order?token=%@",[JYUserInfoManager getUserToken]];
        [self.navigationController pushViewController:htmlVc animated:true];
    } else {
        [self LoginAction];
    }
}

#pragma mark -- 个人资料
- (void)tapPersonInfoView {
    if ([JYUserInfoManager getUserToken].length > 0) {
        JYHtmlDetailViewController *htmlVc = [[JYHtmlDetailViewController alloc] init]; 
        htmlVc.urlString = [NSString stringWithFormat:@"https://apartment.pinecc.cn/public/frontend/index.html#/setting?token=%@",[JYUserInfoManager getUserToken]];
        [self.navigationController pushViewController:htmlVc animated:true];
    } else {
        [self LoginAction];
    }
}

#pragma mark -- 我的合同
- (void)tapMineContract {
    if ([JYUserInfoManager getUserToken].length > 0) {
        JYHtmlDetailViewController *htmlVc = [[JYHtmlDetailViewController alloc] init];
        htmlVc.urlString = [NSString stringWithFormat:@"https://apartment.pinecc.cn/public/frontend/index.html#/contract?token=%@",[JYUserInfoManager getUserToken]];
        [self.navigationController pushViewController:htmlVc  animated:true];
    } else {
        [self LoginAction];
    }
}

#pragma mark -- 我的房管员
- (void)tapRoomManager {
    if ([JYUserInfoManager getUserToken].length > 0) {
        JYHtmlDetailViewController *htmlVc = [[JYHtmlDetailViewController alloc] init];
        htmlVc.urlString = [NSString stringWithFormat:@"https://apartment.pinecc.cn/public/frontend/index.html#/Housekeeper?token=%@",[JYUserInfoManager getUserToken]];
        [self.navigationController pushViewController:htmlVc animated:true];
    } else {
        [self LoginAction];
    }
}

#pragma mark -- 我的优惠券
- (void)tapDiscountCoupon {
    if ([JYUserInfoManager getUserToken].length > 0) {
        JYHtmlDetailViewController *htmlVc = [[JYHtmlDetailViewController alloc] init];
        htmlVc.urlString = [NSString stringWithFormat:@"https://apartment.pinecc.cn/public/frontend/index.html#/coupon?token=%@",[JYUserInfoManager getUserToken]];
        [self.navigationController pushViewController:htmlVc  animated:true];
    } else {
        [self LoginAction];
    }
}

@end
