//
//  FSWebViewProgress.h
//  FSWebView
//
//  Created by DJ on 2017/7/21.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FSWebViewProgressBlock)(CGFloat progress);

@protocol FSWebViewProgressDelegate;

@interface FSWebViewProgress : NSObject <UIWebViewDelegate>

@property (nonatomic, weak) id<FSWebViewProgressDelegate> progressDelegate;
@property (nonatomic, weak) id<UIWebViewDelegate> webViewProxyDelegate;
@property (nonatomic, copy) FSWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) CGFloat progress; // 0.0..1.0

- (void)reset;

@end


@protocol FSWebViewProgressDelegate <NSObject>

- (void)webViewProgress:(FSWebViewProgress *)webViewProgress updateProgress:(CGFloat)progress;

@end

