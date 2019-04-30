//
//  BMVerifyFieldTextRange.h
//  BMBaseKit
//
//  Created by jiang deng on 2019/4/30.
//  Copyright © 2019 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMVerifyFieldTextPosition.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMVerifyFieldTextRange : UITextRange  <NSCopying>

@property (nonatomic, readonly) BMVerifyFieldTextPosition *start;
@property (nonatomic, readonly) BMVerifyFieldTextPosition *end;

@property (nonatomic, readonly) NSRange range;

+ (nullable instancetype)rangeWithStart:(BMVerifyFieldTextPosition *)start end:(BMVerifyFieldTextPosition *)end;

+ (nullable instancetype)rangeWithRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
