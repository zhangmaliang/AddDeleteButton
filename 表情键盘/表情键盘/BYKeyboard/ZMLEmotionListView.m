//
//  ViewController.m
//  自定义键盘
//
//  Created by 张马亮 on 16/7/1.
//  Copyright © 2016年 Apress. All rights reserved.
//  表情键盘顶部的内容:scrollView + pageControl

#import "ZMLEmotionListView.h"
#import "ZMLEmotionPageView.h"
#import "UIView+ZMLFrame.h"
#import "ZMLKeyboardConst.h"

@interface ZMLEmotionListView() <UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
// 发送按钮
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) NSArray<ZMLEmotion *> *emotions;

// 点击了表情中的删除按钮回调
@property (nonatomic, copy) void (^emotionDidDeleteBlock)();
// 点击了表情中的发送按钮回调
@property (nonatomic, copy) void (^emotionDidSendBlock)();
// 点击了表情中的某一个表情回调
@property (nonatomic, copy) void (^emotionDidSelectBlock)(ZMLEmotion *emotion);


@end

@implementation ZMLEmotionListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.hidesForSinglePage = YES;
        pageControl.userInteractionEnabled = NO;
        pageControl.currentPageIndicatorTintColor = ZMLRGB(66, 66, 66);
        pageControl.pageIndicatorTintColor = ZMLRGB(150, 150, 150);
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}

- (void)setEmotions:(NSArray<ZMLEmotion *> *)emotions deleteBlock:(void (^)())deleteBlock sendBlock:(void (^)())sendBlock selectBlock:(void (^)(ZMLEmotion *emotion))selectBlock{
    
    self.emotionDidDeleteBlock = deleteBlock;
    self.emotionDidSelectBlock = selectBlock;
    self.emotionDidSendBlock = sendBlock;
    self.emotions = emotions;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger count = (emotions.count + ZMLEmotionPageSize - 1) / ZMLEmotionPageSize;
    
    self.pageControl.numberOfPages = count;
    
    for (int i = 0; i<count; i++) {
        ZMLEmotionPageView *pageView = [[ZMLEmotionPageView alloc] init];
        
        pageView.emotionDidDeleteBlock = self.emotionDidDeleteBlock;
        pageView.emotionDidSelectBlock = self.emotionDidSelectBlock;

        NSRange range;
        range.location = i * ZMLEmotionPageSize;
        // left：剩余的表情个数（可以截取的）
        NSUInteger left = emotions.count - range.location;
        if (left >= ZMLEmotionPageSize) { // 这一页足够20个
            range.length = ZMLEmotionPageSize;
        } else {
            range.length = left;
        }

        pageView.emotions = [emotions subarrayWithRange:range];
        [self.scrollView addSubview:pageView];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    self.scrollView.x = self.scrollView.y = 0;
    
    NSUInteger count = self.scrollView.subviews.count;
    for (int i = 0; i<count; i++) {
        ZMLEmotionPageView *pageView = self.scrollView.subviews[i];
        pageView.height = self.scrollView.height;
        pageView.width = self.scrollView.width;
        pageView.x = pageView.width * i;
        pageView.y = 0;
    }
    
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.width, 0);
    
    // 发送按钮
    self.sendButton.size = self.sendButton.currentImage.size;
    self.sendButton.x = self.width - self.sendButton.width;
    self.sendButton.y = self.height - self.sendButton.height;
    
    self.pageControl.width = self.width;
    self.pageControl.height = 25;
    self.pageControl.x = 0;
    self.pageControl.centerY = self.sendButton.centerY;
}

/**
 *  监听发送按钮点击
 */
- (void)sendButtonClick{
    !self.emotionDidSendBlock ?: self.emotionDidSendBlock();
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double pageNo = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(pageNo + 0.5);
}

- (UIButton *)sendButton{
    if (_sendButton == nil) {
        _sendButton = [[UIButton alloc] init];
        [_sendButton setImage:ZMLKeyboardBundleImage(@"btn_comment_expression_send") forState:UIControlStateNormal];
        [self addSubview:_sendButton];
        [_sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

@end
