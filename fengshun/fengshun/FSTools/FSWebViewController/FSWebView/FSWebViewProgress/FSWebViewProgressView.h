//
//  FSWebViewProgressView.h
//  FSWebView
//
//  Created by DJ on 2017/7/21.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSWebViewProgressView : UIView

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) UIView *progressBarView;

@property (nonatomic, weak) UIColor *barColor;

@property (nonatomic, assign) NSTimeInterval barAnimationDuration; // default 0.1
@property (nonatomic, assign) NSTimeInterval fadeAnimationDuration; // default 0.27
@property (nonatomic, assign) NSTimeInterval fadeOutDelay; // default 0.1

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
