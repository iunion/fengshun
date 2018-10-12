//
//  FSWKWebViewController.h
//  miaoqian
//
//  Created by DJ on 2017/7/20.
//  Copyright © 2017年 MiaoQian. All rights reserved.
//

#import "FSSuperNetVC.h"
#import "WebViewJavascriptBridgeBase.h"

NS_ASSUME_NONNULL_BEGIN

@class FSWebView;
@protocol FSWebViewControllerDelegate;

@interface FSWebViewController : FSSuperNetVC

@property (nonatomic, strong, readonly) FSWebView *m_WebView;

@property (nullable, nonatomic, strong) NSString *m_Title;

@property (nullable, nonatomic, copy) NSString *m_UrlString;
@property (nullable, nonatomic, strong) NSDictionary *m_RequestParam;

@property (nullable, nonatomic, weak) id<FSWebViewControllerDelegate> delegate;

// 使用UIWebView，默认: YES
@property (nonatomic, assign) BOOL m_UsingUIWebView;

// 是否是post请求
@property (nonatomic, assign) BOOL m_IsPost;

// 显示导航条返回按钮，默认: YES
@property (nonatomic, assign) BOOL m_ShowNavBack;

// 通过H5的dcoument.title页面刷新title，默认: YES
@property (nonatomic, assign) BOOL m_ShowPageTitles;

// 是否不显示左上角x按钮，默认: NO，显示x
@property (nonatomic, assign) BOOL m_IsNotShowCloseBtn;

- (instancetype)initWithTitle:(nullable NSString *)title url:(nullable NSString *)url;
- (instancetype)initWithTitle:(nullable NSString *)title url:(nullable NSString *)url showLoadingBar:(BOOL)showLoadingBar loadingBarColor:(nullable UIColor *)color;
- (instancetype)initWithTitle:(nullable NSString *)title url:(nullable NSString *)url showLoadingBar:(BOOL)showLoadingBar loadingBarColor:(nullable UIColor *)color delegate:(nullable id<FSWebViewControllerDelegate>)delegate;

- (instancetype)initWithTitle:(nullable NSString *)title url:(nullable NSString *)url requestParam:(nullable NSDictionary *)requestParam showLoadingBar:(BOOL)showLoadingBar loadingBarColor:(nullable UIColor *)color delegate:(nullable id<FSWebViewControllerDelegate>)delegate;

// 调用js函数
- (void)callJsHandler:(NSString *)jsFunc withData:(id)data;
// 注册js函数
- (void)registerHander:(NSString *)jsFunc handler:(WVJBHandler)handler;
// 刷新web
- (void)refreshWebView;

- (void)setWebFrame:(CGRect)frame;

@end

@protocol FSWebViewControllerDelegate <NSObject>

@optional
- (void)webView:(FSWebViewController *)webVC didClickNavRightBtnWithIndex:(NSUInteger)index;

- (void)webViewWillClose:(FSWebViewController *)webVC;

@end

NS_ASSUME_NONNULL_END
