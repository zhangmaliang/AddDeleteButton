//
//  ViewController.m
//  自定义键盘
//
//  Created by 张马亮 on 16/7/1.
//  Copyright © 2016年 Apress. All rights reserved.
//  用来表示一页的表情（里面显示1~20个表情）

#import <UIKit/UIKit.h>


@class ZMLEmotion;

@interface ZMLEmotionPageView : UIView

@property (nonatomic, strong) NSArray<ZMLEmotion *> *emotions;


// 点击了表情中的删除按钮回调
@property (nonatomic, copy) void (^emotionDidDeleteBlock)();

// 点击了表情中的某一个表情回调
@property (nonatomic, copy) void (^emotionDidSelectBlock)(ZMLEmotion *emotion);

@end
