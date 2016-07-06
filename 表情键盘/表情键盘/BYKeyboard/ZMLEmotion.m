//
//  ViewController.m
//  自定义键盘
//
//  Created by 张马亮 on 16/7/1.
//  Copyright © 2016年 Apress. All rights reserved.
//  emoji表情模型，以及emoji专用按钮

#import "ZMLEmotion.h"
#import "NSString+ZMLEmoji.h"
#import "ZMLKeyboardConst.h"

@implementation ZMLEmotion

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end

@implementation ZMLEmotionButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.titleLabel.font = [UIFont systemFontOfSize:32];
    self.adjustsImageWhenHighlighted = NO;
}

- (void)setEmotion:(ZMLEmotion *)emotion
{
    _emotion = emotion;
    
    if (emotion.png) { // 有图片
        [self setImage:ZMLKeyboardBundleImage(emotion.png) forState:UIControlStateNormal];
    } else if (emotion.code) { // 是emoji表情
        // 设置emoji
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
    }
}
@end