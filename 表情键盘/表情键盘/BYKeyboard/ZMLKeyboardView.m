//
//  ZMLKeyboardView.h
//  自定义键盘
//
//  Created by 张马亮 on 16/7/1.
//  Copyright © 2016年 Apress. All rights reserved.
//  带表情键盘的自定义输入框视图

#import "ZMLKeyboardView.h"
#import "UIView+ZMLFrame.h"
#import "ZMLEmotionListView.h"
#import "ZMLEmotion.h"
#import "NSString+ZMLEmoji.h"
#import "ZMLKeyboardConst.h"
#import "ZMLPlaceholderTextView.h"

@interface ZMLKeyboardView()

@property (nonatomic, strong) ZMLPlaceholderTextView *inputView;  // 输入文本
@property (nonatomic, strong) UIView *topLine;      // 顶部分割线
@property (nonatomic, strong) UIView *bottomLine;      // 底部分割线
@property (nonatomic, strong) UIButton *faceBtn;      // 切换表情键盘安妮
@property (nonatomic, assign) CGFloat textHeight;     // 文本框中文字高度
@property (nonatomic, strong) ZMLEmotionListView *faceView;  // 表情键盘视图
/***  点击键盘上的发送按钮回调*/
@property (nonatomic, copy) void (^didSendTextBlock)(NSString *text);

@property (nonatomic, assign) BOOL  isFirstLayout;  // 是否是首次布局
@property (nonatomic, assign) CGFloat containerHeight;  // 容器视图高度

@end

@implementation ZMLKeyboardView

#pragma mark - 外界接口方法

+ (instancetype)showKeyboardViewWithContainerHeight:(CGFloat)height sendTextBlock:(void (^)(NSString *))sendTextBlock{
    
    ZMLKeyboardView *view = [[ZMLKeyboardView alloc] init];
    view.containerHeight = height;
    view.backgroundColor = ZMLRGB(247, 248, 250);
    view.frame = CGRectMake(0, height - kKeyboardViewHeight, kScreenWidth, kKeyboardViewHeight);
    view.didSendTextBlock = sendTextBlock;
    return view;
}

- (void)setInputViewText:(NSString *)text{
    self.inputView.text = text;
}

- (void)setInputViewPlaceholderText:(NSString *)text{
    self.inputView.text = nil;
    self.inputView.placeholder = text;
}

- (void)becomeFirstResponder{
    [self.inputView becomeFirstResponder];
    self.hidden = NO;
}

- (void)resignFirstResponder{
    [self.inputView resignFirstResponder];
}

#pragma mark - 初始化视图
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.isFirstLayout = YES;

    __weak typeof(self) weakSelf = self;
  
    [self.faceView setEmotions:[self loadEmojiEmotions] deleteBlock:^{
        // 表情键盘删除
        [weakSelf emotionDidDelete];
    } sendBlock:^{
        // 表情键盘发送
        [weakSelf emotionDidSend];
    } selectBlock:^(ZMLEmotion *emotion){
        // 表情键盘选中
        [weakSelf emotionDidSelect:emotion];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self.inputView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.width = kScreenWidth;
    
    CGFloat height = self.textHeight  + 35 > kKeyboardViewHeight ? self.textHeight + 35 : kKeyboardViewHeight;
    
    CGFloat offsetY = self.height - height;
    CGFloat animateTime = self.isFirstLayout ? 0 : 0.25;
    
    [UIView animateWithDuration:animateTime animations:^{
        self.y += offsetY;
        self.height = height;
    }];
    
    CGFloat faceBtnWH = self.faceBtn.currentImage.size.width;
    
    self.faceBtn.width = faceBtnWH;
    self.faceBtn.height = faceBtnWH;
    self.faceBtn.x = self.width - faceBtnWH - 15;
    
    self.inputView.width = self.width - faceBtnWH - 3 * 15;
    self.inputView.x = 15;
    
    // 下面动画中的代码不能放到上面动画中，若如此则会有细微bug
    [UIView animateWithDuration:animateTime animations:^{
        self.faceBtn.y = self.height - faceBtnWH - 10;
        self.inputView.height = self.height - 2 * 7;
        self.inputView.centerY = self.height * 0.5;
        self.bottomLine.y = self.height - self.bottomLine.height;
    }];
    
    self.topLine.width = self.width;
    self.bottomLine.width = self.width;
    
    self.isFirstLayout = NO;
}

#pragma mark - 交互事件

/**
 *  表情按钮被点击,切换表情键盘
 */
- (void)faceBtnClicked:(UIButton *)faceBtn{
    faceBtn.selected = !faceBtn.isSelected;
    
    self.bottomLine.hidden = !faceBtn.selected;
    
    [self.inputView resignFirstResponder];
    self.inputView.inputView = faceBtn.selected ? self.faceView : nil;
    [self.inputView becomeFirstResponder];
}

/**
 *  选中了表情键盘中的某一个表情回调
 */
- (void)emotionDidSelect:(ZMLEmotion *)emotion{
    
    self.inputView.text = [self.inputView.text stringByAppendingString:emotion.code.emoji];
    
    [self textDidChange];
}

/**
 *  点击了表情键盘中的删除按钮回调
 */
- (void)emotionDidDelete{
    
    [self.inputView deleteBackward];
}

/**
 *  点击了表情键盘中的发送按钮回调
 */
- (void)emotionDidSend{
    
    NSString *text = [self.inputView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    !self.didSendTextBlock ?: self.didSendTextBlock(text);
    
    self.inputView.text = nil;

    [self textDidChange];
}

/**
 *  输入框内容变化回调
 */
- (void)textDidChange{
    
    // 用户按了回车按钮
    if ([self.inputView.text containsString:@"\n"]) {
        [self emotionDidSend];
    }
    
    // 宽度计算时，需要额外除去textView本身自带的8个点的宽度
    CGFloat margin = self.inputView.textContainerInset.left + self.inputView.textContainerInset.right + 8;
    
    CGFloat height = [self.inputView.text boundingRectWithSize:CGSizeMake(self.inputView.width - margin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.inputView.font} context:nil].size.height;
    
    if (height == self.textHeight) return;
    
    // 确保输入框不会无限增高，控制在显示4行
    if (height > 60) {
        return;
    }
    
    self.textHeight = height;
    
    // 此时文本框内容高度跟上一次文本框内容高度不一样，意味着文本框有换行操作，重新布局
    [self setNeedsLayout];
}

/**
 *  键盘出现/隐藏回调
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notif{
    
    
    CGRect keyboardEndFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 普通文本键盘与表情键盘切换时，过滤
    BOOL isFaceKeyboard = !self.faceBtn.selected && keyboardEndFrame.size.height == kFaceViewHeight;
    BOOL isNormalKeyboard = self.faceBtn.selected && keyboardEndFrame.size.height != kFaceViewHeight;
    if (isFaceKeyboard || isNormalKeyboard) {
        return;
    }
    
    CGFloat keyboardHeight = keyboardEndFrame.size.height;
    
    BOOL isHidden = kScreenHeight == keyboardEndFrame.origin.y;
    
    !self.keyboardAppearAndDismiss ?: self.keyboardAppearAndDismiss(!isHidden);
    
    CGFloat targetY = isHidden ? self.containerHeight - self.height : self.containerHeight - self.height - keyboardHeight;
 
    CGFloat originY = self.y;
    
    CGFloat animationTime = (self.y - originY) / kFaceViewHeight * 0.25;
    
    animationTime = animationTime > 0 ? animationTime : -animationTime;
    
    [UIView animateWithDuration:animationTime animations:^{
        self.y = targetY;
    }];
}

#pragma mark - 加载表情包

/**
 *  加载emoji表情包
 */
- (NSArray <ZMLEmotion *>*)loadEmojiEmotions{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Resourse.bundle/emoji.plist" ofType:nil];
    
    NSArray *emotions = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *emotionsMul = @[].mutableCopy;
    for (NSDictionary *dic in emotions) {
        ZMLEmotion *emotion = [[ZMLEmotion alloc] init];
        [emotion setValuesForKeysWithDictionary:dic];
        [emotionsMul addObject:emotion];
    }
    return emotionsMul.copy;
}

#pragma mark - 懒加载

- (ZMLEmotionListView *)faceView{
    if (_faceView == nil) {
        ZMLEmotionListView *view = [ZMLEmotionListView new];
        view.backgroundColor = ZMLRGB(245, 245, 245);
        view.frame = CGRectMake(0, 0, kScreenWidth, kFaceViewHeight);
        _faceView = view;
    }
    return _faceView;
}

- (UIButton *)faceBtn{
    if (_faceBtn == nil) {
        UIButton *faceBtn = [[UIButton alloc] init];
        [faceBtn setImage:ZMLKeyboardBundleImage(@"iocn_comment_expression") forState:UIControlStateNormal];
        [faceBtn setImage:ZMLKeyboardBundleImage(@"iocn_comment_keyboard") forState:UIControlStateSelected];
        [self addSubview:faceBtn];
        [faceBtn addTarget:self action:@selector(faceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _faceBtn = faceBtn;
    }
    return _faceBtn;
}

- (ZMLPlaceholderTextView *)inputView{
    if (_inputView == nil) {
        ZMLPlaceholderTextView *inputView = [[ZMLPlaceholderTextView alloc] init];
        inputView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
        inputView.layer.cornerRadius = 4;
        inputView.layer.masksToBounds = YES;
        inputView.layer.borderWidth = 1;
        inputView.layer.borderColor = ZMLRGB(221, 221, 221).CGColor;
        inputView.font = [UIFont systemFontOfSize:14];
        inputView.textColor = ZMLRGB(102, 102, 102);
        inputView.tintColor = inputView.textColor;
        inputView.enablesReturnKeyAutomatically = YES;
        inputView.returnKeyType = UIReturnKeySend;
        inputView.placeholderColor = ZMLRGB(150, 150, 150);
        [self addSubview:inputView];
        _inputView = inputView;
    }
    return _inputView;
}

- (UIView *)topLine{
    if (_topLine == nil) {
        _topLine = [[UIView alloc] init];
        _topLine.height = 0.5;
        _topLine.backgroundColor = ZMLRGB(214, 214, 214);
        [self addSubview:_topLine];
    }
    return _topLine;
}

- (UIView *)bottomLine{
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.height = 0.5;
        _bottomLine.backgroundColor = ZMLRGB(160, 160, 160);
        _bottomLine.hidden = YES;
        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

@end
