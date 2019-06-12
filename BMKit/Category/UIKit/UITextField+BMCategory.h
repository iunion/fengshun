//
//  UITextField+BMCategory.h
//  BMBasekit
//
//  Created by DennisDeng on 16/6/17.
//  Copyright © 2016年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (BMCategory)

- (void)bm_setPlaceholderColor:(nullable UIColor *)color;
- (void)bm_setPlaceholderFont:(nonnull UIFont *)font;

- (void)bm_selectAllText;

- (void)bm_setSelectedRange:(NSRange)range;

@end
