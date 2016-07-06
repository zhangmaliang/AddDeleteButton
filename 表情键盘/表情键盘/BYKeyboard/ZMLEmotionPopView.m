//
//  ViewController.m
//  自定义键盘
//
//  Created by 张马亮 on 16/7/1.
//  Copyright © 2016年 Apress. All rights reserved.
//  表情点击后的泡泡泡泡

#import "ZMLEmotionPopView.h"
#import "ZMLEmotion.h"
#import "UIView+ZMLFrame.h"
#import "ZMLKeyboardConst.h"

@interface ZMLEmotionPopView()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet ZMLEmotionButton *emotionButton;
@end

@implementation ZMLEmotionPopView

- (void)awakeFromNib{

    self.bgImageView.image = ZMLKeyboardBundleImage(@"emoticon_keyboard_magnifier");
}

+ (instancetype)popView
{
    if (!kOpenPopView) {
        return nil;
    }
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)showFrom:(ZMLEmotionButton *)button
{
    if (button == nil) return;
    
    // 给popView传递数据
    self.emotionButton.emotion = button.emotion;
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    // 计算出被点击的按钮在window中的frame
    CGRect btnFrame = [button convertRect:button.bounds toView:nil];
    self.y = CGRectGetMidY(btnFrame) - self.height; // 100
    self.centerX = CGRectGetMidX(btnFrame);
}

@end
