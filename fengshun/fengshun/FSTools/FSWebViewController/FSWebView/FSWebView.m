//
//  FSWebView.m
//  FSWebView
//
//  Created by DJ on 2017/7/21.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "FSWebView.h"

#import <TargetConditionals.h>
#import <WebKit/WebKit.h>
#import <dlfcn.h>

#import "FSWebViewProgress.h"

#if (USE_WEBVIEWJAVASCRIPTBRIDGE)
#import "WebViewJavascriptBridge.h"
#import "WKWebViewJavascriptBridge.h"
#endif

@interface FSWebView ()
<
    UIWebViewDelegate,
    WKNavigationDelegate,
    WKUIDelegate,
    FSWebViewProgressDelegate
>

@property (nonatomic, strong) NSURLRequest *originRequest;
@property (nonatomic, strong) NSURLRequest *currentRequest;

@property (nonatomic, copy) NSString* title;
@property (nonatomic, assign) CGFloat estimatedProgress;

@property (nonatomic, strong) FSWebViewProgress *webViewProgress;

#if (USE_WEBVIEWJAVASCRIPTBRIDGE)
@property (nonatomic, strong) id jsBridge;
#endif

@end

@implementation FSWebView
@synthesize usingUIWebView = _usingUIWebView;
@synthesize realWebView = _realWebView;
@synthesize scalesPageToFit = _scalesPageToFit;

#pragma mark - 清理

- (void)dealloc
{
    if (_usingUIWebView)
    {
        UIWebView *webView = _realWebView;
        webView.delegate = nil;
    }
    else
    {
        WKWebView *webView = _realWebView;
        webView.UIDelegate = nil;
        webView.navigationDelegate = nil;
        
        [webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [webView removeObserver:self forKeyPath:@"title"];
    }
    
    [_realWebView removeObserver:self forKeyPath:@"loading"];
    
    [_realWebView scrollView].delegate = nil;
    [_realWebView stopLoading];
    
    [(UIWebView *)_realWebView loadHTMLString:@"" baseURL:nil];
    [_realWebView stopLoading];
    
    [_realWebView removeFromSuperview];
    _realWebView = nil;
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self makeView];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame usingUIWebView:NO];
}

- (instancetype)initWithFrame:(CGRect)frame usingUIWebView:(BOOL)usingUIWebView
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _usingUIWebView = usingUIWebView;
        [self makeView];
    }
    return self;
}

- (void)makeView
{
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    Class wkWebView = NSClassFromString(@"WKWebView");
    if (wkWebView && self.usingUIWebView == NO)
    {
        [self makeWKWebView];
        _usingUIWebView = NO;
    }
    else
    {
        [self makeUIWebView];
        _usingUIWebView = YES;
    }
    
    [self.realWebView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    self.scalesPageToFit = YES;
    
    [self.realWebView setFrame:self.bounds];
    [self.realWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self addSubview:self.realWebView];
}

#pragma mark - 原生对键盘事件的优化
//- (void)keyBoardWillShow:(NSNotification *)note
//{
//    NSDictionary *info = [note userInfo];
//    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    //目标视图view
//    UIView *webView = self.realWebView;
//    CGRect frame = webView.frame;
//    float y = frame.origin.y + frame.size.height - (self.frame.size.height - keyboardSize.height);
//
//    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
//        if (y > 0)
//        {
//            self.frame = CGRectMake(0, -y, self.frame.size.width, self.frame.size.height);
//        }
//    }];
//}
////键盘隐藏后将视图恢复到原始状态
//- (void)keyBoardWillHide:(NSNotification *)note
//{
//    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
//        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    }];
//}

#pragma mark -

- (void)makeWKWebView
{
    WKWebViewConfiguration *configuration = [[NSClassFromString(@"WKWebViewConfiguration") alloc] init];
    configuration.allowsInlineMediaPlayback = YES;
    configuration.userContentController = [NSClassFromString(@"WKUserContentController") new];
    
    // 初始化偏好设置属性：preferences
    WKPreferences *preferences = [NSClassFromString(@"WKPreferences") new];
    // The minimum font size in points default is 0;
    //preferences.minimumFontSize = 40;
    // 是否支持 JavaScript
    preferences.javaScriptEnabled = YES;
    // 不通过用户交互，是否可以打开窗口
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    
    WKWebView *webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:self.bounds configuration:configuration];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    webView.allowsBackForwardNavigationGestures = YES;
//    webView.scrollView.bounces = NO;
    
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    _realWebView = webView;
    
#if (USE_WEBVIEWJAVASCRIPTBRIDGE)
//    self.jsBridge = [WKWebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"ObjC received message from JS: %@", data);
//        responseCallback(@"Response for message from ObjC");
//    }];
    self.jsBridge = [WKWebViewJavascriptBridge bridgeForWebView:webView];
    [self.jsBridge setWebViewDelegate:self];

#endif
}

// for WKWebView
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        self.estimatedProgress = [change[NSKeyValueChangeNewKey] doubleValue];
        NSLog(@"%@", @(self.estimatedProgress));
    }
    else if ([keyPath isEqualToString:@"title"])
    {
        self.title = change[NSKeyValueChangeNewKey];
    }
    else
    {
        // loading 未作处理
        [self willChangeValueForKey:keyPath];
        [self didChangeValueForKey:keyPath];
    }
}

- (void)makeUIWebView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.bounds];
    webView.backgroundColor = [UIColor clearColor];
    
    webView.scalesPageToFit = YES;
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    webView.scrollView.bounces = NO;
    
    webView.allowsInlineMediaPlayback = YES;
    webView.mediaPlaybackRequiresUserAction = NO;
    
    webView.opaque = NO;
    for (UIView *subview in [webView.scrollView subviews])
    {
        if ([subview isKindOfClass:[UIImageView class]])
        {
            ((UIImageView*)subview).image = nil;
            subview.backgroundColor = [UIColor clearColor];
        }
    }
    
    self.webViewProgress = [[FSWebViewProgress alloc] init];
    //webView.delegate = _njkWebViewProgress;
    webView.delegate = self;
    //_njkWebViewProgress.webViewProxyDelegate = self;
    self.webViewProgress.progressDelegate = self;
    
    _realWebView = webView;
    
    self.estimatedProgress = 0.0f;
    
#if (USE_WEBVIEWJAVASCRIPTBRIDGE)
//    self.jsBridge = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"ObjC received message from JS: %@", data);
//        responseCallback(@"Response for message from ObjC");
//    }];
    self.jsBridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [self.jsBridge setWebViewDelegate:self];
#endif
}

- (void)setEstimatedProgress:(double)estimatedProgress
{
    _estimatedProgress = estimatedProgress;
    if (self.updateProgressBlock)
    {
        self.updateProgressBlock(self, estimatedProgress);
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    if (self.updateTitleBlock)
    {
        self.updateTitleBlock(self, title);
    }
}

- (UIScrollView *)scrollView
{
    return [(id)self.realWebView scrollView];
}


#pragma mark - CALLBACK DJWebView Delegate

- (void)callback_webViewDidFinishLoad
{
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)])
    {
        [self.delegate webViewDidFinishLoad:self];
    }
}

- (void)callback_webViewDidStartLoad
{
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)])
    {
        [self.delegate webViewDidStartLoad:self];
    }
}

- (void)callback_webViewDidFailLoadWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)])
    {
        [self.delegate webView:self didFailLoadWithError:error];
    }
}

- (BOOL)callback_webViewShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(NSInteger)navigationType
{
    BOOL resultBOOL = YES;
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)])
    {
        if (navigationType == -1)
        {
            navigationType = UIWebViewNavigationTypeOther;
        }
        resultBOOL = [self.delegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return resultBOOL;
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webViewProgress webViewDidFinishLoad:webView];
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (self.originRequest == nil)
    {
        self.originRequest = webView.request;
    }
    [self callback_webViewDidFinishLoad];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.webViewProgress webViewDidStartLoad:webView];
    
    [self callback_webViewDidStartLoad];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.webViewProgress webView:webView didFailLoadWithError:error];
    
    [self callback_webViewDidFailLoadWithError:error];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (![self.webViewProgress webView:webView shouldStartLoadWithRequest:request navigationType:navigationType])
    {
        return NO;
    }

    BOOL resultBOOL = [self callback_webViewShouldStartLoadWithRequest:request navigationType:navigationType];
    return resultBOOL;
}

- (void)webViewProgress:(FSWebViewProgress *)webViewProgress updateProgress:(CGFloat)progress
{
    //NSLog(@"%@", @(progress));
    self.estimatedProgress = progress;
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    BOOL resultBOOL = [self callback_webViewShouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType];
    BOOL isLoadingDisableScheme = [self isLoadingWKWebViewDisableScheme:navigationAction.request.URL];
    
    if (resultBOOL && !isLoadingDisableScheme)
    {
        self.currentRequest = navigationAction.request;
        if (navigationAction.targetFrame == nil)
        {
            [webView loadRequest:navigationAction.request];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self callback_webViewDidStartLoad];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self callback_webViewDidFinishLoad];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self callback_webViewDidFailLoadWithError:error];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self callback_webViewDidFailLoadWithError:error];
}


#pragma mark - WKUIDelegate
///--  还没用到


#pragma mark - 基础方法

// 判断当前加载的url是否是WKWebView不能打开的协议类型
- (BOOL)isLoadingWKWebViewDisableScheme:(NSURL *)url
{
    BOOL retValue = NO;
    
    NSString *urlString = (url) ? url.absoluteString : @"";
    
    UIApplication *sharedApp = [UIApplication sharedApplication];
    // iTunes: App Store link
    // 例如，微信的下载链接: https://itunes.apple.com/cn/app/id414478124?mt=8
    if (url && [urlString containsString:@"//itunes.apple.com/"])
    {
        [[UIApplication sharedApplication] openURL:url];
        retValue = YES;
    }
    // Protocol/URL-Scheme without http(s)
    else if (url.scheme && ![url.scheme hasPrefix:@"http"])
    {
        if ([sharedApp canOpenURL:url])
        {
            if (@available(iOS 10.0, *)) {
                [sharedApp openURL:url options:@{} completionHandler:nil];
            }
            else
            {
                // Fallback on earlier versions
                [sharedApp openURL:url];
            }
            
            retValue = YES;
        }
    }

#if 0
    // 判断是否正在加载WKWebview不能识别的协议类型：phone numbers, email address, maps, etc.
    if ([url.scheme isEqualToString:@"tel"])
    {
        UIApplication *app = [UIApplication sharedApplication];
        if ([app canOpenURL:url])
        {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
            {
                [app openURL:url options:@{} completionHandler:nil];
            }
            else
            {
                [app openURL:url];
            }

            retValue = YES;
        }
    }
#endif
    
    return retValue;
}

- (WKNavigation *)loadRequest:(NSURLRequest *)request
{
    self.originRequest = request;
    self.currentRequest = request;
    
    if (_usingUIWebView)
    {
        [(UIWebView *)self.realWebView loadRequest:request];
        return nil;
    }
    else
    {
        return [(WKWebView *)self.realWebView loadRequest:request];
    }
}

- (WKNavigation *)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    if (_usingUIWebView)
    {
        [(UIWebView *)self.realWebView loadHTMLString:string baseURL:baseURL];
        return nil;
    }
    else
    {
        return [(WKWebView *)self.realWebView loadHTMLString:string baseURL:baseURL];
    }
}

- (NSURLRequest *)currentRequest
{
    if (_usingUIWebView)
    {
        return [(UIWebView *)self.realWebView request];
    }
    else
    {
        return _currentRequest;
    }
}

- (NSURL *)URL
{
    if (_usingUIWebView)
    {
        return [(UIWebView *)self.realWebView request].URL;
    }
    else
    {
        return [(WKWebView *)self.realWebView URL];
    }
}


- (BOOL)isLoading
{
    return [self.realWebView isLoading];
}

- (BOOL)canGoBack
{
    return [self.realWebView canGoBack];
}

- (BOOL)canGoForward
{
    return [self.realWebView canGoForward];
}

- (WKNavigation *)goBack
{
    if (_usingUIWebView)
    {
        [(UIWebView *)self.realWebView goBack];
        return nil;
    }
    else
    {
        return [(WKWebView *)self.realWebView goBack];
    }
}

- (WKNavigation *)goForward
{
    if (_usingUIWebView)
    {
        [(UIWebView *)self.realWebView goForward];
        return nil;
    }
    else
    {
        return [(WKWebView *)self.realWebView goForward];
    }
}

- (WKNavigation *)reload
{
    if (_usingUIWebView)
    {
        [(UIWebView *)self.realWebView reload];
        return nil;
    }
    else
    {
        return [(WKWebView *)self.realWebView reload];
    }
}

- (WKNavigation *)reloadFromOrigin
{
    if (_usingUIWebView)
    {
        if (self.originRequest)
        {
            [self evaluateJavaScript:[NSString stringWithFormat:@"window.location.replace('%@')", self.originRequest.URL.absoluteString] completionHandler:nil];
        }
        return nil;
    }
    else
    {
        return [(WKWebView *)self.realWebView reloadFromOrigin];
    }
}

- (void)stopLoading
{
    [self.realWebView stopLoading];
}

- (void)setScalesPageToFit:(BOOL)scalesPageToFit
{
    if (_usingUIWebView)
    {
        UIWebView *webView = _realWebView;
        webView.scalesPageToFit = scalesPageToFit;
    }
    else
    {
        if (_scalesPageToFit == scalesPageToFit)
        {
            return;
        }
        
        WKWebView *webView = _realWebView;
        
        NSString *jScript =
        @"var head = document.getElementsByTagName('head')[0];\
        var hasViewPort = 0;\
        var metas = head.getElementsByTagName('meta');\
        for (var i = metas.length; i>=0 ; i--) {\
            var m = metas[i];\
            if (m.name == 'viewport') {\
                hasViewPort = 1;\
                break;\
            }\
        }; \
        if(hasViewPort == 0) { \
            var meta = document.createElement('meta'); \
            meta.name = 'viewport'; \
            meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; \
            head.appendChild(meta);\
        }";
        
        WKUserContentController *userContentController = webView.configuration.userContentController;
        NSMutableArray<WKUserScript *> *array = [userContentController.userScripts mutableCopy];
        WKUserScript *fitWKUScript = nil;
        for (WKUserScript *wkUScript in array)
        {
            if ([wkUScript.source isEqual:jScript])
            {
                fitWKUScript = wkUScript;
                break;
            }
        }
        if (scalesPageToFit)
        {
            if (!fitWKUScript)
            {
                fitWKUScript = [[NSClassFromString(@"WKUserScript") alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
                [userContentController addUserScript:fitWKUScript];
            }
        }
        else
        {
            if (fitWKUScript)
            {
                [array removeObject:fitWKUScript];
            }
            ///没法修改数组 只能移除全部 再重新添加
            [userContentController removeAllUserScripts];
            for (WKUserScript *wkUScript in array)
            {
                [userContentController addUserScript:wkUScript];
            }
        }
    }
    _scalesPageToFit = scalesPageToFit;
}

- (BOOL)scalesPageToFit
{
    if (_usingUIWebView)
    {
        return [_realWebView scalesPageToFit];
    }
    else
    {
        return _scalesPageToFit;
    }
}

- (void)addScriptMessageHandler:(id<WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name
{
    if (!_usingUIWebView)
    {
        WKWebViewConfiguration* configuration = [(WKWebView*)self.realWebView configuration];
        [configuration.userContentController addScriptMessageHandler:scriptMessageHandler name:name];
    }
}

- (JSContext *)jsContext
{
    if (_usingUIWebView)
    {
        return [(UIWebView *)self.realWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    }
    else
    {
        return nil;
    }
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler
{
    if (_usingUIWebView)
    {
        NSString *result = [(UIWebView *)self.realWebView stringByEvaluatingJavaScriptFromString:javaScriptString];
        if (completionHandler)
        {
            completionHandler(result, nil);
        }
    }
    else
    {
        return [(WKWebView *)self.realWebView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
    }
}

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)javaScriptString
{
    if (_usingUIWebView)
    {
        NSString *result = [(UIWebView *)self.realWebView stringByEvaluatingJavaScriptFromString:javaScriptString];
        return result;
    }
    else
    {
        __block NSString *result = nil;
        __block BOOL isExecuted = NO;
        [(WKWebView *)self.realWebView evaluateJavaScript:javaScriptString completionHandler:^(id obj, NSError * error) {
            result = obj;
            isExecuted = YES;
        }];
        
        while (isExecuted == NO)
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        return result;
    }
}

- (NSInteger)countOfHistory
{
    if (_usingUIWebView)
    {
        UIWebView *webView = self.realWebView;
        
        int count = [[webView stringByEvaluatingJavaScriptFromString:@"window.history.length"] intValue];
        if (count)
        {
            return count;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        WKWebView *webView = self.realWebView;
        return webView.backForwardList.backList.count;
    }
}

- (void)gobackWithStep:(NSInteger)step
{
    if (self.canGoBack == NO)
    {
        return;
    }
    
    if (step > 0)
    {
        NSInteger historyCount = self.countOfHistory;
        if (step >= historyCount)
        {
            step = historyCount - 1;
        }
        
        if (_usingUIWebView)
        {
            UIWebView *webView = self.realWebView;
            [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.history.go(-%ld)", (long)step]];
        }
        else
        {
            WKWebView *webView = self.realWebView;
            WKBackForwardListItem *backItem = webView.backForwardList.backList[step];
            [webView goToBackForwardListItem:backItem];
        }
    }
    else
    {
        [self goBack];
    }
}


#pragma mark -  如果没有找到方法 去realWebView 中调用

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL hasResponds = [super respondsToSelector:aSelector];
    if (hasResponds == NO)
    {
        hasResponds = [self.delegate respondsToSelector:aSelector];
    }
    if (hasResponds == NO)
    {
        hasResponds = [self.realWebView respondsToSelector:aSelector];
    }
    return hasResponds;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *methodSign = [super methodSignatureForSelector:selector];
    if (methodSign == nil)
    {
        if ([self.realWebView respondsToSelector:selector])
        {
            methodSign = [self.realWebView methodSignatureForSelector:selector];
        }
        else
        {
            methodSign = [(id)self.delegate methodSignatureForSelector:selector];
        }
    }
    return methodSign;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    if ([self.realWebView respondsToSelector:invocation.selector])
    {
        [invocation invokeWithTarget:self.realWebView];
    }
    else
    {
        [invocation invokeWithTarget:self.delegate];
    }
}


#pragma mark -
#pragma mark JS

#if (USE_WEBVIEWJAVASCRIPTBRIDGE)
// 调用js函数
- (void)callJsHandler:(NSString *)jsFunc withData:(id)data
{
    __weak NSString *js = jsFunc;
    [self.jsBridge callHandler:jsFunc data:data responseCallback:^(id response) {
        NSLog(@"%@ responded: %@", js, response);
    }];
}

- (void)registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler
{
    [self.jsBridge registerHandler:handlerName handler:handler];
}

- (void)removeHandler:(NSString *)handlerName
{
    [self.jsBridge removeHandler:handlerName];
}

#endif

@end
