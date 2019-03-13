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
@interface JYMeController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UIButton *msgButton;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *personInfoView;
@property (weak, nonatomic) IBOutlet UIView *mineContract;
@property (weak, nonatomic) IBOutlet UIView *roomManager;
@property (weak, nonatomic) IBOutlet UIView *discountCoupon;
@end

@implementation JYMeController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkLoginStatue];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        self.loginButton.enabled = YES;
    } else {
        [self.loginButton setTitle:@"已登录" forState:UIControlStateNormal];
        self.loginButton.enabled = NO;
        NSString *photo = [JYUserInfoManager getUserInfos][@"head_img"];
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@"tx"]];
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
