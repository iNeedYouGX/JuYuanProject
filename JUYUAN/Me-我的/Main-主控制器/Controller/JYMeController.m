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

@interface JYMeController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation JYMeController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkLoginStatue];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)checkLoginStatue {
    if ([JYUserInfoManager getUserToken].length == 0) {
        [self.loginButton setTitle:@"点击登录" forState:UIControlStateNormal];
        self.loginButton.enabled = YES;
    } else {
        [self.loginButton setTitle:@"已登录" forState:UIControlStateNormal];
        self.loginButton.enabled = NO;
    }
}
#pragma mark - 临时的退出登录
- (IBAction)logOut:(id)sender {
    [JYUserInfoManager removeAllUserInfo];
    [self checkLoginStatue];
}

#pragma mark - 点击方法
/** 登录 */
- (IBAction)LoginAction
{
    JYLoginController *loginView = [[JYLoginController alloc] init];
    [self presentViewController:loginView animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
