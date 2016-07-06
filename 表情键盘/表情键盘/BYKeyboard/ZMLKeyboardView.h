//
//  ZMLKeyboardView.h
//  自定义键盘
//
//  Created by 张马亮 on 16/7/1.
//  Copyright © 2016年 Apress. All rights reserved.
//  带表情键盘的自定义输入框视图

#import <UIKit/UIKit.h>

@interface ZMLKeyboardView : UIView

/**
 *  展示自定义键盘视图
 *
 *  @param height        容器视图高度
 *  @param sendTextBlock 点击键盘上的发送按钮回调
 */
+ (instancetype)showKeyboardViewWithContainerHeight:(CGFloat)height sendTextBlock:(void (^)(NSString *text))sendTextBlock;


- (void)becomeFirstResponder;

- (void)resignFirstResponder;

/***  设置输入框文字*/
- (void)setInputViewText:(NSString *)text;

/***  设置输入框占位文字*/
- (void)setInputViewPlaceholderText:(NSString *)text;

/***  监听键盘的出现/消失*/
@property (nonatomic, copy) void (^keyboardAppearAndDismiss)(BOOL isAppear);

@end
