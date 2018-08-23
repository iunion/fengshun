//
//  BMCheckBox.h
//  BMkit
//
//  Created by DennisDeng on 18/1/31.
//  Copyright (c) 2018年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMCheckBoxGroup.h"

#define BMCheckboxDefaultWidth 16.0f

typedef NS_ENUM(NSUInteger,BMCheckBoxState)
{
    // Default 未选中
    BMCheckBoxState_UnChecked = NO,
    // 选中
    BMCheckBoxState_Checked = YES,
    BMCheckBoxState_Mixed
};

typedef NS_ENUM(NSUInteger, BMCheckBoxType)
{
    // Default 方形
    BMCheckBoxType_Square,
    // 圆形
    BMCheckBoxType_Circle,
    // 文本
    BMCheckBoxType_Text
};

typedef NS_ENUM(NSUInteger, BMCheckBoxHorizontallyType)
{
    // Default 左
    BMCheckBoxHorizontallyType_Left = 0,
    // 右
    BMCheckBoxHorizontallyType_Right,
};

typedef NS_ENUM(NSUInteger, BMCheckBoxVerticallyType)
{
    // Default 上
    BMCheckBoxVerticallyType_Top = 0,
    // 中
    BMCheckBoxVerticallyType_Center,
    // 下
    BMCheckBoxVerticallyType_Bottom
};

NS_ASSUME_NONNULL_BEGIN

@class BMCheckBox;

typedef UIBezierPath * _Nullable (^BMCheckBoxShapeBlock)(BMCheckBox *checkBox);
typedef void (^BMCheckBoxTaped)(BMCheckBox *checkBox);

@interface BMCheckBox : UIControl

@property (nullable, nonatomic, weak, readonly) BMCheckBoxGroup *group;

#pragma mark Properties

// checkbox 状态
// Default: BMCheckBoxState_UnChecked
@property (nonatomic, assign) BMCheckBoxState checkState;

// checkbox 类型
// Default: BMCheckBoxType_Square
@property (nonatomic, assign) BMCheckBoxType boxType;

// checkbox 水平位置
// Default: BMCheckBoxHorizontallyType_Left
@property (nonatomic, assign) BMCheckBoxHorizontallyType horizontallyType;
// checkbox 垂直位置
// Default: BMCheckBoxVerticallyType_Top
@property (nonatomic, assign) BMCheckBoxVerticallyType verticallyType;

// checkbox 宽度
// 宽高相等
@property (nonatomic, assign) CGFloat checkWidth;
// checkbox frame
@property (nonatomic, assign, readonly) CGRect boxFrame;

#pragma mark Appearance

// 文本
@property (nullable, nonatomic, strong) NSString *boxText;
// 文本字体
@property (nullable, nonatomic, strong) UIFont *boxTextFont;
// 文本颜色
@property (nullable, nonatomic, strong) UIColor *boxCheckedTextColor;
@property (nullable, nonatomic, strong) UIColor *boxUnCheckedTextColor;
@property (nullable, nonatomic, readonly) UIColor *boxTextColor;

// 外框

// 外框线宽
@property (nonatomic, assign) CGFloat boxStrokeWidth;
// 外框颜色
@property (nullable, nonatomic, strong) UIColor *boxCheckedStrokeColor;
@property (nullable, nonatomic, strong) UIColor *boxUnCheckedStrokeColor;
@property (nullable, nonatomic, strong) UIColor *boxMixedStrokeColor;
@property (nullable, nonatomic, readonly) UIColor *boxStrokeColor;
// 外框是否填充
@property (nonatomic, assign) BOOL isBoxFill;
// 外框填充颜色
@property (nullable, nonatomic, strong) UIColor *boxCheckedFillColor;
@property (nullable, nonatomic, strong) UIColor *boxUnCheckedFillColor;
@property (nullable, nonatomic, strong) UIColor *boxMixedFillColor;
@property (nullable, nonatomic, readonly) UIColor *boxFillColor;

// 外框圆角半径 BMCheckBoxType_Square时可用
@property (nonatomic, assign) CGFloat boxCornerRadius;

// 外框自定义曲线
@property (nullable, nonatomic, copy) BMCheckBoxShapeBlock boxShapeBlock;

// 标记

// 标记线宽
@property (nonatomic, assign) CGFloat markStrokeWidth;
// 标记颜色
@property (nullable, nonatomic, strong) UIColor *markCheckedStrokeColor;
//@property (nullable, nonatomic, strong) UIColor *markUnCheckedStrokeColor;
@property (nullable, nonatomic, strong) UIColor *markMixedStrokeColor;
@property (nullable, nonatomic, readonly) UIColor *markStrokeColor;

// 标记自定义曲线
@property (nullable, nonatomic, copy) BMCheckBoxShapeBlock markShapeBlock;


#pragma mark Values

//// 选中时的值
//@property (nullable, nonatomic, strong) id checkedValue;
//// 未选中时的值
//@property (nullable, nonatomic, strong) id uncheckedValue;
//// 混选时的值
//@property (nullable, nonatomic, strong) id mixedValue;
//
//- (_Nullable id)value;


#pragma mark Initalization

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame checkWidth:(CGFloat)checkWidth;
- (instancetype)initWithFrame:(CGRect)frame checkWidth:(CGFloat)checkWidth useGesture:(BOOL)useGesture;

#pragma mark Actions

- (void)toggleCheckState;

- (UIBezierPath *)getDefaultBoxShape;
- (UIBezierPath *)getDefaultMarkShape;

- (void)handleTapCheckBox:(UIGestureRecognizer *)recognizer;

- (void)setCheckBoxGroup:(nullable BMCheckBoxGroup *)group;

@end

NS_ASSUME_NONNULL_END
