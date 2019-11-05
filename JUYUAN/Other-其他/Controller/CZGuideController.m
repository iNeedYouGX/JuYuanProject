//
//  CZGuideController.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/26.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZGuideController.h"
#import "CZTabBarController.h"
@interface CZGuideController ()

@end

@implementation CZGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT)];
    scrollerView.pagingEnabled = YES;
    scrollerView.showsVerticalScrollIndicator = NO;
    scrollerView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollerView];
    
    
    
    for (int i = 0; i  < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.x = SCR_WIDTH * i;
        imageView.size = CGSizeMake(SCR_WIDTH, SCR_HEIGHT);
        [scrollerView addSubview:imageView];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d", i]];
    }
    scrollerView.contentSize = CGSizeMake(SCR_WIDTH * 4, 0);
    
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"点击进入" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.x = SCR_WIDTH * 3 + SCR_WIDTH / 2 - 75;
    btn.y = SCR_HEIGHT - 150;
    btn.width = 150;
    btn.height = 44;
    btn.layer.cornerRadius = 5;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    [scrollerView addSubview:btn];
    [btn addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clicked
{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[CZTabBarController alloc] init];;
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
