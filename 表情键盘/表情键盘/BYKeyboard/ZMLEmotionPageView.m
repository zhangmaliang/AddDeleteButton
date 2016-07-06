//
//  ViewController.m
//  自定义键盘
//
//  Created by 张马亮 on 16/7/1.
//  Copyright © 2016年 Apress. All rights reserved.
//  用来表示一页的表情（里面显示1~20个表情）

#import "ZMLEmotionPageView.h"
#import "ZMLEmotion.h"
#import "ZMLEmotionPopView.h"
#import "UIView+ZMLFrame.h"
#import "ZMLKeyboardConst.h"

@interface ZMLEmotionPageView()
/** 点击表情后弹出的放大镜 */
@property (nonatomic, strong) ZMLEmotionPopView *popView;
/** 删除按钮 */
@property (nonatomic, weak) UIButton *deleteButton;

@end

@implementation ZMLEmotionPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self.deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPageView:)]];
    }
    return self;
}

/**
 *  根据手指位置所在的表情按钮
 */
- (ZMLEmotionButton *)emotionButtonWithLocation:(CGPoint)location
{
    NSUInteger count = self.emotions.count;
    for (int i = 0; i<count; i++) {
        ZMLEmotionButton *btn = self.subviews[i + 1];
        if (CGRectContainsPoint(btn.frame, location)) {
            return btn;
        }
    }
    return nil;
}

/**
 *  在这个方法中处理长按手势
 */
- (void)longPressPageView:(UILongPressGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:recognizer.view];
    // 获得手指所在的位置\所在的表情按钮
    ZMLEmotionButton *btn = [self emotionButtonWithLocation:location];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: // 手指已经不再触摸pageView
            // 移除popView
            [self.popView removeFromSuperview];
            
            // 如果手指还在表情按钮上
            if (btn) {
                // 发出通知
                [self selectEmotion:btn.emotion];
            }
            break;
            
        case UIGestureRecognizerStateBegan: // 手势开始（刚检测到长按）
        case UIGestureRecognizerStateChanged: { // 手势改变（手指的位置改变）
            [self.popView showFrom:btn];
            break;
        }
            
        default:
            break;
    }
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    NSUInteger count = emotions.count;
    for (int i = 0; i<count; i++) {
        ZMLEmotionButton *btn = [[ZMLEmotionButton alloc] init];
        [self addSubview:btn];
        
        btn.emotion = emotions[i];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 内边距(四周)
    CGFloat inset = 15;
    NSUInteger count = self.emotions.count;
    CGFloat btnW = (self.width - 2 * inset) / ZMLEmotionMaxCols;
    CGFloat btnH = (self.height - inset - 20) / ZMLEmotionMaxRows;
    for (int i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i + 1];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = inset + (i%ZMLEmotionMaxCols) * btnW;
        btn.y = inset + (i/ZMLEmotionMaxCols) * btnH;
    }
    
    UIButton *lastBtn = [self.subviews lastObject];
    
    // 删除按钮
    self.deleteButton.width = btnW;
    self.deleteButton.height = btnH;
    self.deleteButton.y = lastBtn.y;
    self.deleteButton.x = lastBtn.x + btnW;
}

/**
 *  监听删除按钮点击
 */
- (void)deleteClick
{
    !self.emotionDidDeleteBlock ?: self.emotionDidDeleteBlock();
}

/**
 *  监听表情按钮点击
 *
 *  @param btn 被点击的表情按钮
 */
- (void)btnClick:(ZMLEmotionButton *)btn
{
    // 显示popView
    [self.popView showFrom:btn];
    
    // 等会让popView自动消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    
    // 发出通知
    [self selectEmotion:btn.emotion];
}

/**
 *  选中某个表情，发出通知
 *
 *  @param emotion 被选中的表情
 */
- (void)selectEmotion:(ZMLEmotion *)emotion
{
    !self.emotionDidSelectBlock ?: self.emotionDidSelectBlock(emotion);
}

#pragma mark - 懒加载

- (ZMLEmotionPopView *)popView
{
    if (!_popView) {
        self.popView = [ZMLEmotionPopView popView];
    }
    return _popView;
}

- (UIButton *)deleteButton{
    if (_deleteButton == nil) {
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton setImage:ZMLKeyboardBundleImage(@"compose_emotion_delete_highlighted") forState:UIControlStateHighlighted];
        [deleteButton setImage:ZMLKeyboardBundleImage(@"compose_emotion_delete") forState:UIControlStateNormal];
        [self addSubview:deleteButton];
        _deleteButton = deleteButton;
    }
    return _deleteButton;
}

@end
