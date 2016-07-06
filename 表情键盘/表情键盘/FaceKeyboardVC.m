//
//  FaceKeyboardVC.m
//  表情键盘
//
//  Created by 张马亮 on 16/7/5.
//  Copyright © 2016年 Apress. All rights reserved.
//

#import "FaceKeyboardVC.h"
#import "ZMLKeyboardView.h"

@interface FaceKeyboardVC ()

@property (nonatomic, strong) ZMLKeyboardView *keyboardView ;

@end

@implementation FaceKeyboardVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];
    
    ZMLKeyboardView *keyboardView = [ZMLKeyboardView showKeyboardViewWithContainerHeight:self.view.frame.size.height sendTextBlock:^(NSString *text) {
       
        NSLog(@"%@",text);
        
    }];
    
    if (!self.flag) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view addSubview:keyboardView];
        });
        
    }else{
        
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor redColor];
        [button setTintColor:[UIColor whiteColor]];
        [button setTitle:@"点我呀" forState:UIControlStateNormal];
        button.frame = CGRectMake(100, 100, 100, 100);
        [self.view addSubview:button];
        [button addTarget:self action:@selector(clickedButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.keyboardView = keyboardView;
}

- (void)clickedButton{
    [self.view addSubview:self.keyboardView];
    [self.keyboardView becomeFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.keyboardView resignFirstResponder];
    
    if (self.flag) {
        
        [self.keyboardView removeFromSuperview];
    }
}

@end
