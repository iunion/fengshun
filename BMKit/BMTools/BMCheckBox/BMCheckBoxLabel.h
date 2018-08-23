//
//  BMCheckBoxLabel.h
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2018/2/9.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "BMCheckBox.h"

typedef NS_ENUM(NSUInteger, BMCheckBoxLabelType)
{
    // Default 文本
    BMCheckBoxLabelType_Text,
    BMCheckBoxLabelType_Image
};

NS_ASSUME_NONNULL_BEGIN

@class BMCheckBoxLabel;
typedef void (^checkBoxLabelImageLongPress)(BMCheckBoxLabel *label);

@interface BMCheckBoxLabel : BMCheckBox

@property (nonatomic, assign, readonly) BMCheckBoxLabelType boxLabelType;

// label width
@property (nonatomic, assign, readonly) CGFloat labelWidth;

// 文本和选择框的间隔
@property (nonatomic, assign) CGFloat checkBoxGap;

// 文本
@property (nullable, nonatomic, strong) NSString *labelText;
@property (nullable, nonatomic, strong) NSAttributedString *labelCheckedAttrText;
@property (nullable, nonatomic, strong) NSAttributedString *labelUnCheckedAttrText;
@property (nullable, nonatomic, strong) NSAttributedString *labelMixedAttrText;
@property (nullable, nonatomic, readonly) NSAttributedString *labelAttrText;

// 文本对齐
@property (nonatomic, assign) NSTextAlignment labelTextAlignment;

// 文本字体
@property (nullable, nonatomic, strong) UIFont *labelTextFont;

// 文本颜色
@property (nullable, nonatomic, strong) UIColor *labelTextCheckedColor;
@property (nullable, nonatomic, strong) UIColor *labelTextUnCheckedColor;
@property (nullable, nonatomic, strong) UIColor *labelTextMixedColor;
@property (nullable, nonatomic, readonly) UIColor *labelTextColor;


// 图片
@property (nullable, nonatomic, strong) UIImage *labelImage;
@property (nullable, nonatomic, strong) UIImage *labelBigImage;

// 图片URL
@property (nullable, nonatomic, strong) NSString *labelImageUrl;
@property (nullable, nonatomic, strong) NSString *labelBigImageUrl;
@property (nullable, nonatomic, strong) UIImage *placeholderLabelImage;

@property (nullable, nonatomic, copy) checkBoxLabelImageLongPress imageLongPress;

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame checkWidth:(CGFloat)checkWidth;
- (instancetype)initWithFrame:(CGRect)frame checkWidth:(CGFloat)checkWidth useGesture:(BOOL)useGesture;

- (instancetype)initWithFrame:(CGRect)frame checkWidth:(CGFloat)checkWidth labelText:(nullable NSString *)labelText useGesture:(BOOL)useGesture;
- (instancetype)initWithFrame:(CGRect)frame checkWidth:(CGFloat)checkWidth labelText:(nullable NSString *)labelText checkBoxGap:(CGFloat)checkBoxGap useGesture:(BOOL)useGesture;

@end

NS_ASSUME_NONNULL_END

