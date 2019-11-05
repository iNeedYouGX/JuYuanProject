//
//  JYServiceHeaderView.m
//  JUYUAN
//
//  Created by 小香菜 on 2019/2/27.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYServiceHeaderView.h"
#import "CZScollerImageTool.h"
#import "JYHtmlDetailViewController.h"
#import "JYUserInfoManager.h"

@interface JYServiceHeaderView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *imagesView;
@property (weak, nonatomic) IBOutlet UIButton *msgButton;
/** 未读按钮 */
@property (nonatomic, strong) UILabel *unreadLabel;

@end

@implementation JYServiceHeaderView

- (void)setUnreaderCount:(NSInteger)unreaderCount
{
    _unreaderCount = unreaderCount;
    if (unreaderCount <= 0) {
        self.unreadLabel.hidden = YES;
    } else {
        self.unreadLabel.hidden = NO;
        self.unreadLabel.text = [NSString stringWithFormat:@"%ld", (long)unreaderCount > 99 ? 99 : (long)unreaderCount];
    }
}

- (UILabel *)unreadLabel
{
    if (_unreadLabel == nil) {
        UILabel *unreadLabel = [[UILabel alloc] init];
        //    unreadLabel.hidden = YES;
        unreadLabel.userInteractionEnabled = NO;
        self.unreadLabel = unreadLabel;
        unreadLabel.x = CZGetX(self.msgButton) - 10;
        unreadLabel.y = self.msgButton.y;
        unreadLabel.textColor = CZGlobalWhiteBg;
        unreadLabel.font = [UIFont systemFontOfSize:11];
        unreadLabel.textAlignment = NSTextAlignmentCenter;
        unreadLabel.size = CGSizeMake(15, 15);
        unreadLabel.backgroundColor = [UIColor redColor];
        unreadLabel.layer.cornerRadius = unreadLabel.width / 2.0;
        unreadLabel.layer.masksToBounds = YES;
        [self addSubview:unreadLabel];
    }
    return _unreadLabel;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self layoutIfNeeded];



}
- (void)controlMegButtonHide:(BOOL)hide {
    _msgButton.hidden = hide;
}
- (IBAction)msgButtonAction:(id)sender {
    self.block();
}

- (void)setImageList:(NSArray *)imageList
{
    _imageList = imageList;
    // 创建轮播图
    CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH - 40, 125)];
    imageView.imgList = imageList;
    __weak typeof(self) weakSelf = self;
    imageView.block = ^(NSInteger index) {
        NSLog(@"hahah ---- %ld", index);
        JYHtmlDetailViewController *htmlVc = [[JYHtmlDetailViewController alloc] init];
        htmlVc.urlString = [NSString stringWithFormat:@"https://apartment.pinecc.cn/public/frontend/index.html#/adDetail?token=%@&brandId=%@",[JYUserInfoManager getUserToken], weakSelf.imageListId[index]];
        NSLog(@"%@", htmlVc.urlString);
        UIViewController *vc = [weakSelf viewController];
        [vc.navigationController pushViewController:htmlVc animated:true];
    };
    [self.imagesView addSubview:imageView];
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
