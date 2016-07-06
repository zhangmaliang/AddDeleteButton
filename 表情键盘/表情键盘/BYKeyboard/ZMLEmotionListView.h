//
//  ViewController.m
//  自定义键盘
//
//  Created by 张马亮 on 16/7/1.
//  Copyright © 2016年 Apress. All rights reserved.
//  表情键盘顶部的内容:scrollView + pageControl

#import <UIKit/UIKit.h>
@class ZMLEmotion;

@interface ZMLEmotionListView : UIView

- (void)setEmotions:(NSArray<ZMLEmotion *> *)emotions deleteBlock:(void(^)())deleteBlock sendBlock:(void (^)())sendBlock selectBlock:(void (^)(ZMLEmotion *emotion))selectBlock;

@end
