//
//  JYShoppingHeaderView.m
//  JUYUAN
//
//  Created by JasonBourne on 2019/4/2.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYShoppingHeaderView.h"
#import "CZScollerImageTool.h"
#import "CZTextField.h"
#import "JYShoppingSearchController.h"

@interface JYShoppingHeaderView () <UITextFieldDelegate>
/** 轮播图父视图 */
@property (nonatomic, weak) IBOutlet UIView *imagesView;
/** 搜索视图 */
@property (nonatomic, weak) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIButton *msgButton;
/** 文本框 */
@property (nonatomic, strong) CZTextField *textField;
@end

@implementation JYShoppingHeaderView

+ (instancetype)shoppingHeaderView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)setImageList:(NSArray *)imageList
{
    _imageList = imageList;
    // 创建轮播图
    CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH - 40, 125)];
    imageView.imgList = imageList;
    [self.imagesView addSubview:imageView];
}

#pragma mark - 加载搜索框
- (void)setupSearchView
{
    CZTextField *textF = [[CZTextField alloc] init];
    textF.placeholderStr = @"";
    textF.width = SCR_WIDTH - 40;
    textF.height = self.searchView.height;
    self.textField = textF;
    self.textField.delegate = self;
    [self.searchView addSubview:textF];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIViewController *vc = [self viewController];
    JYShoppingSearchController *toVc = [[JYShoppingSearchController alloc] init];
    [vc.navigationController pushViewController:toVc animated:YES];
    return NO;
}

// 找到父控制器
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
