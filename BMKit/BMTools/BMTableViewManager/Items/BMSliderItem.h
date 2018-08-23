//
//  BMSliderItem.h
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2018/3/19.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "BMTableViewItem.h"

NS_ASSUME_NONNULL_BEGIN

@class BMSliderItem;
typedef void (^sliderValueChangeHandler)(BMSliderItem *item);

@interface BMSliderItem : BMTableViewItem

// sliderValue： 0.0~1.0f
@property(nonatomic, assign) CGFloat sliderValue;
@property(nonatomic, assign) BOOL sliderable;
@property (nonatomic, assign) CGFloat sliderWidth;

@property (nonatomic, copy) sliderValueChangeHandler valueChangeHandler;

+ (instancetype)itemWithTitle:(nullable NSString *)title value:(CGFloat)value;
+ (instancetype)itemWithTitle:(nullable NSString *)title value:(CGFloat)value sliderValueChangeHandler:(nullable sliderValueChangeHandler)valueChangeHandler;

- (instancetype)initWithTitle:(nullable NSString *)title value:(CGFloat)value;
- (instancetype)initWithTitle:(nullable NSString *)title value:(CGFloat)value sliderValueChangeHandler:(nullable sliderValueChangeHandler)valueChangeHandler;

@end

NS_ASSUME_NONNULL_END
