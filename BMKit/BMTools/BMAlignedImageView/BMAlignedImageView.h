//
//  BMAlignedImageView.h
//  BMAlignedImageViewSample
//
//  Created by DennisDeng on 2018/3/1.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BMImageViewHorizontallyAlignment)
{
    // 左
    BMImageViewHorizontallyAlignmentLeft = 0,
    // Default 中
    BMImageViewHorizontallyAlignmentCenter,
    // 右
    BMImageViewHorizontallyAlignmentRight,
};

typedef NS_ENUM(NSUInteger, BMImageViewVerticallyAlignment)
{
    // 上
    BMImageViewVerticallyAlignmentTop = 0,
    // Default 中
    BMImageViewVerticallyAlignmentCenter,
    // 下
    BMImageViewVerticallyAlignmentBottom
};

NS_ASSUME_NONNULL_BEGIN

@interface BMAlignedImageView : UIView

@property (nonatomic, strong, readonly) UIImageView *realImageView;

@property (nonatomic, assign) BMImageViewHorizontallyAlignment horizontallyAlignment;
@property (nonatomic, assign) BMImageViewVerticallyAlignment verticallyAlignment;

@property (nonatomic, assign) BOOL enableScaleUp;
@property (nonatomic, assign) BOOL enableScaleDown;

@property (nullable, nonatomic) UIImage *image;
@property (nullable, nonatomic) UIImage *highlightedImage;

@property (nonatomic, getter=isHighlighted) BOOL highlighted;

@property (nullable, nonatomic) NSArray<UIImage *> *animationImages;
@property (nullable, nonatomic) NSArray<UIImage *> *highlightedAnimationImages;

@property (nonatomic) NSTimeInterval animationDuration;
@property (nonatomic) NSInteger      animationRepeatCount;

@property (null_resettable, nonatomic) UIColor *tintColor;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

- (instancetype)initWithImage:(nullable UIImage *)image;
- (instancetype)initWithImage:(nullable UIImage *)image highlightedImage:(nullable UIImage *)highlightedImage;

@end

NS_ASSUME_NONNULL_END
