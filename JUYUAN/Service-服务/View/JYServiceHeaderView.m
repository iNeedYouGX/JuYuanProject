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

@end

@implementation JYServiceHeaderView

- (void)setUnreaderCount:(NSInteger)unreaderCount
{
    _unreaderCount = unreaderCount;

    if (unreaderCount <= 0) {
        [self.msgButton setImage:[UIImage imageNamed:@"tz2"] forState:UIControlStateNormal];
    } else {
        [self.msgButton setImage:[UIImage imageNamed:@"tz1"] forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];

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
