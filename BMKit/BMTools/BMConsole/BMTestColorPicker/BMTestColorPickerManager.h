//
//  BMTestColorPickerManager.h
//  fengshun
//
//  Created by jiang deng on 2018/11/30.
//  Copyright © 2018 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMTestColorPickerManager : NSObject

+ (instancetype)sharedInstance;

- (void)show;
- (void)close;

- (BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
