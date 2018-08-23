//
//  UIWindow+BMCategory.h
//  BMBasekit
//
//  Created by DennisDeng on 15-2-26.
//  Copyright (c) 2015年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (BMCategory)

- (nonnull UIImage *)bm_screenshot;
- (nonnull UIImage *)bm_screenshotWithRect:(CGRect)rect;

- (void)bm_screenshotWithDelay:(CGFloat)delay rect:(CGRect)rect completion:(void (^ _Nullable)(UIImage * _Nullable image))completion;

@end
