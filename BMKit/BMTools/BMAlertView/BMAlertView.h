//
//  BMAlertView.h
//  ODR
//
//  Created by jiang deng on 2018/7/10.
//  Copyright © 2018年 DH. All rights reserved.
//
//  || https://github.com/alexanderjarvis/PXAlertView

#import <UIKit/UIKit.h>

#define BMALERTVIEW_MAXSHOWCOUNT 5

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BMAlertViewShowAnimation)
{
    BMAlertViewShowAnimationNone,
    BMAlertViewShowAnimationFadeIn,
    BMAlertViewShowAnimationSlideInFromBottom,
    BMAlertViewShowAnimationSlideInFromTop,
    BMAlertViewShowAnimationSlideInFromLeft,
    BMAlertViewShowAnimationSlideInFromRight
};

typedef NS_ENUM(NSUInteger, BMAlertViewHideAnimation)
{
    BMAlertViewHideAnimationNone,
    BMAlertViewHideAnimationFadeOut,
    BMAlertViewHideAnimationSlideOutToBottom,
    BMAlertViewHideAnimationSlideOutToTop,
    BMAlertViewHideAnimationSlideOutToLeft,
    BMAlertViewHideAnimationSlideOutToRight
};

typedef void (^BMAlertViewCompletionBlock)(BOOL cancelled, NSInteger buttonIndex);

@interface BMAlertView : UIViewController

@property (nonatomic, assign, readonly, getter=isVisible) BOOL visible;

// 是否显示关闭按钮
@property (nonatomic, assign) BOOL showClose;

@property (nonatomic, assign) BOOL shouldDismissOnTapOutside;
@property (nonatomic, assign) BOOL notDismissOnCancel;

@property (nonatomic, strong, readonly) UIVisualEffectView *alertMarkBgEffectView;
@property (nullable, nonatomic, strong) UIVisualEffect *alertMarkBgEffect;
@property (nonatomic, strong) UIColor *alertMarkBgColor;
@property (nonatomic, strong) UIColor *alertBgColor;

@property (nullable, nonatomic, strong) NSString *iconName;

@property (nonatomic, strong) UIColor *alertTitleColor;
@property (nonatomic, strong) UIFont *alertTitleFont;
@property (nullable, nonatomic, strong) NSString *alertTitle;

@property (nonatomic, strong) UIColor *alertMessageColor;
@property (nonatomic, strong) UIFont *alertMessageFont;
@property (nullable, nonatomic, strong) NSString *alertMessage;

@property (nullable, nonatomic, strong) NSMutableAttributedString *alertTitleAttrStr;
@property (nullable, nonatomic, strong) NSMutableAttributedString *alertMessageAttrStr;

@property (nonatomic, strong) UIColor *alertGapLineColor;

@property (nonatomic, strong) UIColor *cancleBtnBgColor;
@property (nonatomic, strong) UIColor *otherBtnBgColor;
@property (nonatomic, strong) UIColor *cancleBtnTextColor;
@property (nonatomic, strong) UIColor *otherBtnTextColor;
@property (nonatomic, strong) UIFont *btnFont;

@property (nonatomic, assign) BMAlertViewShowAnimation showAnimationType;
@property (nonatomic, assign) BMAlertViewHideAnimation hideAnimationType;

@property (nullable, nonatomic, copy) BMAlertViewCompletionBlock completion;

@property (nonatomic, assign) CGFloat buttonHeight;


+ (instancetype)showAlertWithTitle:(nullable id)title;

+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message;

+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message
                        completion:(nullable BMAlertViewCompletionBlock)completion;

+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message
                       cancelTitle:(nullable NSString *)cancelTitle
                        completion:(nullable BMAlertViewCompletionBlock)completion;

+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message
                       cancelTitle:(nullable NSString *)cancelTitle
                        otherTitle:(nullable NSString *)otherTitle
                        completion:(nullable BMAlertViewCompletionBlock)completion;
+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message
                       cancelTitle:(nullable NSString *)cancelTitle
                        otherTitle:(nullable NSString *)otherTitle
                buttonsShouldStack:(BOOL)shouldStack
                        completion:(nullable BMAlertViewCompletionBlock)completion;

+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message
                       cancelTitle:(nullable NSString *)cancelTitle
                       otherTitles:(nullable NSArray<NSString *> *)otherTitles
                        completion:(nullable BMAlertViewCompletionBlock)completion;

+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message
                       contentView:(nullable UIView *)contentView
                       cancelTitle:(nullable NSString *)cancelTitle
                        otherTitle:(nullable NSString *)otherTitle
                        completion:(nullable BMAlertViewCompletionBlock)completion;
+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message
                       contentView:(nullable UIView *)contentView
                       cancelTitle:(nullable NSString *)cancelTitle
                        otherTitle:(nullable NSString *)otherTitle
                buttonsShouldStack:(BOOL)shouldStack
                        completion:(nullable BMAlertViewCompletionBlock)completion;

+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message
                       contentView:(nullable UIView *)contentView
                       cancelTitle:(nullable NSString *)cancelTitle
                       otherTitles:(nullable NSArray<NSString *> *)otherTitles
                        completion:(nullable BMAlertViewCompletionBlock)completion;
+ (instancetype)showAlertWithTitle:(nullable id)title
                           message:(nullable id)message
                       contentView:(nullable UIView *)contentView
                       cancelTitle:(nullable NSString *)cancelTitle
                       otherTitles:(nullable NSArray<NSString *> *)otherTitles
                buttonsShouldStack:(BOOL)shouldStack
                        completion:(nullable BMAlertViewCompletionBlock)completion;

+ (instancetype)alertWithTitle:(nullable id)title
                       message:(nullable id)message
                   contentView:(nullable UIView *)contentView
                   cancelTitle:(nullable NSString *)cancelTitle
                   otherTitles:(nullable NSArray<NSString *> *)otherTitles
            buttonsShouldStack:(BOOL)shouldStack
                    completion:(nullable BMAlertViewCompletionBlock)completion;

- (instancetype)initWithIcon:(nullable NSString *)iconName
                       title:(nullable id)title
                     message:(nullable id)message
                 contentView:(nullable UIView *)contentView
                 cancelTitle:(nullable NSString *)cancelTitle
                 otherTitles:(nullable NSArray<NSString *> *)otherTitles
          buttonsShouldStack:(BOOL)shouldStack
                  completion:(nullable BMAlertViewCompletionBlock)completion;

- (UIButton *)getButtonAtIndex:(NSUInteger)index;

- (void)showAlertView;

- (void)dismiss;
- (void)dismissWithIndex:(NSInteger)index animated:(BOOL)animated;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@end

@interface BMAlertViewStack : NSObject

+ (BMAlertViewStack *)sharedInstance;

- (void)closeAllAlertViews;

- (void)closeAlertView:(BMAlertView *)alertView;
- (void)closeAlertView:(BMAlertView *)alertView animated:(BOOL)animated;

- (void)closeAlertView:(BMAlertView *)alertView dismissWithIndex:(NSInteger)index animated:(BOOL)animated;

- (NSUInteger)getAlertViewCount;

@end

NS_ASSUME_NONNULL_END
