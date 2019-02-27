//
//  JYLoginController.m
//  JUYUAN
//
//  Created by JasonBourne on 2019/2/27.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYLoginController.h"

@interface JYLoginController ()

@end

@implementation JYLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;   
}

/** pop */
- (IBAction)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
