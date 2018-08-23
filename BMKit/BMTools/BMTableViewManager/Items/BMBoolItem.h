//
//  BMBoolItem.h
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2018/1/11.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "BMTableViewItem.h"

NS_ASSUME_NONNULL_BEGIN

@class BMBoolItem;
typedef void (^switchValueChangeHandler)(BMBoolItem *item);

@interface BMBoolItem : BMTableViewItem

@property (nonatomic, assign) BOOL value;
@property (nullable, nonatomic, copy) switchValueChangeHandler valueChangeHandler;

@property (nonatomic, assign) BOOL switchable;

+ (instancetype)itemWithTitle:(nullable NSString *)title value:(BOOL)value;
+ (instancetype)itemWithTitle:(nullable NSString *)title value:(BOOL)value switchValueChangeHandler:(nullable switchValueChangeHandler)valueChangeHandler;

- (instancetype)initWithTitle:(nullable NSString *)title value:(BOOL)value;
- (instancetype)initWithTitle:(nullable NSString *)title value:(BOOL)value switchValueChangeHandler:(nullable switchValueChangeHandler)valueChangeHandler;

@end

NS_ASSUME_NONNULL_END
