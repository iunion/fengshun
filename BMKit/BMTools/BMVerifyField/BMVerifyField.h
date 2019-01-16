//
//  BMVerifyField.h
//  fengshun
//
//  Created by jiang deng on 2018/8/28.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BMVerifyFieldStyle)
{
    // 矩形
    BMVerifyFieldStyle_Border,
    // 下划线
    BMVerifyFieldStyle_Underline
};

typedef NS_ENUM(NSUInteger, BMVerifyFieldSecureStyle)
{
    // 圆点
    BMVerifyFieldSecureStyle_Dot,
    // 字符
    BMVerifyFieldSecureStyle_Symbol,
    // 图片
    BMVerifyFieldSecureStyle_Image
};

@protocol BMVerifyFieldDelegate;

@interface BMVerifyField : UIControl <UIKeyInput>

@property (nullable, nonatomic, weak) id <BMVerifyFieldDelegate> delegate;

@property (nonatomic, assign) BMVerifyFieldStyle style;

// 输入的字符串
@property (nullable, nonatomic, strong, readonly) NSString *text;

// 输入最大个数限制
@property (nonatomic, assign, readonly) NSUInteger inputMaxCount;

// 当输入完成后，是否需要自动取消响应，默认: YES
@property (nonatomic, assign) BOOL autoResignFirstResponderWhenInputFinished;

#pragma mark - UI

// 保持正方形区域，默认: YES
@property (nonatomic, assign) BOOL squareBorder;

// 输入框间距
@property (nonatomic, assign) CGFloat itemSpace;

// 设置边框圆角，默认: 4
@property (nonatomic, assign) CGFloat borderRadius;
// 设置边框宽度，默认: 1
@property (nonatomic, assign) CGFloat borderWidth;
// 设置边框颜色，默认: [UIColor lightGrayColor]
@property (nonatomic, strong) UIColor *borderColor;
// 设置已输入边框颜色，默认: [UIColor orangeColor]
@property (nonatomic, strong) UIColor *trackBorderColor;

// 设置文本字体
@property (nonatomic, strong) UIFont *textFont;
// 设置文本颜色，默认为黑色。
@property (nonatomic, strong) UIColor *textColor;

// 光标颜色
@property (nullable, nonatomic, strong) UIColor *cursorColor;


@property (nonatomic, assign) BMVerifyFieldSecureStyle secureStyle;
@property (nullable, nonatomic, strong) NSString *secureSymbol;
@property (nullable, nonatomic, strong) UIImage *secureImage;

- (instancetype)initWithInputCount:(NSUInteger)count;

- (void)setFieldInputView:(__kindof UIView *)inputView;
- (void)setFieldInputAccessoryView:(__kindof UIView *)inputAccessoryView;

- (void)clear;

@end

@protocol BMVerifyFieldDelegate <NSObject>

@optional

- (BOOL)verifyField:(BMVerifyField *)verifyField shouldChangeCharacterAtIndex:(NSUInteger)index replacementString:(NSString *)string;

- (BOOL)verifyFieldInputFinished:(BMVerifyField *)verifyField;

@end

NS_ASSUME_NONNULL_END

