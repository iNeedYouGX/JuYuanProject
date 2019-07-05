//
//  CZUpdataView.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/16.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZUpdataView.h"

@interface CZUpdataView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *chengeContent;


/** 删除按钮 */
@property (nonatomic, weak) IBOutlet UIButton *delectBtn;
@end

@implementation CZUpdataView
+ (instancetype)updataView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0] ;
}

/** 去App Store */
- (IBAction)gotoUpdata
{
    //跳转到App Store
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services:///?action=download-manifest&url=https://raw.githubusercontent.com/iNeedYouGX/plistDownLoad/master/test.plist"]];
}

/** 删除自己 */
- (IBAction)deleteView
{
    [self removeFromSuperview];
}

- (void)setVersionMessage:(NSDictionary *)versionMessage
{
    _versionMessage = versionMessage;
    self.versionLabel.text = versionMessage[@"version"];
    self.chengeContent.text = versionMessage[@"description"];
//    if ([versionMessage[@"needUpdate"] integerValue] == 1) {    
//        self.delectBtn.hidden = YES;
//    }
}



@end
