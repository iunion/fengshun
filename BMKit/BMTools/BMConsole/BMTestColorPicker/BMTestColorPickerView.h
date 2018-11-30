//
//  BMTestColorPickerView.h
//  fengshun
//
//  Created by jiang deng on 2018/11/29.
//  Copyright © 2018 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMTestColorPickerView : UIView

@property (nonatomic, weak) UIWindow *window;

- (void)setCurrentColorWithHexStr:(NSString *)hexColor;
- (void)setCurrentColorWithHexStr:(NSString *)hexColor alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
