//
//  ViewController.m
//  自定义键盘
//
//  Created by 张马亮 on 16/7/1.
//  Copyright © 2016年 Apress. All rights reserved.
// 拥有占位文字功能的TextView，label实现

#import <UIKit/UIKit.h>

@interface ZMLPlaceholderTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end
