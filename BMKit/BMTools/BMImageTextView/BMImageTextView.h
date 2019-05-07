//
//  BMImageTextView.h
//  BMkit
//
//  Created by DennisDeng on 15/9/03.
//  Copyright (c) 2015年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BMImageTextViewType)
{
    BMImageTextViewType_ImageLeft,
    BMImageTextViewType_ImageRight
};

typedef NS_ENUM(NSUInteger, BMImageTextViewAccessoryArrowType)
{
    BMImageTextViewAccessoryArrowType_Hide,
    BMImageTextViewAccessoryArrowType_HideInplace,
    BMImageTextViewAccessoryArrowType_Show
};

#define BMImageTextView_DefaultTextColor    [UIColor blackColor]


NS_ASSUME_NONNULL_BEGIN

@class BMImageTextView;

typedef void (^BMImageTextViewClicked)(BMImageTextView *imageTextView);
typedef UIImage * _Nullable (^BMImageTextViewAfterSetimage)(BMImageTextView *imageTextView, UIImage * _Nullable image, CGSize imageSize);


@interface BMImageTextView : UIView

@property (assign, nonatomic) BMImageTextViewType type;

@property (copy, nonatomic, nullable) NSString *imageName;
@property (copy, nonatomic, nullable) NSString *imageUrl;
@property (copy, nonatomic, nullable) NSString *placeholderImageName;

@property (copy, nonatomic, nullable) NSString *text;
@property (copy, nonatomic, nullable) NSAttributedString *attributedText;

@property (strong, nonatomic, nullable) UIColor *textColor;
@property (strong, nonatomic, nullable) UIFont *textFont;

@property (assign, nonatomic) CGSize imageSize;
@property (assign, nonatomic) BOOL circleImage;

@property (assign, nonatomic) CGFloat imageTextGap;
@property (assign, nonatomic) CGFloat accessoryArrowGap;

@property (assign, nonatomic) CGFloat maxWidth;

@property (copy, nonatomic, nullable) BMImageTextViewClicked imageTextViewClicked;

@property (assign, nonatomic) BMImageTextViewAccessoryArrowType accessoryArrowType;
@property (assign, nonatomic) BOOL showTableCellAccessoryArrow;

@property (assign, nonatomic) BOOL adjustsFontSizeToFitWidth;

@property (copy, nonatomic, nullable) BMImageTextViewAfterSetimage afterSetimage;


- (instancetype)initWithText:(NSString *)text;
- (instancetype)initWithText:(NSString *)text height:(CGFloat)height;
- (instancetype)initWithImage:(NSString *)image height:(CGFloat)height;
- (instancetype)initWithImage:(nullable NSString *)image text:(nullable NSString *)text height:(CGFloat)height gap:(CGFloat)gap;
- (instancetype)initWithImage:(nullable NSString *)image text:(nullable NSString *)text type:(BMImageTextViewType)type height:(CGFloat)height gap:(CGFloat)gap;
- (instancetype)initWithImage:(nullable NSString *)image text:(nullable NSString *)text type:(BMImageTextViewType)type textColor:(nullable UIColor *)textColor textFont:(nullable UIFont *)textFont height:(CGFloat)height gap:(CGFloat)gap;
- (instancetype)initWithImage:(nullable NSString *)image text:(nullable NSString *)text type:(BMImageTextViewType)type textColor:(nullable UIColor *)textColor textFont:(nullable UIFont *)textFont height:(CGFloat)height gap:(CGFloat)gap clicked:(nullable BMImageTextViewClicked)clicked;

- (instancetype)initWithAttributedText:(NSAttributedString *)attributedText;
- (instancetype)initWithAttributedText:(NSAttributedString *)attributedText height:(CGFloat)height;
- (instancetype)initWithAttributedText:(nullable NSAttributedString *)attributedText image:(nullable NSString *)image;
- (instancetype)initWithAttributedText:(nullable NSAttributedString *)attributedText image:(nullable NSString *)image gap:(CGFloat)gap;
- (instancetype)initWithImage:(nullable NSString *)image attributedText:(nullable NSAttributedString *)attributedText height:(CGFloat)height gap:(CGFloat)gap;
- (instancetype)initWithImage:(nullable NSString *)image attributedText:(nullable NSAttributedString *)attributedText type:(BMImageTextViewType)type height:(CGFloat)height gap:(CGFloat)gap;
- (instancetype)initWithImage:(nullable NSString *)image attributedText:(nullable NSAttributedString *)attributedText type:(BMImageTextViewType)type height:(CGFloat)height gap:(CGFloat)gap clicked:(nullable BMImageTextViewClicked)clicked;

@end

NS_ASSUME_NONNULL_END
