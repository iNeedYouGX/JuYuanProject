//
//  JYShoppingSearchController.m
//  JUYUAN
//
//  Created by JasonBourne on 2019/4/10.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYShoppingSearchController.h"
#import "CZTextField.h"

@interface JYShoppingSearchController () <UITextFieldDelegate>
/** 文本框 */
@property (nonatomic, strong) CZTextField *textField;
@end

@implementation JYShoppingSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSearchView];
}

#pragma mark - 加载搜索框
- (void)setupSearchView
{
    UIView *backView = [[UIView alloc] init];
    [self.view addSubview:backView];
    backView.x = 14;
    backView.y = (IsiPhoneX ? 44 + 12 : 20 + 12);
    backView.width = SCR_WIDTH - 28;
    backView.height = 34;
    
    CZTextField *textF = [[CZTextField alloc] init];
    textF.placeholderStr = @"";
    textF.width = backView.width - 50;
    textF.height = backView.height;
    self.textField = textF;
    self.textField.delegate = self;
    [backView addSubview:textF];
    
    UIButton *msgBtn = [[UIButton alloc] init];
//    [msgBtn setImage:[UIImage imageNamed:@"tz1"] forState:UIControlStateNormal];
    [msgBtn setTitle:@"取消" forState:UIControlStateNormal];
    msgBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [msgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    msgBtn.x = CGRectGetMaxX(textF.frame);
    msgBtn.size = CGSizeMake(40, textF.height);
    msgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [msgBtn addTarget:self action:@selector(msgAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:msgBtn];
}

@end
