//
//  FSWebViewController.m
//  miaoqian
//
//  Created by DJ on 2017/7/20.
//  Copyright © 2017年 MiaoQian. All rights reserved.
//

#import "FSWebViewController.h"
#import "AppDelegate.h"
#import "FSAppInfo.h"
#import "FSUserInfo.h"

#import "FSWebView.h"
#import "FSWebViewProgressView.h"

#import "FSApiRequest.h"
#import "FSCoreStatus.h"
#import "FSAlertView.h"
#import "FSMoreViewVC.h"
#import "NSString+BMURLEncode.h"
#import "NSAttributedString+BMCategory.h"

#define SHOW_CLOSEBTN_CANGOEBACK    1

/* Hieght of the loading progress bar view */
#define LOADING_BAR_HEIGHT          2.0f

#define USER_AGENT_TAG              @" fengshun_json:"

#warning AGENTWHITELIST
#define FSWEBVIEW_AGENTWHITELIST    @[@".odrcloud", @".bjsjsadr"]


@interface FSWebViewController ()
<
    FSWebViewDelegate,
    FSMoreViewVCDelegate,
    FSShareManagerDelegate
>
{
    // 显示关闭
    BOOL addClose;
    
    BOOL needShowFresh;
    
    NSString *s_PhtoUrlStr;
    
}
// 分享的json
@property (nonatomic , strong) NSString *s_ShareJsonSting;
// 收藏json
@property (nonatomic , strong) NSString *s_CollectJsonSting;
// 是否收藏
@property (nonatomic, assign) BOOL s_isCollect;

@property (nonatomic, strong) FSWebView *m_WebView;
@property (nonatomic, strong) NSMutableURLRequest *m_UrlRequest;
@property (nonatomic, strong) FSWebViewProgressView *m_ProgressView;

// 显示进度 Default value is YES.
@property (nonatomic, assign) BOOL m_ShowLoadingBar;
// 显示颜色
@property (nonatomic, strong) UIColor *m_LoadingBarTintColor;

@property (nonatomic, strong) NSArray *m_NavLeftBtnArray;
@property (nonatomic, strong) NSArray *m_NavRightBtnArray;
// 刷新还是复制
@property (nonatomic, assign) BOOL m_IsRefresh;

@property (nonatomic, assign)dispatch_once_t addNotificationOnceToken;
// 监听键盘事件,改变webview尺寸,以解决键盘遮挡输入框的问题(暂时不开放)
//@property (nonatomic, assign) BOOL m_ManageKeyBoard;

@end

@implementation FSWebViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:userInfoChangedNotification object:nil];
}

- (instancetype)initWithTitle:(NSString *)title url:(NSString *)url
{
    return [self initWithTitle:title url:url showLoadingBar:YES loadingBarColor:nil];
}

- (instancetype)initWithTitle:(NSString *)title url:(NSString *)url navRightTitle:(NSString *)navRightTitle delegate:(id<FSWebViewControllerDelegate>)delegate
{
    return [self initWithTitle:title url:url showLoadingBar:YES loadingBarColor:nil delegate:delegate];
}

- (instancetype)initWithTitle:(NSString *)title url:(NSString *)url showLoadingBar:(BOOL)showLoadingBar loadingBarColor:(UIColor *)color
{
    return [self initWithTitle:title url:url showLoadingBar:showLoadingBar loadingBarColor:color delegate:nil];
}

- (instancetype)initWithTitle:(NSString *)title url:(NSString *)url showLoadingBar:(BOOL)showLoadingBar loadingBarColor:(UIColor *)color delegate:(id<FSWebViewControllerDelegate>)delegate
{
    return [self initWithTitle:title url:url requestParam:nil showLoadingBar:showLoadingBar loadingBarColor:color delegate:nil];
}

- (instancetype)initWithTitle:(NSString *)title url:(NSString *)url requestParam:(NSDictionary *)requestParam showLoadingBar:(BOOL)showLoadingBar loadingBarColor:(UIColor *)color delegate:(id<FSWebViewControllerDelegate>)delegate
{
    self = [self init];
    
    if (self)
    {
        _m_Title = title;
        _m_UrlString = url;
        _m_RequestParam = requestParam;
        _m_ShowLoadingBar = showLoadingBar;
        _m_LoadingBarTintColor = color;
        _m_UsingUIWebView = NO;
        _m_ShowNavBack = YES;
        _m_ShowPageTitles = YES;
        _delegate = delegate;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    return self;
}

- (void)loadJsExamplePage:(UIWebView *)webView
{
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)loadpage
{
    NSString *loadUrl = [self.m_UrlString bm_trim];
    
    if ([loadUrl bm_isNotEmpty])
    {
        loadUrl = [loadUrl bm_URLEncode];
        
        NSURL *checkUrl = [NSURL URLWithString:loadUrl];
        NSString *scheme = checkUrl.scheme;
        
        if ([scheme bm_isNotEmpty])
        //if ([loadUrl rangeOfString:@"http"].location == 0)
        {
            //NSURL *url = [NSURL URLWithString:loadUrl];
            NSURLRequest *urlRequest;
            if (![self.m_RequestParam bm_isNotEmptyDictionary])
            {
                urlRequest = [[NSMutableURLRequest alloc] initWithURL:checkUrl];
            }
            else
            {
                urlRequest = [FSApiRequest makeRequestWithURL:loadUrl parameters:self.m_RequestParam isPost:self.m_IsPost];
            }
            
            [self.m_WebView loadRequest:urlRequest];
        }
        else if ([loadUrl containsString:@"www."])
        {
            NSURLRequest * urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@", loadUrl]]];
            [self.m_WebView loadRequest:urlRequest];
        }
        else
        {
            // 加载本地html数据
            NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
            NSString *filePath = [resourcePath stringByAppendingPathComponent:loadUrl];
            NSString *appHtml = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            if (appHtml)
            {
                NSURL *baseURL = [NSURL fileURLWithPath:filePath];
                [self.m_WebView loadHTMLString:appHtml baseURL:baseURL];
            }
            else
            {
                NSURLRequest * urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.%@", loadUrl]]];
                [self.m_WebView loadRequest:urlRequest];
            }

        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (!self.m_Title)
    {
        self.m_Title = @"";
    }
    
    addClose = NO;
    
    [self updateNavWithLeftArray:self.m_NavLeftBtnArray rightArray:self.m_NavRightBtnArray];
    
    if (self.m_ShowLoadingBar)
    {
        CGFloat progressBarHeight = LOADING_BAR_HEIGHT;
        CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
        self.m_ProgressView = [[FSWebViewProgressView alloc] initWithFrame:barFrame];
        self.m_ProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        self.m_ProgressView.backgroundColor = [UIColor clearColor];
        if (self.m_LoadingBarTintColor)
        {
            self.m_ProgressView.progressBarView.backgroundColor = self.m_LoadingBarTintColor;
        }
    }
    
    [self makeWebView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeWebView) name:userInfoChangedNotification object:nil];
    
    // 案例、法规、文书详情右上角…分享菜单中“复制链接”功能 改为刷新 
     self.m_IsRefresh = [self.m_UrlString containsString:@"Law"] || [self.m_UrlString containsString:@"caseGuide"] || [self.m_UrlString containsString:@"caseDetail"] || [self.m_UrlString containsString:@"law"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateNavWithLeftArray:self.m_NavLeftBtnArray rightArray:self.m_NavRightBtnArray];
    
    if (self.m_ShowLoadingBar)
    {
        [self.navigationController.navigationBar addSubview:self.m_ProgressView];
    }
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.m_ShowLoadingBar)
    {
        // Remove progress view
        // because UINavigationBar is shared with other ViewControllers
        if (self.m_ProgressView.superview)
        {
            [self.m_ProgressView removeFromSuperview];
        }
    }
}

- (void)makeWebView
{
    // add user-agent
    [self addUserInfoIntoUserAgent];
    
    if (self.m_WebView && self.m_WebView.superview)
    {
        [self.m_WebView removeFromSuperview];
    }
    
    self.m_WebView = [[FSWebView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT) usingUIWebView:self.m_UsingUIWebView];
    
    //NSString *oldAgent = [self.m_WebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    //LLog(@"old agent :%@", oldAgent);
    
    self.m_WebView.delegate = self;
    [self.view addSubview:self.m_WebView];
    
    __weak typeof(self) weakSelf = self;
    self.m_WebView.updateProgressBlock = ^(FSWebView *webView, CGFloat progress){
        [weakSelf.m_ProgressView setProgress:progress animated:YES];
    };
    
    self.m_WebView.updateTitleBlock = ^(FSWebView *webView, NSString *title){
        if (weakSelf.m_ShowPageTitles)
        {
            if ([title bm_isNotEmpty])
            {
                weakSelf.m_Title = title;
                [weakSelf bm_setNavigationBarTitle:title];
                [GetAppDelegate.m_TabBarController hideOriginTabBar];
            }
        }
    };

    [self registerJSHandler];

    [self loadpage];
    
    [self bringSomeViewToFront];
}

- (void)setWebFrame:(CGRect)frame
{
    [self.m_WebView setFrame:frame];
}


#pragma mark - 原生对键盘事件的优化

- (void)needAddKeyBoardNotificationObserver
{
    BMLog(@"接管WebView的键盘事件...");
    dispatch_once(&_addNotificationOnceToken, ^{
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [nc addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        [nc removeObserver:self.m_WebView.realWebView name:UIKeyboardWillHideNotification object:nil];
        [nc removeObserver:self.m_WebView.realWebView name:UIKeyboardWillShowNotification object:nil];
        [nc removeObserver:self.m_WebView.realWebView name:UIKeyboardWillChangeFrameNotification object:nil];
        [nc removeObserver:self.m_WebView.realWebView name:UIKeyboardDidChangeFrameNotification object:nil];
    });
    
}

- (void)keyBoardWillShow:(NSNotification *)note
{
    UIView *webView = self.m_WebView.realWebView;
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //目标视图view

    CGFloat fullWidth = self.m_WebView.frame.size.width;
    CGFloat fullHeight = self.m_WebView.frame.size.height;
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        webView.frame = CGRectMake(0, 0, fullWidth, fullHeight - keyboardSize.height);
    }];
}

// 键盘隐藏后将视图恢复到原始状态
- (void)keyBoardWillHide:(NSNotification *)note
{
    UIView *webView = self.m_WebView.realWebView;
    CGFloat fullWidth = self.m_WebView.frame.size.width;
    CGFloat fullHeight = self.m_WebView.frame.size.height;
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        webView.frame = CGRectMake(0, 0, fullWidth, fullHeight);
    }];
}


#pragma mark -
#pragma mark UserAgent

- (void)addUserInfoIntoUserAgent
{
#ifndef DEBUG
    NSString *loadUrl = [self.m_UrlString bm_trim];
    
    if ([loadUrl bm_isNotEmpty])
    {
        NSURL *url = [NSURL URLWithString:loadUrl];
        NSString *host = [url host];
        
        NSArray *userAgent = FSWEBVIEW_AGENTWHITELIST;
        __block BOOL inWhiteList = NO;
        [userAgent enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([host rangeOfString:obj].length > 0)
            {
                inWhiteList = YES;
                *stop = YES;
            }
        }];
        
        if (!inWhiteList)
        {
            return;
        }
    }
#endif
    
    // get the original user-agent of webview
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    BMLog(@"old agent :%@", oldAgent);
    NSRange rang = [oldAgent rangeOfString:USER_AGENT_TAG];
    
    if (rang.length > 0)
    {
        oldAgent = [oldAgent substringToIndex:rang.location];
    }
    
    NSString *agent = [oldAgent stringByAppendingString:USER_AGENT_TAG];
    
    NSMutableDictionary *agentDic = [[NSMutableDictionary alloc] init];
    FSUserInfoModel *userInfo = GetAppDelegate.m_UserInfo;
    NSString *newAgent;
    if ([userInfo.m_Token bm_isNotEmpty])
    {
        [agentDic bm_setString:[FSAppInfo getOpenUDID] forKey:@"deviceId"];
        // 设备号
        [agentDic bm_setString:[UIDevice bm_devicePlatformString] forKey:@"deviceModel"];
        // 设备系统类型
        [agentDic bm_setString:@"iOS" forKey:@"cType"];
        // 系统版本号
        [agentDic bm_setString:CURRENT_SYSTEMVERSION forKey:@"osVersion"];
        // app名称
        [agentDic bm_setString:FSAPP_APPNAME forKey:@"appName"];
        // app版本
        [agentDic bm_setString:APP_VERSIONNO forKey:@"appVersion"];
        // 渠道 "App Store"
        [agentDic bm_setString:[FSAppInfo catchChannelName] forKey:@"channelCode"];
        [agentDic bm_setString:[FSCoreStatus currentFSNetWorkStatusString] forKey:@"netWorkStandard"];
        
        [agentDic bm_setString:userInfo.m_Token forKey:@"JWTToken"];
         newAgent = [agent stringByAppendingString:[agentDic bm_toJSON]];
    }
    else
    {
        newAgent = oldAgent;
    }
    
    // add my info to the new agent
   
    BMLog(@"++++[new agent]:%@", newAgent);
    
    // regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}


#pragma mark -
#pragma mark freshNav

- (void)backAction:(id)sender
{
    if (self.m_WebView.canGoBack && !self.m_IsNotShowCloseBtn)
    {
        [self.m_WebView goBack];
        [self updateNavBack];
        
        // 隐藏右边item
        UIButton *btn = [self bm_getNavigationRightItemAtIndex:0];
        btn.hidden = YES;
        
        [self bm_setNeedsUpdateNavigationBar];
    }
    else
    {
        [self closeAction:sender];
    }
}

- (void)closeAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewWillClose:)])
    {
        [self.delegate webViewWillClose:self];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)rightAction:(UIButton *)btn
//{
//    if (![self.m_NavRightBtnDic isNotEmptyDictionary])
//    {
//        return;
//    }
//
//    NSInteger type = [self.m_NavRightBtnDic intForKey:@"type"];
//    switch (type)
//    {
//        // 分享
//        case 1:
//        {
//            NSString *title = [self.m_NavRightBtnDic stringTrimForKey:@"share_title"];
//            NSString *shareText = [self.m_NavRightBtnDic stringTrimForKey:@"share_content"];
//            NSString *imageBase64 = [self.m_NavRightBtnDic stringTrimForKey:@"share_imagebase64"];
//            NSData *imageData = [NSString base64DecodeString:imageBase64];
//            id image = [UIImage imageWithData:imageData];
//            if (!image)
//            {
//                image = imageBase64;
//            }
//            NSString *url = [self.m_NavRightBtnDic stringTrimForKey:@"share_url"];
//
//            NSString *platform = [self.m_NavRightBtnDic stringTrimForKey:@"share_platform"];
//
//            NSArray *platformArray = [platform componentsSeparatedByString:@","];
//
//            [self shareSDKWithTitle:title shareImage:image content:shareText shareUrlStr:url sharePlatform:platformArray];
//        }
//            break;
//
//        // 链接
//        case 2:
//        {
//            NSString *url = [self.m_NavRightBtnDic stringTrimForKey:@"links"];
//            [MQVCShow showWebView:self url:url title:nil];
//        }
//            break;
//
//        default:
//            break;
//    }
//}

- (void)updateNavBack
{
    if (!addClose && !self.m_IsNotShowCloseBtn)
    {
        if (self.m_ShowNavBack)
        {
            if (self.m_WebView.canGoBack)
            {
                NSDictionary *btnItem1 = [self bm_makeBarButtonDictionaryWithTitle:@" " image:@"navigationbar_back_icon" toucheEvent:@"backAction:" buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:0];
                NSDictionary *btnItem2 = [self bm_makeBarButtonDictionaryWithTitle:@" " image:@"navigationbar_close_icon" toucheEvent:@"closeAction:" buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:0];
                self.m_NavLeftBtnArray = @[btnItem1, btnItem2];
                [self updateNavWithLeftArray:self.m_NavLeftBtnArray rightArray:self.m_NavRightBtnArray];
                
                addClose = YES;
            }
            else
            {
                NSDictionary *btnItem1 = [self bm_makeBarButtonDictionaryWithTitle:nil image:@"navigationbar_back_icon" toucheEvent:@"backAction:" buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:0];
                self.m_NavLeftBtnArray = @[btnItem1];
                [self updateNavWithLeftArray:self.m_NavLeftBtnArray rightArray:self.m_NavRightBtnArray];
                
                addClose = NO;
            }
        }
        else
        {
            if (self.m_WebView.canGoBack)
            {
                NSDictionary *btnItem1 = [self bm_makeBarButtonDictionaryWithTitle:@" " image:@"navigationbar_back_icon" toucheEvent:@"backAction:" buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:0];
                self.m_NavLeftBtnArray = @[btnItem1];
                [self updateNavWithLeftArray:self.m_NavLeftBtnArray rightArray:self.m_NavRightBtnArray];
                
                addClose = YES;
            }
            else
            {
                self.m_NavLeftBtnArray = nil;
                [self updateNavWithLeftArray:self.m_NavLeftBtnArray rightArray:self.m_NavRightBtnArray];
                
                addClose = NO;
            }
        }
    }
}

- (void)setNavWithTitle:(NSString *)title leftArray:(NSArray *)larray rightArray:(NSArray *)rarray;
{
    self.m_Title = title;
    
    [self updateNavWithLeftArray:larray rightArray:rarray];
}

- (void)updateNavWithLeftArray:(NSArray *)larray rightArray:(NSArray *)rarray
{
    if (self.m_ShowNavBack)
    {
        if (![larray bm_isNotEmpty])
        {
            NSDictionary *btnItem = [self bm_makeBarButtonDictionaryWithTitle:nil image:@"navigationbar_back_icon" toucheEvent:@"backAction:" buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:0];
            larray = @[btnItem];
        }
    }
    
    self.m_NavLeftBtnArray = larray;
    self.m_NavRightBtnArray = rarray;
    
    [self bm_setNavigationWithTitle:self.m_Title barTintColor:nil leftDicArray:larray rightDicArray:rarray];
    [GetAppDelegate.m_TabBarController hideOriginTabBar];
}


#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self updateNavBack];

#ifdef DEBUG
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    BMLog(@"%@", currentURL);
#endif
    
#if 0
    [self.m_WebView evaluateJavaScript:@"document.getElementsByName('miaoqian_right_content')[0].content" completionHandler:^(id object, NSError *error) {
        NSString *js_RightBtn = (NSString *)object;
        
        if ([js_RightBtn isNotEmpty])
        {
            NSData *rightData = [NSString base64DecodeString:js_RightBtn];
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:rightData options:NSJSONReadingMutableLeaves error:nil];
            LLog(@"%@", dic);
            self.m_NavRightBtnDic = dic;
            
            NSString *title = [dic stringTrimForKey:@"right_name"];
            if ([title isNotEmpty])
            {
                NSDictionary *RDic1 = @{NAV_RIGHTBTN_TITLE_KEY:title, NAV_RIGHTBTN_SELECTOR_KEY:@"rightAction:"};
                self.m_NavRightBtnArray = @[RDic1];
                
                [self updateNavWithLeftArray:self.m_NavLeftBtnArray rightArray:self.m_NavRightBtnArray];
            }
        }
    }];
#endif
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
#if 0
    if (error.code == -1009)
    {
        if (![self.m_NoDataView isNotEmpty])
        {
            self.m_NoDataView = [[MQNoDataView alloc] initWithType:MQNODATAVIEW_NETERROR];
            self.m_NoDataView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT);
            self.m_NoDataView.delegate = self;
            
            [self.m_WebView addSubview:self.m_NoDataView];
        }
    }
    
    if (self.m_FreshHeaderView.isFreshing)
    {
        [self resetFreshState:HMFreshStateIdle];
    }
#endif
}

- (void)refreshWebView
{
    [self.m_WebView reload];
}


#pragma mark -
#pragma mark JS

// 调用js函数
- (void)callJsHandler:(NSString *)jsFunc withData:(id)data
{
    [self.m_WebView callJsHandler:jsFunc withData:data];
}

- (void)registerHander:(NSString *)jsFunc handler:(WVJBHandler)handler
{
    [self.m_WebView registerHandler:jsFunc handler:handler];
}

// 无用
- (void)removeJSHandler
{
    // 登录
    [self.m_WebView removeHandler:@"toLogin"];
    // 注册
    [self.m_WebView removeHandler:@"register"];
    // 分享
    [self.m_WebView removeHandler:@"toShare"];
    // 查看大图
    [self.m_WebView removeHandler:@"showpic"];
    // 复制文本到粘贴板
    [self.m_WebView removeHandler:@"copy"];
}

- (void)registerJSHandler
{
#if 0
    // 分享
    [self.m_WebView registerHandler:@"toShare" handler:^(id data, WVJBResponseCallback responseCallback) {
        BMLog(@"share called: %@", data);
        //responseCallback(@"Response from register");
        
        NSDictionary *shareDic = (NSDictionary *)data;
        
        NSString *title = [shareDic bm_stringTrimForKey:@"share_title"];
        NSString *shareText = [shareDic bm_stringTrimForKey:@"share_content"];
        NSString *imageBase64 = [shareDic bm_stringTrimForKey:@"share_imagebase64"];
        NSData *imageData = [NSString bm_base64DecodeString:imageBase64];
        id image = [UIImage imageWithData:imageData];
        if (!image)
        {
            image = imageBase64;
        }
        NSString *url = [shareDic bm_stringTrimForKey:@"share_url"];
        [weakSelf shareSDKWithTitle:title shareImage:image content:shareText shareUrlStr:url];
    }];

    
    // 跳转页
    [self.m_WebView registerHandler:@"showtab" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        BMLog(@"showmain called: %@", data);
        
        NSDictionary *tabDic = (NSDictionary *)data;
        [GetAppDelegate.m_TabBarController selectedTabWithIndex:[tabDic bm_uintForKey:@"tabindex"]];
    }];
    
    // 查看大图
    [self.m_WebView registerHandler:@"showpic" handler:^(id data, WVJBResponseCallback responseCallback) {
        BMLog(@"showpic called: %@", data);
        
//        NSDictionary *photoDic = (NSDictionary *)data;
//        NSString *photoUrl = [photoDic stringTrimForKey:@"img_url"];
//        NSString *newURL = [photoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        [weakSelf showPhoto:newURL];
    }];
    
    
    // 复制文本到粘贴板
    [self.m_WebView registerHandler:@"copy" handler:^(id data, WVJBResponseCallback responseCallback) {
        BMLog(@"copy called: %@", data);
        
        NSDictionary *copyDic = (NSDictionary *)data;
        NSString *text = [copyDic bm_stringTrimForKey:@"content"];
        if ([text bm_isNotEmpty])
        {
            [[UIPasteboard generalPasteboard] setString:text];
            [weakSelf.m_ProgressHUD showAnimated:YES withDetailText:@"复制成功" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
        else
        {
            [weakSelf.m_ProgressHUD showAnimated:YES withDetailText:@"复制失败" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
    }];
    // 显示分享面板
    [self.m_WebView registerHandler:@"showShareBoard" handler:^(id data, WVJBResponseCallback responseCallback) {
        BMLog(@"showShareBoard called: %@", data);
        
    }];
#endif
    
    BMWeakSelf
    //  添加键盘管理
    [self.m_WebView registerHandler:@"manageKeyboard" handler:^(NSString *jsonStr, WVJBResponseCallback responseCallback) {
        NSDictionary *data = [NSDictionary bm_dictionaryWithJsonString:jsonStr];
        if ([data bm_boolForKey:@"shouldManage"]) {
            [weakSelf needAddKeyBoardNotificationObserver];
        }
        
    }];
    
    // 登录
    [self.m_WebView registerHandler:@"toLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        BMLog(@"login called: %@", data);
        [weakSelf showLogin];
    }];
    
    // 分享
    [self.m_WebView registerHandler:@"toShare" handler:^(id data, WVJBResponseCallback responseCallback) {
        BMLog(@"share called: %@", data);
        /*f5HM8GUBN3_o1ImUsbSy
         {"title":"中华人民共和国广告法",
         "url":"https://devftlsh5.odrcloud.net/Law/lawDetail?ID=TJDjrGUBN3_o1ImUSqS9&keywords=%E5%90%88%E5%90%8C%E7%BA%A0%E7%BA%B7&a=a",
         "content":"枫调理顺—调解员专属的APP",
         "imgUrl":"https://devres.odrcloud.net/storm-test//51/200/97c7f2c52c3c4038868f8d04d15ae8c1.png",
         "id":"TJDjrGUBN3_o1ImUSqS9",
         "type":"STATUTE"}
         */
        weakSelf.s_ShareJsonSting = data;
    }];
    
    // 举报
    [self.m_WebView registerHandler:@"toReport" handler:^(id data, WVJBResponseCallback responseCallback) {
        /*
         {"id":"3","type":"COMMENT","commentPerson":"用户林1","commentContent":"这是0评论内容"}
         */
        BMLog(@"toReport called: %@", data);
        
        [weakSelf showReportAlertWithData:data];
    }];
    
    //收藏按钮
    [self.m_WebView registerHandler:@"toCollect" handler:^(id data, WVJBResponseCallback responseCallback) {
        /*
         {
             "id":"kJDjrGUBN3_o1ImUV6QM",
             "type":"STATUTE",
             "source":"全国人民代表大会常务委员会",
             "title":"中华人民共和国药品管理法",
             "guidingCase":""
         }
         */
        BMLog(@"toCollect called: %@", data);
        
        weakSelf.s_CollectJsonSting = data;
        [weakSelf addRightBtn];
    }];
    
    
    // 跳转客服
//    [self.m_WebView registerHandler:@"contactCustomerService" handler:^(id data, WVJBResponseCallback responseCallback) {
//
//        [MQVCShow showFeedbackVC:weakSelf];
//    }];
}

// 添加更多按钮
- (void)addRightBtn
{
    [self updateNavWithLeftArray:self.m_NavLeftBtnArray rightArray:@[ [self bm_makeBarButtonDictionaryWithTitle:nil image:@"navigationbar_more_icon" toucheEvent:@"moreAction" buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:0]]];
    //[self bm_setNavigationWithTitle:self.m_WebView.title barTintColor:nil leftDicArray:nil rightDicArray:@[ [self bm_makeBarButtonDictionaryWithTitle:nil image:@"navigationbar_more_icon" toucheEvent:@"moreAction" buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:0]]];
}

// 更多按钮
- (void)moreAction
{
    NSDictionary *data = [NSDictionary bm_dictionaryWithJsonString:self.s_CollectJsonSting];
    
    if (![data bm_isNotEmptyDictionary])
    {
        [self.m_ProgressHUD showAnimated:YES withText:@"数据错误" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        return;
    }
    
    // 获取收藏状态
    [self.m_ProgressHUD showAnimated:YES];
    
    BMWeakSelf;
    [FSApiRequest getCollectStateID:[data bm_stringForKey:@"id"] type:[data bm_stringForKey:@"type"] Success:^(id responseObject) {
        
        [weakSelf.m_ProgressHUD hideAnimated:NO];
        NSInteger count = [responseObject integerValue];
        weakSelf.s_isCollect = count>0;
        [FSMoreViewVC showWebMoreDelegate:weakSelf isCollection:weakSelf.s_isCollect hasRefresh:weakSelf.m_IsRefresh];
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - moreAlert

- (void)moreViewClickWithType:(NSInteger)index
{
    if (index < 5)
    {
        if (![self.s_ShareJsonSting bm_isNotEmpty])
        {
            [self.m_ProgressHUD showAnimated:YES withText:@"分享错误" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            return;
        }
        /*f5HM8GUBN3_o1ImUsbSy
         {"title":"中华人民共和国广告法",
         "url":"https://devftlsh5.odrcloud.net/Law/lawDetail?ID=TJDjrGUBN3_o1ImUSqS9&keywords=%E5%90%88%E5%90%8C%E7%BA%A0%E7%BA%B7&a=a",
         "content":"枫调理顺—调解员专属的APP",
         "imgUrl":"https://devres.odrcloud.net/storm-test//51/200/97c7f2c52c3c4038868f8d04d15ae8c1.png",
         "id":"TJDjrGUBN3_o1ImUSqS9",
         "type":"STATUTE"}
         */
        NSDictionary *data = [NSDictionary bm_dictionaryWithJsonString:self.s_ShareJsonSting];
        [FSShareManager shareWebUrlWithTitle:[data bm_stringForKey:@"title"] descr:[data bm_stringForKey:@"content"] thumImage:[data bm_stringForKey:@"imgUrl"] webpageUrl:[data bm_stringForKey:@"url"] platform:index currentVC:self delegate:self];
    }
    else if (index == 5) // 收藏
    {
        if (![FSUserInfoModel isLogin])
        {
            [self showLogin];
            return;
        }

        BMWeakSelf
        NSDictionary *data = [NSDictionary bm_dictionaryWithJsonString:self.s_CollectJsonSting];
        [FSApiRequest updateCollectStateID:[data bm_stringForKey:@"id"] isCollect:!self.s_isCollect guidingCase:[data bm_stringForKey:@"guidingCase"] source:[data bm_stringForKey:@"source"] title:[data bm_stringForKey:@"title"] type:[data bm_stringForKey:@"type"] Success:^(id responseObject) {
            [weakSelf.m_ProgressHUD showAnimated:YES withText:weakSelf.s_isCollect ? @"取消收藏" : @"收藏成功" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            [[NSNotificationCenter defaultCenter]postNotificationName:refreshCollectionNotification object:nil];
        } failure:^(NSError *error) {
            
        }];
    }
    else if (index == 6)
    {
        if (self.m_IsRefresh) // 刷新
        {
            [self.m_WebView reload];
        }
        else // 复制
        {
            if ([self.m_UrlString bm_isNotEmpty])
            {
                [[UIPasteboard generalPasteboard] setString:self.m_UrlString];
                [self.m_ProgressHUD showAnimated:YES withDetailText:@"复制成功" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            }
            else
            {
                [self.m_ProgressHUD showAnimated:YES withDetailText:@"复制失败" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            }
        }
        
    }
}

#pragma mark - 分享成功

- (void)shareDidSucceed:(id)data
{
    NSDictionary *params = [NSDictionary bm_dictionaryWithJsonString:self.s_ShareJsonSting];
    [FSApiRequest addShareCountWithId:[params bm_stringForKey:@"id"] andType:[params bm_stringForKey:@"type"] success:^(id  _Nullable responseObject) {
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - reportAlert
// 举报弹窗
- (void)showReportAlertWithData:(NSString *)jsonString
{
    //{"id":"3","type":"COMMENT","commentPerson":"用户林1","commentContent":"这是0评论内容"}
    NSDictionary *data = [NSDictionary bm_dictionaryWithJsonString:jsonString];
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 225, 70)];
    
    UILabel *cententLab = [[UILabel alloc]initWithFrame:CGRectMake(35/2, 0, 190, 40)];
    cententLab.numberOfLines = 2;
    cententLab.font = [UIFont systemFontOfSize:15.f];
    cententLab.textColor = [UIColor bm_colorWithHex:0x333333];
    NSString *cententString = [NSString stringWithFormat:@"举报了@%@：%@", [data bm_stringForKey:@"commentPerson"], [data bm_stringForKey:@"commentContent"]];
    NSMutableAttributedString *attrubuteStr = [[NSMutableAttributedString alloc]initWithString:cententString];
    [attrubuteStr bm_setTextColor:[UIColor redColor] range:NSMakeRange(3, [data bm_stringForKey:@"commentPerson"].length+1)];
    [attrubuteStr bm_setTextColor:[UIColor bm_colorWithHex:0x999999] range:NSMakeRange(cententString.length - [data bm_stringForKey:@"commentContent"].length, [data bm_stringForKey:@"commentContent"].length)];
    [attrubuteStr bm_setFont:[UIFont systemFontOfSize:13.f] range:NSMakeRange(cententString.length - [data bm_stringForKey:@"commentContent"].length, [data bm_stringForKey:@"commentContent"].length)];
    cententLab.attributedText = attrubuteStr;
    [contentView addSubview:cententLab];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(35/2, cententLab.bm_bottom + 5, 190, 25)];
    textField.backgroundColor = [UIColor bm_colorWithHex:0xf6f6f6];
    textField.placeholder = @"请输入举报理由";
    textField.font = [UIFont systemFontOfSize:14.f];
    [contentView addSubview:textField];
    [textField becomeFirstResponder];
    
    BMWeakSelf
    [FSAlertView showAlertWithTitle:@"举报理由说明" message:nil contentView:contentView cancelTitle:@"取消" otherTitle:@"确定" completion:^(BOOL cancelled, NSInteger buttonIndex) {
        
        BMLog(@"%@", textField.text);
        if (buttonIndex == 1) {
            if (![textField.text bm_isNotEmpty])
            {
                [weakSelf.m_ProgressHUD showAnimated:YES withDetailText:@"请输入举报理由" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                return ;
            }
            [weakSelf addReportContent:textField.text commentId:[data bm_stringForKey:@"id"]];
        }
    }];
}

- (void)addReportContent:(NSString *)content commentId:(NSString *)commentId
{
    BMWeakSelf
    [FSApiRequest addReportTopic:[NSString stringWithFormat:@"%@",commentId] content:content type:@"COMMENT"  success:^(id  responseObject) {
        [weakSelf.m_ProgressHUD showAnimated:YES withDetailText:@"已举报该评论" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    } failure:^(NSError *error) {
        [weakSelf.m_ProgressHUD showAnimated:YES withDetailText:[NSString stringWithFormat:@"%@",[error.userInfo bm_stringForKey:@"NSLocalizedDescription"]] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }];
}

//- (void)showPhoto:(NSString *)photoUrl
//{
//    if (![photoUrl bm_isNotEmpty])
//    {
//        return;
//    }
//
//    s_PhtoUrlStr = photoUrl;
//
//    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
//    //browser.sourceImagesContainerView = self; // 原图的父控件
//    browser.imageCount = 1; // 图片总数
//    browser.currentImageIndex = 0;
//    browser.delegate = self;
//    [browser show];
//}


#pragma mark -
#pragma mark SDPhotoBrowserDelegate

//// 返回临时占位图片（即原来的小图）
//- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
//{
//    UIImage *image = [UIImage imageNamed:@"placeholderimage_260X150"];
//    return image;
//}
//
//// 返回高质量图片的url
//- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
//{
//    return [NSURL URLWithString:s_PhtoUrlStr];
//}


#pragma mark -
#pragma mark FSLoginViewDelegate


#pragma mark -
#pragma mark 界面点击事件

//- (void)navRightBtnClick
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickNavRightBtnWithWebViewController:)])
//    {
//        [self.delegate didClickNavRightBtnWithWebViewController:self];
//    }
//}

#if 0
#pragma mark -
#pragma mark share

//    1 -- 微信好友
//    2 -- 微信朋友圈
//    3 -- QQ好友
//    4 -- 新浪微博
//    5 -- 短信
//    6 -- 邮件
//    7 -- QQ空间
- (NSUInteger)getShareType:(SSDKPlatformType)type
{
    switch (type)
    {
        case SSDKPlatformSubTypeWechatSession:
            return 1;
        case SSDKPlatformSubTypeWechatTimeline:
            return 2;
        case SSDKPlatformSubTypeQQFriend:
            return 3;
        case SSDKPlatformTypeSinaWeibo:
            return 4;
        case SSDKPlatformTypeSMS:
            return 5;
        case SSDKPlatformTypeMail:
            return 6;
        case SSDKPlatformSubTypeQZone:
            return 7;
        default:
            return 0;
    }
    
    return 0;
}

- (void)shareSucceed:(SSDKPlatformType)type
{
    [super shareSucceed:type];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setBool:YES forKey:@"is_success"];
    NSUInteger platformType = [self getShareType:type];
    [parameters setObject:@(platformType) forKey:@"platform"];
    //[self callJsHandler:@"webview.share_log" withData:parameters];
    
    //[self.m_WebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"webview.share_log(%@)", [parameters toJSON]]];
    [self.m_WebView evaluateJavaScript:[NSString stringWithFormat:@"webview.share_log(%@)", [parameters toJSON]] completionHandler:nil];
}

- (void)shareFailedWithError:(NSString *)errorMessage withType:(SSDKPlatformType)type
{
    [super shareFailedWithError:errorMessage withType:type];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setBool:NO forKey:@"is_success"];
    NSUInteger platformType = [self getShareType:type];
    [parameters setObject:@(platformType) forKey:@"platform"];
    //[self callJsHandler:@"share_log" withData:parameters];
    
    //[self.m_WebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"webview.share_log(%@)", [parameters toJSON]]];
    [self.m_WebView evaluateJavaScript:[NSString stringWithFormat:@"webview.share_log(%@)", [parameters toJSON]] completionHandler:nil];
}
#endif

@end
