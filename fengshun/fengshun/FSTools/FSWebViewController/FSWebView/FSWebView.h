//
//  FSWebView.h
//  FSWebView
//
//  Created by DJ on 2017/7/21.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define USE_WEBVIEWJAVASCRIPTBRIDGE     1

#if (USE_WEBVIEWJAVASCRIPTBRIDGE)
#import "WebViewJavascriptBridgeBase.h"
#endif

@protocol WKScriptMessageHandler;
@protocol FSWebViewDelegate;

@class FSWebView, JSContext, WKNavigation;

typedef void (^FSWebViewUpdateProgressBlock)(FSWebView *webView, CGFloat progress);
typedef void (^FSWebViewUpdateTitleBlock)(FSWebView *webView, NSString *title);

@interface FSWebView : UIView

@property (nonatomic, weak) id<FSWebViewDelegate> delegate;

// 是否正在使用 UIWebView
@property (nonatomic, readonly) BOOL usingUIWebView;

// 内部使用的webView
@property (nonatomic, readonly) id realWebView;
@property (nonatomic, readonly) UIScrollView *scrollView;

@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, readonly) NSURLRequest *originRequest;
@property (nonatomic, readonly) NSURLRequest *currentRequest;

@property (nonatomic, readonly, copy) NSString *title;

// 预估网页加载进度
@property (nonatomic, readonly) CGFloat estimatedProgress;

///只有ios7以上的UIWebView才能获取到，WKWebView 请使用下面的方法.
@property (nonatomic, readonly) JSContext *jsContext;

@property (nonatomic, readonly, getter=isLoading) BOOL loading;
@property (nonatomic, readonly) BOOL canGoBack;
@property (nonatomic, readonly) BOOL canGoForward;

// 是否根据视图大小来缩放页面  默认为YES
@property (nonatomic, assign) BOOL scalesPageToFit;

@property (nonatomic, copy) FSWebViewUpdateProgressBlock updateProgressBlock;
@property (nonatomic, copy) FSWebViewUpdateTitleBlock updateTitleBlock;


// 是否使用UIWebView
- (instancetype)initWithFrame:(CGRect)frame usingUIWebView:(BOOL)usingUIWebView;

- (WKNavigation *)loadRequest:(NSURLRequest *)request;
- (WKNavigation *)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;

- (WKNavigation *)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL;

- (WKNavigation *)goBack;
- (WKNavigation *)goForward;
- (WKNavigation *)reload;
- (WKNavigation *)reloadFromOrigin;
- (void)stopLoading;

// back 层数
- (NSInteger)countOfHistory;
- (void)gobackWithStep:(NSInteger)step;


// WKWebView 跟网页进行交互的方法。
- (void)addScriptMessageHandler:(id<WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name;

// 执行js
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler;
// 不建议使用这个办法  因为会在内部等待webView 的执行结果
- (NSString*)stringByEvaluatingJavaScriptFromString:(NSString *)javaScriptString __deprecated_msg("Method deprecated. Use [evaluateJavaScript:completionHandler:]");

#if (USE_WEBVIEWJAVASCRIPTBRIDGE)
// 调用js函数
- (void)callJsHandler:(NSString *)jsFunc withData:(id)data;

- (void)registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler;
- (void)removeHandler:(NSString *)handlerName;

#endif

@end

@protocol FSWebViewDelegate <NSObject>

@optional

- (void)webViewDidStartLoad:(FSWebView *)webView;
- (void)webViewDidFinishLoad:(FSWebView *)webView;
- (void)webView:(FSWebView *)webView didFailLoadWithError:(NSError *)error;
- (BOOL)webView:(FSWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end
