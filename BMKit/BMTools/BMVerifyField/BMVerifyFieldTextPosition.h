//
//  BMVerifyFieldTextPosition.h
//  BMBaseKit
//
//  Created by jiang deng on 2019/4/30.
//  Copyright © 2019 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMVerifyFieldTextPosition : UITextPosition <NSCopying>

@property (nonatomic, readonly) NSInteger offset;

+ (instancetype)positionWithOffset:(NSInteger)offset;

@end

NS_ASSUME_NONNULL_END
