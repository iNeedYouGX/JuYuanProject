//
//  JYHtmlDetailViewController.m
//  JUYUAN
//
//  Created by 小香菜 on 2019/3/11.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYHtmlDetailViewController.h"
#import <WebKit/WebKit.h>
#import "JYLoginController.h"
#import "JYUserInfoManager.h"

@interface JYHtmlDetailViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation JYHtmlDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWKWebView];
    
    
    NSString *postLoginCenterNotfi = @"postLoginCenterNotfi";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotifi) name:postLoginCenterNotfi object:nil];
}

- (void)receiveNotifi
{
    NSLog(@"------------------");
    //OC调用JS  onReceiveToken()是JS方法名，completionHandler是异步回调block
    NSString *jsString = [NSString stringWithFormat:@"onReceiveToken('%@')", [JYUserInfoManager getUserToken]];
    [_webView evaluateJavaScript:jsString completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        NSLog(@"改变");
    }];
}


- (void)loadWKWebView {
    [self.view addSubview:self.webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [_webView loadRequest:request];
}

- (WKWebView *)webView {
    if (_webView == nil) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, SCR_WIDTH, SCR_HEIGHT - kStatusBarHeight) configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        
        
    }
    return _webView;
}

- (void)goBack:(UIButton *)sender
{
    sender.hidden = YES;
    [self.webView goBack];
}

// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
//    btn.x = 14;
//    btn.y = 25;
//    btn.width = 20;
//    btn.height = 20;
//    [btn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString * urlStr = navigationAction.request.URL.absoluteString;
    NSLog(@"发送跳转请求：%@",urlStr);
    //自己定义的协议头
    NSString *popString = @"http://apartment.pinecc.cn/index"; // 返回
    NSString *noToken = @"http://apartment.pinecc.cn/login"; // token没有值, 弹登录
    NSString *loginOut = @"http://apartment.pinecc.cn/loginOut"; //登出
    NSString *cellPhone = @"tel:";
    if([urlStr isEqualToString:popString]){
//        [[UIApplication sharedApplication] openURL:@"https:alixx" options:nil completionHandler:nil];
        
        
        [self navControllerPop];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else if ([urlStr isEqualToString:noToken]) {
        JYLoginController *loginView = [[JYLoginController alloc] init];
        [self presentViewController:loginView animated:YES completion:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        // 退出登录
    } else if ([urlStr isEqualToString:loginOut]) {
        [JYUserInfoManager removeAllUserInfo];
        [self.navigationController popViewControllerAnimated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else if ([urlStr hasPrefix:@"alipay://"] || [urlStr hasPrefix:@"alipays://"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        
        
        decisionHandler(WKNavigationActionPolicyCancel);
    } else if ([urlStr hasPrefix:@"weixin://"]) {
        BOOL success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        if (!success) {
            [CZProgressHUD showProgressHUDWithText:@"未安装微信"];
            [CZProgressHUD hideAfterDelay:1.5];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    } else if ([urlStr hasPrefix:@"https://mclient.alipay.com/cashier/mobilepay.htm"]){
        
        decisionHandler(WKNavigationActionPolicyAllow);
    } else if ([urlStr hasPrefix:cellPhone]) { // 打电话
        /** 打电话 */
        NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@", [urlStr substringFromIndex:4]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)navControllerPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation 
{
    NSLog(@"%s -- 页面开始加载时调用", __FUNCTION__);
    // 转菊花
    [CZProgressHUD showProgressHUDWithText:nil];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation 
{
    NSLog(@"%s -- 页面加载完成之后调用", __FUNCTION__);
    // 隐藏
    [CZProgressHUD hideAfterDelay:0];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error 
{
    NSLog(@"%s -- 页面加载失败时调用", __FUNCTION__);
    // 隐藏
    [CZProgressHUD showProgressHUDWithText:@"页面加载失败"];
    [CZProgressHUD hideAfterDelay:1.5];
    [self.navigationController popViewControllerAnimated:YES];
} 


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

