//
//  BMPickerItem.h
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2018/1/15.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "BMTableViewItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMPickerItem : BMTableViewItem

@property (nonatomic, strong) NSArray *components;
@property (nullable, nonatomic, strong) NSArray *values;

@property (nullable, nonatomic, strong) NSArray <NSNumber *> *pickerSelectedRowInComponent;

@property (nullable, nonatomic, copy) NSString *placeholder;

@property (nonatomic, assign) NSTextAlignment pickerTextAlignment;

@property (nullable, nonatomic, strong) UIColor *pickerValueColor;
@property (nullable, nonatomic, strong) UIFont *pickerValueFont;

@property (nullable, nonatomic, strong) UIColor *pickerPlaceholderColor;

@property (nullable, nonatomic, strong) NSString *defaultPickerText;
@property (nullable, nonatomic, strong, readonly) NSString *pickerText;

@property (nullable, nonatomic, copy) void (^onChange)(BMPickerItem *item);

@property (nullable, nonatomic, copy) NSString  * _Nullable (^formatPickerText)(BMPickerItem *item);

+ (instancetype)itemWithTitle:(nullable NSString *)title placeholder:(nullable NSString *)placeholder components:(NSArray *)components;
+ (instancetype)itemWithTitle:(nullable NSString *)title placeholder:(nullable NSString *)placeholder components:(NSArray *)components defaultPickerText:(nullable NSString *)defaultPickerText;
- (instancetype)initWithTitle:(nullable NSString *)title placeholder:(nullable NSString *)placeholder components:(NSArray *)components;
- (instancetype)initWithTitle:(nullable NSString *)title placeholder:(nullable NSString *)placeholder components:(NSArray *)components defaultPickerText:(nullable NSString *)defaultPickerText;

@end

NS_ASSUME_NONNULL_END
