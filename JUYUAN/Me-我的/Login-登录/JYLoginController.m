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
#import "GXNetTool.h"
#import "JYUserInfoManager.h"
#import "JYHtmlDetailViewController.h"

@interface JYLoginController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewTop;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UITextView *protocolTextView;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetwordButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getCodeButtonTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getCodeButtonBottom;

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getCodeButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *geCodeButtonTop;

@end

@implementation JYLoginController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.loginButton.layer.cornerRadius = 22;
    self.bottomViewHeight.constant = 80 + kBottomSafeHeight;
    self.pageType = 0;
    if (SCR_HEIGHT < 667) {
        self.middleViewTop.constant = 15;
        self.middleViewBottom.constant = 20;
    }
    self.getCodeButtonWidth.constant = 15;
    self.getCodeButtonTrailing.constant = 10;
    self.getCodeButtonBottom.constant = 17;
    self.geCodeButtonTop.constant = 17;
    [self buildProtocolViewUI];
    
    [self.getCodeButton setImage:[UIImage imageNamed:@"3"] forState:UIControlStateNormal];
    self.codeTextField.secureTextEntry = YES;
    
}
- (void)buildProtocolViewUI{
    self.protocolTextView.delegate = self;
    NSString *titleString = @"登录即代表您同意";
    NSString *tapString = @"《8901公寓用户服务协议》";
    NSMutableAttributedString *titleAttriString = [[NSMutableAttributedString alloc] initWithString:titleString];
    NSMutableAttributedString *tapAttriString = [[NSMutableAttributedString alloc] initWithString:tapString];
    NSRange selectedRange = {0, [tapAttriString length]};
    [tapAttriString beginEditing];
    [tapAttriString addAttribute:NSLinkAttributeName
                           value:@"fuwuxiwyi://"
                           range:selectedRange];
    [titleAttriString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithRed:0.25 green:0.26 blue:0.31 alpha:1.00] // 更改颜色
                             range:NSMakeRange(0, titleAttriString.length)];
    [tapAttriString endEditing];
    [titleAttriString appendAttributedString:tapAttriString];
    [self.protocolTextView setAttributedText:titleAttriString];
    //设置linkTextAttributes颜色
    _protocolTextView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.82 blue:0.26 alpha:1.00]};
}
#pragma mark 富文本点击事件-

-(BOOL)textView:(UITextView * )textView shouldInteractWithURL:(NSURL* )URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"fuwuxiwyi"]) {
        NSLog(@"fuwuxiwyi点击");
        JYHtmlDetailViewController *htmlVc = [[JYHtmlDetailViewController alloc] init];
        htmlVc.urlString = @"https://apartment.pinecc.cn/public/frontend/index.html#/Agreement";
//        [self.navigationController pushViewController:htmlVc animated:true];
        [self presentViewController:htmlVc animated:NO completion:nil];
        return NO;
    }
    return YES;
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
        [self.getCodeButton setImage:[UIImage imageNamed:@"6"] forState:UIControlStateNormal];
        [self.getCodeButton setTitle:@"" forState:UIControlStateNormal];
        self.getCodeButtonWidth.constant = 15;
        self.getCodeButtonTrailing.constant = 10;
        self.getCodeButtonBottom.constant = 17;
        self.geCodeButtonTop.constant = 17;
        self.codeTextField.placeholder = @"密码";
        self.bgImageView.image = [UIImage imageNamed:@"bg1"];
        self.mobileTextField.placeholder = @"账号/手机号";
        self.mobileTextField.keyboardType = UIKeyboardTypeDefault;
    } else {
        [self.getCodeButton setImage:nil forState:UIControlStateNormal];
        [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getCodeButtonWidth.constant = 70;
        self.getCodeButtonTrailing.constant = 0;
        self.getCodeButtonBottom.constant = 0;
        self.geCodeButtonTop.constant = 0;
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
    if (_pageType == 0) {
        [self passwordLoginNetwork];
    } else {
        [self fastLoginNetwork];
    }
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
        [self sendVerfyCodeNetwork];
    }
   
    
}
#pragma mark -- 获取验证码网络
- (void)sendVerfyCodeNetwork{
    if (self.mobileTextField.text.length != 11) {
        [CZProgressHUD showProgressHUDWithText:@"请输入正确的手机号"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }
     self.isCounting = YES;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = self.mobileTextField.text;
    param[@"type"] = @(2); // 码验证类型 1.用户注册 2:快速登录 3:重置密码 4:待拓展
    
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/v1/codes"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            [CZProgressHUD showProgressHUDWithText:@"验证码发送成功"];
            
            
        } else {
            [CZProgressHUD showProgressHUDWithText:@"验证码发送失败"];
        }
        [CZProgressHUD hideAfterDelay:1.5];
    } failure:^(NSError *error) {
       
    }];

}
#pragma mark -- 快捷登录网络
- (void)fastLoginNetwork {
    if (self.mobileTextField.text.length != 11) {
        [CZProgressHUD showProgressHUDWithText:@"请输入正确的手机号"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }
    if (self.codeTextField.text.length == 0) {
        [CZProgressHUD showProgressHUDWithText:@"请输入验证码"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = self.mobileTextField.text;
    param[@"verfy_code"] = self.codeTextField.text;
    
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"/api/v1/users/fastlogin"];
    [GXNetTool PutNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            
            [CZProgressHUD showProgressHUDWithText:@"登录成功"];
            // 存储token
            NSString *token = result[@"bizobj"][@"data"][@"token"];
            NSString *refresh_token = result[@"bizobj"][@"data"][@"refresh_token"];
            [JYUserInfoManager saveUserToken:token];
            [JYUserInfoManager saveUserRefreshtoken:refresh_token];
            [self getUserInfomation];
            [self postLoginCenter];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
            
        }
        [CZProgressHUD hideAfterDelay:1.5];
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
            [JYUserInfoManager saveUserInfos:dic];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 密码登录网络
- (void)passwordLoginNetwork {
    if (self.mobileTextField.text.length != 11) {
        [CZProgressHUD showProgressHUDWithText:@"请输入正确的手机号"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }
    // 此处要询问设置密码的规则
    if (self.codeTextField.text.length < 6) {
        [CZProgressHUD showProgressHUDWithText:@"请输入不少于6位的密码"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = self.mobileTextField.text;
    param[@"password"] = self.codeTextField.text;
    
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"/api/v1/users/login"];
    
    [GXNetTool PutNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            
            [CZProgressHUD showProgressHUDWithText:@"登录成功"];
            // 存储token
            NSString *token = result[@"bizobj"][@"data"][@"token"];
            NSString *refresh_token = result[@"bizobj"][@"data"][@"refresh_token"];
            [JYUserInfoManager saveUserToken:token];
            [JYUserInfoManager saveUserRefreshtoken:refresh_token];
            [self getUserInfomation];
            [self postLoginCenter];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        [CZProgressHUD hideAfterDelay:1.5];
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark -- 密码加密

-(void)setIsSecret:(BOOL)isSecret {
    _isSecret = isSecret;
    if (!_isSecret) {
        [self.getCodeButton setImage:[UIImage imageNamed:@"6"] forState:UIControlStateNormal];
        self.codeTextField.secureTextEntry = NO;
    } else {
        [self.getCodeButton setImage:[UIImage imageNamed:@"3"] forState:UIControlStateNormal];
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

- (void)postLoginCenter
{
    NSString *postLoginCenterNotfi = @"postLoginCenterNotfi";
    [[NSNotificationCenter defaultCenter] postNotificationName:postLoginCenterNotfi object:nil];
}

@end
