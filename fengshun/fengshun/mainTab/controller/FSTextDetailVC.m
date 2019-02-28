//
//  FSTextDetailVC.m
//  fengshun
//
//  Created by Aiwei on 2018/9/26.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSTextDetailVC.h"
#import "FSMoreViewVC.h"
#import <MessageUI/MessageUI.h>
#import "NSURL+BMParameters.h"
#import "FSAlertView.h"

@interface FSTextDetailVC ()
<
    FSShareManagerDelegate,
    MFMailComposeViewControllerDelegate
>

@property(nonatomic, assign)BOOL s_isCollect;
@end

@implementation FSTextDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize buttonSize = CGSizeMake(115, 41.0f);
    UIButton *dowloadButton = [[UIButton alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - buttonSize.width, UI_SCREEN_HEIGHT -UI_NAVIGATION_BAR_HEIGHT- UI_STATUS_BAR_HEIGHT -buttonSize.height -45, buttonSize.width, buttonSize.height)];
    dowloadButton.backgroundColor = UI_COLOR_BL1;
    dowloadButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [dowloadButton setImage:[UIImage imageNamed:@"text_dowload"] forState:UIControlStateNormal];
    [dowloadButton setTitle:@"下载范本" forState:UIControlStateNormal];
    [dowloadButton bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:6];
    [dowloadButton addTarget:self action:@selector(downloadFile) forControlEvents:UIControlEventTouchUpInside];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:dowloadButton.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(buttonSize.height/2, buttonSize.height/2)].CGPath;
    [dowloadButton.layer setMask:maskLayer];
    
    [self.view addSubview:dowloadButton];
    
    // 发送邮箱按钮 1.1.2需求
    UIButton *emailButton = [[UIButton alloc]initWithFrame:CGRectMake(dowloadButton.bm_left, dowloadButton.bm_top - buttonSize.height - 20, buttonSize.width, buttonSize.height)];
    emailButton.backgroundColor = UI_COLOR_BL1;
    emailButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [emailButton setImage:[UIImage imageNamed:@"text_dowload"] forState:UIControlStateNormal];
    [emailButton setTitle:@"发送至邮箱" forState:UIControlStateNormal];
    [emailButton bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:6];
    [emailButton addTarget:self action:@selector(sendToEmail) forControlEvents:UIControlEventTouchUpInside];
    CAShapeLayer *maskLayer1 = [CAShapeLayer layer];
    maskLayer1.path = [UIBezierPath bezierPathWithRoundedRect:emailButton.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(buttonSize.height/2, buttonSize.height/2)].CGPath;
    [emailButton.layer setMask:maskLayer1];
    [self.view addSubview:emailButton];
    [self addRightBtn];
    [self bringSomeViewToFront];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 添加更多按钮
- (void)addRightBtn
{
    [self setNavWithTitle:@"文书范本" leftArray:nil rightArray:@[ [self bm_makeBarButtonDictionaryWithTitle:nil image:@"navigationbar_more_icon" toucheEvent:@"moreAction" buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:0]]];
}
// 更多按钮
- (void)moreAction
{
    //获取收藏状态
    [self.m_ProgressHUD showAnimated:YES];
    BMWeakSelf;
    [FSApiRequest getCollectStateID:self.m_docummentId type:@"DOCUMENT" Success:^(id  _Nullable responseObject) {
        [weakSelf.m_ProgressHUD hideAnimated:NO];
        NSInteger count = [responseObject integerValue];
        weakSelf.s_isCollect = count>0;
        [FSMoreViewVC showWebMoreDelegate:weakSelf isCollection:weakSelf.s_isCollect hasRefresh:YES];
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark - moreAlert
- (void)shareDidSucceed:(id)data
{
    [FSApiRequest addShareCountWithId:_m_docummentId andType:@"DOCUMENT" success:nil failure:nil];
}
- (void)moreViewClickWithType:(NSInteger)index
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@", FS_URL_SERVER, FS_FILE_ADDRESS, _m_fileId];
    url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (index < 5)
    {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:[NSString stringWithFormat:@"%@",url] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        BMWeakSelf
        [self.m_ProgressHUD showAnimated:YES];
        [FSApiRequest getShareContent:_m_docummentId type:@"DOCUMENT" success:^(id  _Nullable responseObject) {
            [weakSelf.m_ProgressHUD hideAnimated:YES];
            /*
             {
             "content": "string",
             "imgUrl": "string",
             "title": "string",
             "url": "string"
             }
             */
            [FSShareManager shareWebUrlWithTitle:[responseObject bm_stringForKey:@"title"] descr:[responseObject bm_stringForKey:@"content"] thumImage:[responseObject bm_stringForKey:@"imgUrl"] webpageUrl:[responseObject bm_stringForKey:@"url"]?:url platform:index currentVC:weakSelf delegate:nil];
        } failure:nil];
    }
    else if (index == 5)//收藏
    {

        if (![FSUserInfoModel isLogin])
        {
            [self showLogin];
            return;
        }
        BMWeakSelf
        [FSApiRequest updateCollectStateID:self.m_docummentId isCollect:!weakSelf.s_isCollect guidingCase:@"" source:@"" title:@"" type:@"DOCUMENT" Success:^(id  _Nullable responseObject) {
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES withText:weakSelf.s_isCollect?@"取消收藏":@"收藏成功" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            [[NSNotificationCenter defaultCenter]postNotificationName:refreshCollectionNotification object:nil];
        } failure:^(NSError * _Nullable error) {
            
        }];
    }
    else if (index == 6)//刷新
    {
        [self refreshWebView];
    }
}

- (void)downloadFile
{
    if ([_m_fileId bm_isNotEmpty]) {
        NSString *url = [NSString stringWithFormat:@"%@%@%@", FS_URL_SERVER, FS_FILE_ADDRESS, _m_fileId];
        url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:url]];
    }
}

- (void)sendToEmail
{
    if (![MFMailComposeViewController canSendMail])
    {
        BMWeakSelf
        [FSAlertView showAlertWithTitle:@"提示" message:@"您还未配置邮箱账户，是否现在跳转配置？" cancelTitle:@"取消" otherTitle:@"确定" completion:^(BOOL cancelled, NSInteger buttonIndex) {
            if (buttonIndex == 1 )
            {
                [weakSelf jumpToEmailAPP];
            }
        }];
        return;
    }
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc]init];
    // 设置picker的委托方法，完成之后会自动调用成功或失败的方法
    picker.mailComposeDelegate = self;
    /* 发送doc文本附件src */
    NSData *myData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.m_UrlString]];
    [picker addAttachmentData:myData mimeType:@"application/msword" fileName:@"文书范本.docx"];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *alertString = @"";
    switch (result)
    {
        case MFMailComposeResultCancelled:
            alertString = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            alertString = @"邮件保存成功";
            break;
        case MFMailComposeResultSent:
            alertString = @"邮件发送成功";
            break;
        case MFMailComposeResultFailed:
            alertString = @"邮件发送失败";
            break;
        default:
            alertString = @"邮件未发送";
            break;
    }
    [self.m_ProgressHUD showAnimated:YES withText:alertString delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)jumpToEmailAPP
{
    NSURL *url = [NSURL URLWithString:@"mailto://"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        [self.m_ProgressHUD showAnimated:YES withText:@"未安装邮件应用" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }
}

@end
