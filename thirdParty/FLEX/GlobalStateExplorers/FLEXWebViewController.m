//
//  FLEXWebViewController.m
//  Flipboard
//
//  Created by Ryan Olson on 6/10/14.
//  Copyright (c) 2014 Flipboard. All rights reserved.
//

#import "FLEXWebViewController.h"
#import "FLEXUtility.h"

@interface FLEXWebViewController () <UIWebViewDelegate, UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *originalText;

#if FLEX_BM
@property (nonatomic, strong) NSString *filePath;

@property (nonatomic, strong) UIDocumentInteractionController *document;
#endif

@end

@implementation FLEXWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.webView = [[UIWebView alloc] init];
        self.webView.delegate = self;
        self.webView.dataDetectorTypes = UIDataDetectorTypeLink;
        self.webView.scalesPageToFit = YES;
    }
    return self;
}

- (id)initWithText:(NSString *)text
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.originalText = text;
        NSString *htmlString = [NSString stringWithFormat:@"<head><meta name='viewport' content='initial-scale=1.0'></head><body><pre>%@</pre></body>", [FLEXUtility stringByEscapingHTMLEntitiesInString:text]];
        [self.webView loadHTMLString:htmlString baseURL:nil];
    }
    return self;
}

#if FLEX_BM
- (id)initWithText:(NSString *)text filePath:(NSString *)filePath
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.originalText = text;
        self.filePath = filePath;
        NSString *htmlString = [NSString stringWithFormat:@"<head><meta name='viewport' content='initial-scale=1.0'></head><body><pre>%@</pre></body>", [FLEXUtility stringByEscapingHTMLEntitiesInString:text]];
        [self.webView loadHTMLString:htmlString baseURL:nil];
    }
    return self;
}
#endif

- (id)initWithURL:(NSURL *)url
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    return self;
}

- (void)dealloc
{
    // UIWebView's delegate is assign so we need to clear it manually.
    if (_webView.delegate == self) {
        _webView.delegate = nil;
    }
    
#if FLEX_BM
    self.document.delegate = nil;
#endif
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    self.webView.frame = self.view.bounds;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
#if FLEX_BM
    NSMutableArray *itemArray = [[NSMutableArray alloc] initWithCapacity:0];
    if ([self.originalText length] > 0) {
        //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Copy" style:UIBarButtonItemStylePlain target:self action:@selector(copyButtonTapped:)];
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Copy" style:UIBarButtonItemStylePlain target:self action:@selector(copyButtonTapped:)];
        [itemArray addObject:buttonItem];
    }
    if ([self.filePath length] > 0) {
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonTapped:)];
        [itemArray addObject:buttonItem];
    }
    
    self.navigationItem.rightBarButtonItems = itemArray;
#else
    if ([self.originalText length] > 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Copy" style:UIBarButtonItemStylePlain target:self action:@selector(copyButtonTapped:)];
    }
#endif
}

- (void)copyButtonTapped:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.originalText];
}

#if FLEX_BM
- (void)shareButtonTapped:(id)sender
{
    NSURL *url = [NSURL fileURLWithPath:self.filePath];
    self.document = [UIDocumentInteractionController interactionControllerWithURL:url];
    self.document.delegate = self;
    
    // 不展示可选操作
    //    [self.document presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
    
    
    // 展示可选操作
    // 可结合代理方法documentInteractionControllerViewControllerForPreview:显示预览
    [self.document presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
}
#endif


#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL shouldStart = NO;
    if (navigationType == UIWebViewNavigationTypeOther) {
        // Allow the initial load
        shouldStart = YES;
    } else {
        // For clicked links, push another web view controller onto the navigation stack so that hitting the back button works as expected.
        // Don't allow the current web view do handle the navigation.
        FLEXWebViewController *webVC = [[[self class] alloc] initWithURL:[request URL]];
        webVC.title = [[request URL] absoluteString];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    return shouldStart;
}


#if FLEX_BM
#pragma mark - UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

/**
 *  文件分享面板退出时调用
 */
- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
    NSLog(@"dismiss");
}

/**
 *  文件分享面板弹出的时候调用
 */
- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller
{
    NSLog(@"WillPresentOpenInMenu");
}

/**
 *  当选择一个文件分享App的时候调用
 */
- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(nullable NSString *)application
{
    NSLog(@"begin send : %@", application);
}
#endif


#pragma mark - Class Helpers

+ (BOOL)supportsPathExtension:(NSString *)extension
{
    BOOL supported = NO;
    NSSet<NSString *> *supportedExtensions = [self webViewSupportedPathExtensions];
    if ([supportedExtensions containsObject:[extension lowercaseString]]) {
        supported = YES;
    }
    return supported;
}

+ (NSSet<NSString *> *)webViewSupportedPathExtensions
{
    static NSSet<NSString *> *pathExtenstions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Note that this is not exhaustive, but all these extensions should work well in the web view.
        // See https://developer.apple.com/library/ios/documentation/AppleApplications/Reference/SafariWebContent/CreatingContentforSafarioniPhone/CreatingContentforSafarioniPhone.html#//apple_ref/doc/uid/TP40006482-SW7
        pathExtenstions = [NSSet<NSString *> setWithArray:@[@"jpg", @"jpeg", @"png", @"gif", @"pdf", @"svg", @"tiff", @"3gp", @"3gpp", @"3g2",
                                                            @"3gp2", @"aiff", @"aif", @"aifc", @"cdda", @"amr", @"mp3", @"swa", @"mp4", @"mpeg",
                                                            @"mpg", @"mp3", @"wav", @"bwf", @"m4a", @"m4b", @"m4p", @"mov", @"qt", @"mqv", @"m4v"]];
        
    });
    return pathExtenstions;
}

@end
