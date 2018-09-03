//
//  FSWKWebViewController.h
//  miaoqian
//
//  Created by DJ on 2017/7/20.
//  Copyright © 2017年 MiaoQian. All rights reserved.
//

#import "FSSuperNetVC.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FSWebViewControllerDelegate;

@interface FSWebViewController : FSSuperNetVC

@property (nullable, nonatomic, strong) NSString *m_Title;

@property (nullable, nonatomic, copy) NSString *m_UrlString;
@property (nullable, nonatomic, strong) NSDictionary *m_RequestParam;

@property (nullable, nonatomic, weak) id<FSWebViewControllerDelegate> delegate;


// 是否是post请求
@property (nonatomic, assign) BOOL m_IsPost;

// 刷新title，Default value is YES.
@property (nonatomic, assign) BOOL m_ShowPageTitles;

// 是否不显示左上角x按钮
@property (nonatomic, assign) BOOL m_IsNotShowCloseBtn;

- (instancetype)initWithTitle:(nullable NSString *)title url:(nullable NSString *)url;
- (instancetype)initWithTitle:(nullable NSString *)title url:(nullable NSString *)url showLoadingBar:(BOOL)showLoadingBar loadingBarColor:(nullable UIColor *)color;
- (instancetype)initWithTitle:(nullable NSString *)title url:(nullable NSString *)url showLoadingBar:(BOOL)showLoadingBar loadingBarColor:(nullable UIColor *)color delegate:(nullable id<FSWebViewControllerDelegate>)delegate;

- (instancetype)initWithTitle:(nullable NSString *)title url:(nullable NSString *)url requestParam:(nullable NSDictionary *)requestParam showLoadingBar:(BOOL)showLoadingBar loadingBarColor:(nullable UIColor *)color delegate:(nullable id<FSWebViewControllerDelegate>)delegate;

// 调用js函数
- (void)callJsHandler:(NSString *)jsFunc withData:(id)data;

@end

@protocol FSWebViewControllerDelegate <NSObject>

@optional
- (void)webView:(FSWebViewController *)webVC didClickNavRightBtnWithIndex:(NSUInteger)index;

- (void)webViewWillClose:(FSWebViewController *)webVC;

@end

NS_ASSUME_NONNULL_END
