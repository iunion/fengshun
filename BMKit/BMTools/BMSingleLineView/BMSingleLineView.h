//
//  BMSingleLineView.h
//  BMBaseKit
//
//  Created by DennisDeng on 15/9/03.
//  Copyright (c) 2015年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BMSingleLineDirection)
{
    // 水平方向
    SingleLineDirectionLandscape,
    
    // 垂直方向
    SingleLineDirectionPortait
};

@interface BMSingleLineView : UIView

// 方向
@property (nonatomic, assign) BMSingleLineDirection lineDirection;

@property (nonatomic, assign) BOOL needGap;
// 边距，最小1
@property (nonatomic, assign) CGFloat lineGap;

// 线宽度，默认为1 pixel (1.0f / [UIScreen mainScreen].scale)
@property (nonatomic, assign) CGFloat lineWidth;

// 线颜色，默认蓝色
@property (nonatomic, strong) UIColor *lineColor;

// dash线
@property (nonatomic, assign) BOOL isDash;
@property (nonatomic, assign) CGFloat lineLength;
@property (nonatomic, assign) CGFloat lineSpacing;

- (instancetype)initWithFrame:(CGRect)frame direction:(BMSingleLineDirection)direction;

@end
