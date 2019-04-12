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
#import "JYHtmlDetailViewController.h"
#import "JYUserInfoManager.h"

@interface JYShoppingHeaderView () <UITextFieldDelegate>
/** 轮播图父视图 */
@property (nonatomic, weak) IBOutlet UIView *imagesView;
/** 搜索视图 */
@property (nonatomic, weak) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIButton *msgButton;
/** 文本框 */
@property (nonatomic, strong) CZTextField *textField;
/** 轮播图 */
@property (nonatomic, strong) CZScollerImageTool *imageView;
@end

@implementation JYShoppingHeaderView
- (void)setUnreaderCount:(NSInteger)unreaderCount
{
    _unreaderCount = unreaderCount;
    //    if (unreaderCount <= 0) {
    //        self.unreadLabel.hidden = YES;
    //    } else {
    //        self.unreadLabel.hidden = NO;
    //        self.unreadLabel.text = [NSString stringWithFormat:@"%ld", (long)unreaderCount];
    //    }

    if (unreaderCount <= 0) {
        [self.msgButton setImage:[UIImage imageNamed:@"tz2"] forState:UIControlStateNormal];
    } else {
        [self.msgButton setImage:[UIImage imageNamed:@"tz1"] forState:UIControlStateNormal];
    }
}

- (IBAction)msgButtonAction:(id)sender {
    JYHtmlDetailViewController *htmlVC = [[JYHtmlDetailViewController alloc] init];
    htmlVC.urlString = [NSString stringWithFormat:@"https://apartment.pinecc.cn/public/frontend/index.html#/information?token=%@",[JYUserInfoManager getUserToken]];
    NSLog(@"%@",htmlVC.urlString);
    UIViewController *navVc = [self viewController];
    [navVc.navigationController pushViewController:htmlVC animated:true];
}

- (IBAction)shoppingCart:(id)sender {
    JYHtmlDetailViewController *htmlVC = [[JYHtmlDetailViewController alloc] init];
    htmlVC.urlString = [NSString stringWithFormat:@"https://apartment.pinecc.cn/public/frontend/index.html#/cartList?token=%@",[JYUserInfoManager getUserToken]];
    NSLog(@"%@",htmlVC.urlString);
    UIViewController *navVc = [self viewController];
    [navVc.navigationController pushViewController:htmlVC animated:true];
}

+ (instancetype)shoppingHeaderView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)setImageList:(NSArray *)imageList
{
    _imageList = imageList;
    // 创建轮播图
    self.imageView.imgList = imageList;
    [self.imagesView addSubview:self.imageView];
}

- (CZScollerImageTool *)imageView
{
    if (_imageView == nil) {
        _imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH - 40, 125)];
        
        __weak typeof(self) weakSelf = self;
        _imageView.block = ^(NSInteger index) {
            NSLog(@"hahah ---- %ld", index);
            JYHtmlDetailViewController *htmlVc = [[JYHtmlDetailViewController alloc] init]; 
            htmlVc.urlString = [NSString stringWithFormat:@"https://apartment.pinecc.cn/public/frontend/index.html#/adDetail?token=%@&brandId=%@",[JYUserInfoManager getUserToken], weakSelf.imageList[index]];
            NSLog(@"%@", htmlVc.urlString);
            UIViewController *vc = [weakSelf viewController];
            [vc.navigationController pushViewController:htmlVc animated:true];
        };
    }
    return _imageView;
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
    toVc.userHouseNumber = [JYUserInfoManager getUserHouseNumber];;
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
