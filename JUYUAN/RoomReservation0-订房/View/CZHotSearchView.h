//
//  CZHotSearchView.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/3.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZTextField.h"
@class CZHotSearchView;

@protocol CZHotSearchViewDelegate <NSObject>
@optional
- (void)hotView:(CZHotSearchView *)hotView didTextFieldChange:(CZTextField *)textField;
@end

@interface CZHotSearchView : UIView
/** 代理 */
@property (nonatomic, assign) id<CZHotSearchViewDelegate> delegate;
/** 右边按钮事件 */
@property (nonatomic, copy) void (^msgBlock)(NSString *title);
/** 右边文字 */
@property (nonatomic, strong) NSString *msgTitle;
/** 文本框是否允许输入 */
@property (nonatomic, assign, getter=isTextFieldActive) BOOL textFieldActive;
/** 文本框颜色 */
@property (nonatomic, strong) UIColor *textFieldBorderColor;
/** 文本框文字 */
@property (nonatomic, strong) NSString *searchText;
/** 未读数量 */
@property (nonatomic, assign) NSInteger unreaderCount;

- (instancetype)initWithFrame:(CGRect)frame msgAction:(void (^)(NSString *))block;
@end


