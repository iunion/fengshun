//
//  FSServiceVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSServiceVC.h"
//#import "FSAlertView.h"

@interface FSServiceVC ()

@property (weak, nonatomic) IBOutlet UIView *m_BgView;

@property (weak, nonatomic) IBOutlet UIImageView *m_QQIcon;
@property (weak, nonatomic) IBOutlet UILabel *m_QQLabel;
@property (weak, nonatomic) IBOutlet UIButton *m_QQBtn;

@property (weak, nonatomic) IBOutlet UIImageView *m_WechatIcon;
@property (weak, nonatomic) IBOutlet UILabel *m_WechatLabel;
@property (weak, nonatomic) IBOutlet UIButton *m_WechatBtn;

- (IBAction)openQQ:(UIButton *)btn;
- (IBAction)openWechat:(UIButton *)btn;


@property (nonatomic, strong) NSString *m_QQNumber;
@property (nonatomic, strong) NSString *m_WechatNumber;

@end

@implementation FSServiceVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = FS_VIEW_BGCOLOR;
    self.m_TableView.bounces = YES;
    
    [self bm_setNavigationWithTitle:@"联系客服" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    
    [self interfaceSettings];
}

- (BOOL)needKeyboardEvent
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)interfaceSettings
{
    [super interfaceSettings];
    
    self.m_QQLabel.textColor = UI_COLOR_B4;
    self.m_WechatLabel.textColor = UI_COLOR_B4;
    
    self.m_QQBtn.backgroundColor = UI_COLOR_B5;
    //self.m_QQBtn.enabled = NO;
    [self.m_QQBtn bm_roundedRect:4.0f];
    self.m_QQBtn.exclusiveTouch = YES;
    
    self.m_WechatBtn.backgroundColor = UI_COLOR_B5;
    //self.m_WechatBtn.enabled = NO;
    [self.m_WechatBtn bm_roundedRect:4.0f];
    self.m_WechatBtn.exclusiveTouch = YES;
    
    [self.m_BgView bm_bringToFront];
    [self bringSomeViewToFront];

    [self loadApiData];
}

- (void)freshViews
{
    if ([self.m_QQNumber bm_isNotEmpty])
    {
        self.m_QQBtn.backgroundColor = UI_COLOR_BL1;
        self.m_QQBtn.enabled = YES;
    }

    if ([self.m_WechatNumber bm_isNotEmpty])
    {
        self.m_WechatBtn.backgroundColor = UI_COLOR_BL1;
        self.m_WechatBtn.enabled = YES;
    }
}

- (NSMutableURLRequest *)setLoadDataRequest
{
    NSMutableURLRequest *request = [FSApiRequest getCustomerService];
    return request;
}

- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)requestDic
{
    self.m_QQNumber = [requestDic bm_stringTrimForKey:@"qqNumber"];
    self.m_WechatNumber = [requestDic bm_stringTrimForKey:@"wechatNumber"];
    
    if ([self.m_QQNumber bm_isNotEmpty] || [self.m_WechatNumber bm_isNotEmpty])
    {
        [self freshViews];
        return YES;
    }
    
    return NO;
}

- (IBAction)openQQ:(UIButton *)btn
{
    NSLog(@"openQQ");
    [[UIPasteboard generalPasteboard] setString:self.m_QQNumber];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mqqapi://"]];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        [self.m_ProgressHUD showAnimated:YES withText:@"您已成功复制QQ号，去添加客服QQ号联系她们吧" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }
}

- (IBAction)openWechat:(UIButton *)btn
{
    NSLog(@"openWechat");
    [[UIPasteboard generalPasteboard] setString:self.m_WechatNumber];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"weixin://"]];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        [self.m_ProgressHUD showAnimated:YES withText:@"您已成功复制微信号，去添加微信号联系客服们吧" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }
}


@end
