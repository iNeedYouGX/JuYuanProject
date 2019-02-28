//
//  JYLoginController.m
//  JUYUAN
//
//  Created by JasonBourne on 2019/2/27.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYLoginController.h"
#import "JYRegistViewController.h"
#import "JYForgetWordViewController.h"
@interface JYLoginController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewTop;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetwordButton;
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;
// 页面类型 0:密码登录 1:快捷登录
@property (nonatomic, assign) NSInteger pageType;
// 秒数
@property (nonatomic, assign) NSInteger seconds;
// 定时器
@property (nonatomic, strong) NSTimer *timer;
// 是否在记时
@property (nonatomic, assign) BOOL isCounting;
// 密码是否加密
@property (nonatomic, assign) BOOL isSecret;
@end

@implementation JYLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.layer.cornerRadius = 22;
    self.bottomViewHeight.constant = 80 + kBottomSafeHeight;
    self.pageType = 0;
    if (SCR_HEIGHT < 667) {
        self.middleViewTop.constant = 15;
        self.middleViewBottom.constant = 20;
    }
    
    
}

- (void)setIsCounting:(BOOL)isCounting {
    _isCounting = isCounting;
    if (isCounting) {
        _seconds = 60;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        self.getCodeButton.enabled = NO;
        [self.getCodeButton setTitleColor:[UIColor colorWithRed:0.62 green:0.64 blue:0.66 alpha:1.00] forState:UIControlStateNormal];
    } else {
        [_timer invalidate];
        _timer = nil;
        self.getCodeButton.enabled = YES;
        [self.getCodeButton setTitleColor:[UIColor colorWithRed:0.25 green:0.26 blue:0.31 alpha:1.00]forState:UIControlStateNormal];
        [self.getCodeButton setTitle:@"获取验证码"forState:UIControlStateNormal];
    }
}
#pragma mark -- 密码登录
- (IBAction)codeLoginAction:(id)sender {
    self.pageType = 0;
    [self changeLoginMothedWithType:YES];
    
}
#pragma mark -- 快捷登录
- (IBAction)fastLoginAction:(id)sender {
    self.pageType = 1;
    [self changeLoginMothedWithType:NO];
}
- (void)changeLoginMothedWithType:(BOOL)isCodeLogin {
    self.isCounting = NO;
    self.lineView.hidden = isCodeLogin;
    self.registButton.hidden = !isCodeLogin;
    self.forgetwordButton.hidden = !isCodeLogin;
    self.codeTextField.text = @"";
    if (isCodeLogin) {
        [self.getCodeButton setImage:[UIImage imageNamed:@"wx"] forState:UIControlStateNormal];
        [self.getCodeButton setTitle:@"" forState:UIControlStateNormal];
        self.protocolLabel.text = @"登录即代表您同意《8901公寓用户服务协议》";
        self.codeTextField.placeholder = @"密码";
        self.bgImageView.image = [UIImage imageNamed:@"bg1"];
        self.mobileTextField.placeholder = @"账号/手机号";
        self.mobileTextField.keyboardType = UIKeyboardTypeDefault;
    } else {
        [self.getCodeButton setImage:nil forState:UIControlStateNormal];
        [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.protocolLabel.text = @"登录即代表您同意《8901公寓用户服务协议》和《隐私政策》";
        self.codeTextField.placeholder = @"短信验证码";
         self.bgImageView.image = [UIImage imageNamed:@"bg2"];
        _isSecret = NO;
        self.codeTextField.secureTextEntry = NO;
        self.mobileTextField.placeholder = @"手机号";
        self.mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;   
}

/** pop */
- (IBAction)goBack
{
    if (_timer) {
        self.isCounting = NO;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -- 注册
- (IBAction)registAction:(id)sender {
    JYRegistViewController *vc = [[JYRegistViewController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
}
#pragma mark -- 忘记密码
- (IBAction)forgrtwordAction:(id)sender {
    JYForgetWordViewController *vc = [[JYForgetWordViewController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
}
#pragma mark -- 登录
- (IBAction)loginAction:(id)sender {
}
#pragma mark -- 微信
- (IBAction)wechatAction:(id)sender {
}
#pragma mark -- QQ
- (IBAction)qqAction:(id)sender {
}
#pragma mark -- 获取验证码
- (IBAction)getCodeAction:(id)sender {
    if (_pageType == 0) {
    self.isSecret = !_isSecret;
    } else {
        self.isCounting = YES;
    }
    
}
#pragma mark -- 密码加密

-(void)setIsSecret:(BOOL)isSecret {
    _isSecret = isSecret;
    if (!_isSecret) {
        [self.getCodeButton setImage:[UIImage imageNamed:@"wx"] forState:UIControlStateNormal];
        self.codeTextField.secureTextEntry = NO;
    } else {
        [self.getCodeButton setImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
        self.codeTextField.secureTextEntry = YES;
    }
}
#pragma mark -- 定时器方法
- (void)timerAction{
    if (_seconds == 1) {
        
        self.isCounting = NO;
    } else {
        _seconds -= 1;
        [self.getCodeButton setTitle:[NSString stringWithFormat:@"重新发送(%ld)",_seconds] forState:UIControlStateNormal];
        
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

@end
