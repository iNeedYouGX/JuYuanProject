//
//  JYRegistViewController.m
//  JUYUAN
//
//  Created by 小香菜 on 2019/2/28.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYRegistViewController.h"

@interface JYRegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *allowProtocolButton;
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
// 秒数
@property (nonatomic, assign) NSInteger seconds;
// 定时器
@property (nonatomic, strong) NSTimer *timer;
// 是否在记时
@property (nonatomic, assign) BOOL isCounting;
@end

@implementation JYRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
- (void)setupUI{
    self.submitButton.layer.cornerRadius = 22;
    self.getCodeButton.layer.borderColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00].CGColor;
    self.getCodeButton.layer.borderWidth = 1;
    self.getCodeButton.layer.cornerRadius = 15;
    
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
}
#pragma mark -- 获取验证码
- (IBAction)getCodeAction:(id)sender {
    self.isCounting = YES;
}
#pragma mark -- 同意协议
- (IBAction)allowProtocolAction:(id)sender {
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
