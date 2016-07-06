//
//  ViewController.m
//  表情键盘
//
//  Created by 张马亮 on 16/7/5.
//  Copyright © 2016年 Apress. All rights reserved.
//

#import "ViewController.h"
#import "ZMLKeyboardView.h"

/**************************专属cell************************************/
@interface TestCell : UITableViewCell
@property (nonatomic, copy) NSString *content;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,assign) CGFloat cellHeight;
@end

@implementation TestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.textView = [[UITextView alloc] init];
        [self addSubview:self.textView];
        self.textView.font = [UIFont systemFontOfSize:17];
        self.textView.scrollEnabled = NO;
        self.textView.editable = NO;
    }
    return self;
}

- (void)setContent:(NSString *)content{
    _content = content;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:[self createImageAttatchment]];
    
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:content]];
    
    // 注意：占位符不能用数字
    NSAttributedString *placeholderAttr = [[NSAttributedString alloc] initWithString:@"EEE" attributes:@{NSForegroundColorAttributeName : [UIColor clearColor]}];
    
    [attr appendAttributedString:placeholderAttr];
    self.textView.attributedText = attr;

    // 计算textView文本时，计算宽度需要比textView本身的宽度减少8
    CGFloat height = [attr boundingRectWithSize:CGSizeMake(200 - 8, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    
    // textView高度必须比文字高度多2 * 8 的额外高度
    self.cellHeight = height + 16;
    
    self.textView.frame = CGRectMake(0, 0, 200, self.cellHeight);
    
    self.textView.selectedRange = NSMakeRange(self.textView.text.length - 2, 2);
    
    NSArray *rects = [self.textView selectionRectsForRange:self.textView.selectedTextRange];

    for (UITextSelectionRect *textRect in rects) {

        CGRect frame = textRect.rect;
        
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        
        [button addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [button setImage:[UIImage imageNamed:@"icon_post_details_return_delete"] forState:UIControlStateNormal];
        
        [self.textView addSubview:button];
    }
}

- (void)deleteButtonClicked{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"点击了删除按钮" delegate:nil cancelButtonTitle:@"" otherButtonTitles:@"确定", nil];
    [alert show];
}


/**
 *  创建“楼主”标记附件，用于将图片嵌在属性字符串中
 */
- (NSMutableAttributedString *)createImageAttatchment{
    
    UIImage *image = [UIImage imageNamed:@"icon_post_details_return_original_poster"];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    
    attachment.image = image;
    
    // 调整附件对象y值，对齐
    attachment.bounds = CGRectMake(0, -2, image.size.width, image.size.height);
    
    NSAttributedString *attatchAttri =[NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] init];
    
    [attri appendAttributedString:attatchAttri];
    
    return attri;
}

@end


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) ZMLKeyboardView *keyboardView ; // 表情键盘

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.array = @[].mutableCopy;
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    __weak typeof(self) weakSelf = self;
    ZMLKeyboardView *keyboardView = [ZMLKeyboardView showKeyboardViewWithContainerHeight:self.view.frame.size.height sendTextBlock:^(NSString *text) {
        
        [weakSelf.keyboardView resignFirstResponder];
        
        [weakSelf.array addObject:text];
        
        [weakSelf.tableView reloadData];
        
        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:weakSelf.array.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }];
    
    self.keyboardView =  keyboardView;

    [self.view addSubview:keyboardView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[TestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (!cell.cellHeight) {
        cell.content = self.array[indexPath.row];;
    }
    
    return cell.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[TestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.content = self.array[indexPath.row];
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.keyboardView resignFirstResponder];
}

@end
