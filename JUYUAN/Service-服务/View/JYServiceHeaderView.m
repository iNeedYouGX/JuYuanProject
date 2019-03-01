//
//  JYServiceHeaderView.m
//  JUYUAN
//
//  Created by 小香菜 on 2019/2/27.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYServiceHeaderView.h"
#import "CZScollerImageTool.h"

@interface JYServiceHeaderView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *imagesView;
@end

@implementation JYServiceHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];

}

- (void)setImageList:(NSArray *)imageList
{
    _imageList = imageList;
    // 创建轮播图
    CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH - 40, 125)];
    imageView.imgList = imageList;
    [self.imagesView addSubview:imageView];
}


@end
