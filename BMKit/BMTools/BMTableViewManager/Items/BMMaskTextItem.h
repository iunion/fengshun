//
//  BMMaskTextItem.h
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2017/8/23.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "BMTextItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMMaskTextItem : BMTextItem

// default is NO
@property (nonatomic, assign) BOOL secureTextEntry;

// 输入字符数限制 0: 不限制
@property (nonatomic, assign) NSUInteger charactersLimit;

// 格式正则
@property (nonatomic, copy) NSString *maskPattern;
// 补全文本
@property (nonatomic, copy) NSString *maskPlaceholder;
// 匹配出错是否继续 default is NO
//@property (nonatomic, assign) BOOL maskErrorContinue;

+ (instancetype)itemWithTitle:(nullable NSString *)title value:(nullable NSString *)value placeholder:(nullable NSString *)placeholder maskPattern:(NSString *)maskPattern maskPlaceholder:(NSString *)maskPlaceholder;
- (instancetype)initWithTitle:(nullable NSString *)title value:(nullable NSString *)value placeholder:(nullable NSString *)placeholder maskPattern:(NSString *)maskPattern maskPlaceholder:(NSString *)maskPlaceholder;

@end

NS_ASSUME_NONNULL_END
