//
//  BMNumberTextItem.h
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2017/8/23.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "BMTextItem.h"

// 整数位
#define BMNumberText_MaxNumberDigits   7
// 保留小数位
#define BMNumberText_MaxDecimalPlaces  2

@interface BMNumberTextItem : BMTextItem

@property (strong, nonatomic) NSDecimalNumber *numberValue;

@property (copy, nonatomic) NSDecimalNumber *maxNumberValue;
@property (copy, nonatomic) NSDecimalNumber *minNumberValue;

@property (assign, nonatomic) BOOL showWithDecimalStyle;

+ (instancetype)itemWithTitle:(NSString *)title numberValue:(NSDecimalNumber *)numberValue;
+ (instancetype)itemWithTitle:(NSString *)title numberValue:(NSDecimalNumber *)numberValue placeholder:(NSString *)placeholder;
- (id)initWithTitle:(NSString *)title numberValue:(NSDecimalNumber *)numberValue;
- (id)initWithTitle:(NSString *)title numberValue:(NSDecimalNumber *)numberValue placeholder:(NSString *)placeholder;

@end
