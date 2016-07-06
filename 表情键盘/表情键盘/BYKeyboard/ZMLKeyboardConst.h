//
//  ZMLKeyboardConst.h
//  日日日
//
//  Created by 张马亮 on 16/7/1.
//  Copyright © 2016年 Apress. All rights reserved.
//

#ifndef ZMLKeyboardConst_h
#define ZMLKeyboardConst_h

#define kOpenPopView 1   // 是否开启气泡提示

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kFaceViewHeight 216  // 表情键盘高度
#define kKeyboardViewHeight 50  // 默认键盘输入视图高度

// 表情视图一页中最多4行
#define ZMLEmotionMaxRows 3
// 表情视图一行中最多8列
#define ZMLEmotionMaxCols 7
// 表情视图每一页的表情个数
#define ZMLEmotionPageSize ((ZMLEmotionMaxRows * ZMLEmotionMaxCols) - 1)


// 从Resourse.bundle中取出图片
#define ZMLKeyboardBundleImage(name) [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",@"Resourse.bundle/images/",name]]
#define ZMLRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#endif /* ZMLKeyboardConst_h */
