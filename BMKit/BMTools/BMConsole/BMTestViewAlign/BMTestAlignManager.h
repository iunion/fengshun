//
//  BMTestAlignManager.h
//  fengshun
//
//  Created by jiang deng on 2018/11/28.
//  Copyright © 2018 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMTestAlignManager : NSObject

+ (instancetype)sharedInstance;

- (void)show;
- (void)close;

- (BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
