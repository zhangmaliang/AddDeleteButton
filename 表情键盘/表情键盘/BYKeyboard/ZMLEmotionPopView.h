//
//  ViewController.m
//  自定义键盘
//
//  Created by 张马亮 on 16/7/1.
//  Copyright © 2016年 Apress. All rights reserved.
//  表情点击后的泡泡泡泡

#import <UIKit/UIKit.h>
@class ZMLEmotion, ZMLEmotionButton;

@interface ZMLEmotionPopView : UIView

+ (instancetype)popView;

- (void)showFrom:(ZMLEmotionButton *)button;
@end
