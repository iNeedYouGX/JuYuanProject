//
//  CZProgressHUD.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/9.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZProgressHUD.h"
#import "Masonry.h"
#import "SVProgressHUD.h"

@interface CZProgressHUD ()
/** 整个view */
@property (nonatomic, strong) CZProgressHUD *hud;
/** 显示的文字 */
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation CZProgressHUD

static id _instance;

+ (instancetype)shareProgress
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return _instance;
}

- (UILabel *)textLabel
{
    if (_textLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        label.layer.cornerRadius = 13;
        label.layer.masksToBounds = YES;
        label.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.87];
        _textLabel = label;
    }
    return _textLabel;
}

+ (instancetype)showProgressHUDWithText:(NSString *)text
{
    if (text == nil) {
        [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
        [SVProgressHUD setForegroundColor:[UIColor blackColor]];
        [SVProgressHUD show];
        return nil;
    } else {
        CZProgressHUD *hud = [self shareProgress];
        hud.backgroundColor = [UIColor clearColor];
        [[UIApplication sharedApplication].keyWindow addSubview: hud];
        
        [hud addSubview:hud.textLabel];
        hud.textLabel.text = [NSString stringWithFormat:@"　%@　", text];
        [hud.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(hud);
            make.height.equalTo(@(26));
        }];
        return hud;
        
    }
    
}

+ (void)hideAfterDelay:(NSTimeInterval)delay
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [[self shareProgress] removeFromSuperview];
    });
}


@end
