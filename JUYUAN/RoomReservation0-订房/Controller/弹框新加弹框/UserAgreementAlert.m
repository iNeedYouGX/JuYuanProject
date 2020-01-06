//
//  UserAgreementAlert.m
//  JUYUAN
//
//  Created by JasonBourne on 2020/1/6.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "UserAgreementAlert.h"

@interface UserAgreementAlert ()

@end

@implementation UserAgreementAlert

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


}

#pragma mark -- 返回
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)agreementBun:(id)sender {

    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"agreement"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)UserAgreementAction:(id)sender {
    JYHtmlDetailViewController *htmlVc = [[JYHtmlDetailViewController alloc] init];
    htmlVc.urlString = @"https://apartment.pinecc.cn/public/frontend/index.html#/Agreement";
    [self presentViewController:htmlVc animated:NO completion:nil];
}

- (IBAction)PrivacyPolicyAction:(id)sender {
    JYHtmlDetailViewController *htmlVc = [[JYHtmlDetailViewController alloc] init];
    htmlVc.urlString = @"https://apartment.pinecc.cn/public/frontend/index.html#/useragreement";
    [self presentViewController:htmlVc animated:NO completion:nil];
}

@end
