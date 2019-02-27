//
//  JYMeController.m
//  JUYUAN
//
//  Created by JasonBourne on 2019/2/27.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYMeController.h"
#import "JYLoginController.h"

@interface JYMeController ()

@end

@implementation JYMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
