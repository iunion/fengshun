//
//  WebViewVC.m
//  fengshun
//
//  Created by Aiwei on 2018/9/20.
//  Copyright © 2018 FS. All rights reserved.
//

#import "WebViewVC.h"
#import "FSAPIMacros.h"

@interface WebViewVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlString = [NSString stringWithFormat:@"%@/course?Ctype=\"IOS\"",FS_H5_SERVER];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlString = @"https://devftlsh5.odrcloud.net/caseDetail?ID=h5HM8GUBN3_o1ImUsbSy&keywords=%5B%22%E7%A6%BB%E5%A9%9A%22%5D";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
    [_webView loadRequest:request];
    _webView.delegate = self;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    BMLog(@"webview load:%@",urlString);
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
