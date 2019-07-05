//
//  JYForgetWordViewController.m
//  JUYUAN
//
//  Created by 小香菜 on 2019/2/28.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYForgetWordViewController.h"
#import "GXNetTool.h"
#import "JYUserInfoManager.h"

@interface JYForgetWordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *allowProtocolButton;

@property (weak, nonatomic) IBOutlet UITextView *protocolTextView;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
// 秒数
@property (nonatomic, assign) NSInteger seconds;
// 定时器
@property (nonatomic, strong) NSTimer *timer;
// 是否在记时
@property (nonatomic, assign) BOOL isCounting;
// 是否勾选了用户协议
@property (nonatomic, assign) BOOL selectProtocol;
@end

@implementation JYForgetWordViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
- (void)setupUI{
    self.submitButton.layer.cornerRadius = 22;
    self.getCodeButton.layer.borderColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00].CGColor;
    self.getCodeButton.layer.borderWidth = 1;
    self.getCodeButton.layer.cornerRadius = 15;
    [self buildProtocolViewUI];
}
- (void)buildProtocolViewUI{
    self.protocolTextView.delegate = self;
    NSString *titleString = @"我已阅读并同意";
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
#pragma mark -- 返回
- (IBAction)backAction:(id)sender {
    if (_timer) {
        self.isCounting = NO;
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark -- 提交
- (IBAction)submitAction:(id)sender {
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
    // 此处要询问设置密码的规则
    if (self.passwordTextField.text.length < 6) {
        [CZProgressHUD showProgressHUDWithText:@"请输入不少于6位的新密码"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }
    if (!self.selectProtocol) {
        [CZProgressHUD showProgressHUDWithText:@"请勾选同意隐私政策"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }
    // 找回密码
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = self.mobileTextField.text;
    param[@"verfy_code"] = self.codeTextField.text;
    param[@"password"] = self.passwordTextField.text;
    
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"/api/v1/users/resetPassword"];
    
    [GXNetTool PutNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            
            [CZProgressHUD showProgressHUDWithText:@"修改成功"];
            // 存储token
            NSString *token = result[@"bizobj"][@"data"][@"token"];
            NSString *refresh_token = result[@"bizobj"][@"data"][@"refresh_token"];
            [JYUserInfoManager saveUserToken:token];
            [JYUserInfoManager saveUserRefreshtoken:refresh_token];
            [self getUserInfomation];
            //把最前面的视图控制器dismiss掉
            UIViewController *parentVC = self.presentingViewController;
            UIViewController *bottomVC;
            while (parentVC) {
                bottomVC = parentVC;
                parentVC = parentVC.presentingViewController;
            }
            [bottomVC dismissViewControllerAnimated:NO completion:^{
                // 如果有需要就切换到需要的视图
            }];
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
#pragma mark -- 获取验证码
- (IBAction)getCodeAction:(id)sender {
    [self sendVerfyCodeNetwork];
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
    param[@"type"] = @(3); // 码验证类型 1.用户注册 2:快速登录 3:重置密码 4:待拓展
    
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
#pragma mark -- 同意协议
- (IBAction)allowProtocolAction:(id)sender {
    if (!self.selectProtocol) {
        [self.allowProtocolButton setImage:[UIImage imageNamed:@"5"] forState:UIControlStateNormal];
    } else {
        [self.allowProtocolButton setImage:[UIImage imageNamed:@"7"] forState:UIControlStateNormal];
    }
    self.selectProtocol  = !self.selectProtocol;
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
