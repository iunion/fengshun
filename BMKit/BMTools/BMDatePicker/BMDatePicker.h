//
//  BMDatePicker.h
//  BMDatePicker
//
//  Created by DennisDeng on 2017/8/24.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BMPickerStyle)
{
    PickerStyle_YearMonthDayHourMinute  = 0,    // 年月日时分
    PickerStyle_MonthDayHourMinute,             // 月日时分
    PickerStyle_Year,                           // 年
    PickerStyle_YearMonthDay,                   // 年月日
    PickerStyle_MonthDayYear,                   // 月日年
    PickerStyle_MonthDay,                       // 月日
    PickerStyle_HourMinute,                     // 时分(24)
    PickerStyle_Sex                             // 性别
};

//typedef void(^BMDatePickerDoneBlock)(NSDate * _Nonnull date, BOOL isDone);
typedef void(^BMDatePickerDoneBlock)(id _Nonnull date, BOOL isDone);

NS_ASSUME_NONNULL_BEGIN

@interface BMDatePicker : UIView

// 类型
@property (nonatomic, assign) BMPickerStyle pickerStyle;

// 格式化
@property (nonatomic, assign) BOOL showFormateLabel;
// 文本颜色
@property (nullable, nonatomic, strong) UIColor *formateColor;
// 显示时间格式
@property (nullable, nonatomic, strong) NSString *formate;

// 年份
@property (nonatomic, assign) BOOL showYearLabel;
// 文本颜色
@property (nullable, nonatomic, strong) UIColor *yearColor;

// 滚轮
// 年-月-日-时-分 分栏文字颜色
@property (nullable, nonatomic, strong) UIColor *pickerLabelColor;
// 分栏文字
@property (nullable, nonatomic, strong) NSArray *pickerLabelTitleArray;
// 滚轮日期颜色
@property (nullable, nonatomic, strong) UIColor *pickerItemColor;
// 滚轮当前日期颜色
@property (nullable, nonatomic, strong) UIColor *pickerCurrentItemColor;

// 显示中文月份 一月，二月
@property (nonatomic, assign) BOOL showChineseMonth;


// 确定按钮
@property (nonatomic, assign) BOOL showDoneBtn;
// 确定按钮背景颜色
@property (nullable, nonatomic, strong) UIColor *doneBtnBgColor;
// 确定按钮文本颜色
@property (nullable, nonatomic, strong) UIColor *doneBtnTextColor;

// 滚动最大时间限制（默认2099）
@property (nonatomic, strong) NSDate *maxLimitDate;
// 滚动最小时间限制（默认0）
@property (nonatomic, strong) NSDate *minLimitDate;

@property (nullable, nonatomic, strong, readonly) NSDate *pickerDate;
@property (nullable, nonatomic, strong, readonly) NSString *formatDate;

@property (nullable, nonatomic, strong, readonly) NSString *pickerSex;

@property (nullable, nonatomic, copy) BMDatePickerDoneBlock completeBlock;

// 默认滚动到当前时间
- (instancetype)initWithPickerStyle:(BMPickerStyle)pickerStyle completeBlock:(nullable BMDatePickerDoneBlock)completeBlock;

// 滚动到指定的日期
- (instancetype)initWithPickerStyle:(BMPickerStyle)pickerStyle scrollToDate:(nullable NSDate *)scrollToDate completeBlock:(nullable BMDatePickerDoneBlock)completeBlock;
// 滚动到指定的性别
- (instancetype)initWithPickerSex:(nullable NSString *)sex completeBlock:(BMDatePickerDoneBlock)completeBlock;

// 滚动到指定的时间位置
- (void)scrollToDate:(nullable NSDate *)date animated:(BOOL)animated;

// 滚动到指定的性别位置
- (void)scrollToSex:(nullable NSString *)sex animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END


