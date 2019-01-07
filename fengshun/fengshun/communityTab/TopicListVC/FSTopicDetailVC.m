//
//  FSTopicDetailVC.m
//  fengshun
//
//  Created by best2wa on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSTopicDetailVC.h"
#import "FSMoreViewVC.h"
#import "FSAlertView.h"
#import "FSPushVCManager.h"
#import "FSReportView.h"
#import "FSCommunityModel.h"
#import "NSDictionary+BMCategory.h"
#import "FSAuthVC.h"

@interface FSTopicDetailVC ()
<
    FSMoreViewVCDelegate,
    FSReportViewDelegate,
    FSShareManagerDelegate
>

@property (nonatomic, assign) NSInteger m_TopicId;
// 帖子详情model
@property (nonatomic, strong) FSTopicDetailModel *m_TopicDetailModel;

@end

@implementation FSTopicDetailVC

- (instancetype)initWithTitle:(NSString *)title url:(NSString *)url showLoadingBar:(BOOL)showLoadingBar loadingBarColor:(UIColor *)color delegate:(id <FSWebViewControllerDelegate>)delegate topicId:(NSInteger)topicId
{
    if (self = [super initWithTitle:title url:url showLoadingBar:showLoadingBar loadingBarColor:color delegate:delegate])
    {
        self.m_TopicId = topicId;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavWithTitle:@"" leftArray:nil rightArray:@[ [self bm_makeBarButtonDictionaryWithTitle:nil image:@"navigationbar_more_icon" toucheEvent:@"moreAction" buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:0]]];
    
    [self bringSomeViewToFront];
    
    // 1.1需求 添加完善资料功能，是否有昵称，是否认证
    BMWeakSelf
    [self registerHander:@"toAuth" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *resultDic = [NSDictionary bm_dictionaryWithJsonString:[NSString stringWithFormat:@"%@",data]];
        FSAuthVC *vc = [FSAuthVC vcWithAuthType:[resultDic bm_intForKey:@"type"]];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 更多弹窗按钮
- (void)moreAction
{
    [self.m_ProgressHUD showAnimated:YES];
    
    BMWeakSelf
    [FSApiRequest getTopicDetail:self.m_TopicId success:^(id responseObject) {
        
        [weakSelf.m_ProgressHUD hideAnimated:NO];
        weakSelf.m_TopicDetailModel = [FSTopicDetailModel topicDetailModelWithDic:responseObject];
        if (weakSelf.m_TopicDetailModel == nil)
        {
            return;
        }
        // 根据帖子详情接口 userId判断是否是本人帖子
        BOOL isOwner = [weakSelf.m_TopicDetailModel.m_UserId isEqualToString:[FSUserInfoModel userInfo].m_UserBaseInfo.m_UserId];
        [FSMoreViewVC showMoreDelegate:weakSelf isOwner:isOwner isCollection:weakSelf.m_TopicDetailModel.m_IsCollection];
    } failure:^(NSError *error) {
        
    }];
}

- (void)moreViewClickWithType:(NSInteger)index
{
    BMLog(@"%@", @(index));
    
    switch (index)
    {
        case 0:  //微信
        case 1:  //朋友圈
        case 2:  //QQ
        case 3:  //QQ空间
        case 4:  //微博
        {
            BMWeakSelf
            [self.m_ProgressHUD showAnimated:YES];
            [FSApiRequest getShareContent:[NSString stringWithFormat:@"%@",@(self.m_TopicId)] type:@"POSTS" success:^(id  _Nullable responseObject) {
                [weakSelf.m_ProgressHUD hideAnimated:YES];
                /*
                 {
                     "content": "string",
                     "imgUrl": "string",
                     "title": "string",
                     "url": "string"
                 }
                 */
                [FSShareManager shareWebUrlWithTitle:[responseObject bm_stringForKey:@"title"] descr:[responseObject bm_stringForKey:@"content"] thumImage:[responseObject bm_stringForKey:@"imgUrl"] webpageUrl:[responseObject bm_stringForKey:@"url"]?:weakSelf.m_UrlString platform:index currentVC:weakSelf delegate:weakSelf];
            } failure:^(NSError * _Nullable error) {
                
            }];
        }
            break;
        case 5:  //收藏
        {
            if (![FSUserInfoModel isLogin])
            {
                [self showLogin];
                return;
            }
            [self collectionTopic];
        }
            break;
        case 6:  //复制
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
            break;
        case 7:  //举报弹窗
        {
            if (![FSUserInfoModel isLogin])
            {
                [self showLogin];
                return;
            }
            [FSReportView showReportView:self];
        }
            break;
        case 8:  //编辑
        {
            BMWeakSelf
            [FSAlertView showAlertWithTitle:@"编辑帖子"
                                    message:@"您确定要编辑您的帖子？"
                                cancelTitle:@"取消"
                                 otherTitle:@"确定"
                                 completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                     
                                     if (buttonIndex == 1)
                                     {
                                         [FSPushVCManager showSendPostWithPushVC:weakSelf
                                                                        isEdited:YES
                                                                       relatedId:weakSelf.m_TopicId
                                                                        callBack:^{
                                                                            [weakSelf refreshWebView];
                                                                            
                                                                            [[NSNotificationCenter defaultCenter] postNotificationName:freshTopicNotification object:nil userInfo:@{@"topicId" : @(self.m_TopicId)}];
                                                                        }];
                                     }
                                 }];
        }
            break;
        case 9:  //删除
        {
            BMWeakSelf
            [FSAlertView showAlertWithTitle:@"删除帖子"
                                    message:@"您确定要删除您的帖子？"
                                cancelTitle:@"取消"
                                 otherTitle:@"确定"
                                 completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                     
                                     if (buttonIndex == 1)
                                     {
                                         [weakSelf deleteTopic];
                                         
                                         [[NSNotificationCenter defaultCenter] postNotificationName:deleteTopicNotification object:nil userInfo:@{@"topicId" : @(self.m_TopicId)}];
                                     }
                                 }];
        }
            break;

        default:
            break;
    }
}

// 分享成功
- (void)shareDidSucceed:(id)data
{
    [FSApiRequest addShareCountWithId:[NSString stringWithFormat:@"%@",@(self.m_TopicId)] andType:@"POSTS" success:^(id  _Nullable responseObject) {
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}

// 举报按钮点击
- (void)alertViewClick:(FSReportView *)aView index:(NSInteger)index
{
    if (index == 0)// 举报
    {
        [aView removeFromSuperview];
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 225, 70)];
        
        UILabel *cententLab = [[UILabel alloc]initWithFrame:CGRectMake(35*0.5f, 0, 190, 40)];
        cententLab.numberOfLines = 2;
        cententLab.font = [UIFont systemFontOfSize:15.f];
        cententLab.textColor = [UIColor bm_colorWithHex:0x333333];
        cententLab.text = self.m_TopicDetailModel.m_Title;
        [contentView addSubview:cententLab];
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(35*0.5f, cententLab.bm_bottom + 5, 190, 25)];
        textField.backgroundColor = [UIColor bm_colorWithHex:0xF6F6F6];
        textField.placeholder = @"请输入举报理由";
        textField.font = [UIFont systemFontOfSize:14.f];
        [contentView addSubview:textField];
        [textField becomeFirstResponder];
        
        BMWeakSelf
        [FSAlertView showAlertWithTitle:@"举报理由说明" message:nil contentView:contentView cancelTitle:@"取消" otherTitle:@"确定" completion:^(BOOL cancelled, NSInteger buttonIndex) {
            
            BMLog(@"%@", textField.text);
            if (buttonIndex == 1)
            {
                if (![textField.text bm_isNotEmpty])
                {
                    [weakSelf.m_ProgressHUD showAnimated:YES withDetailText:@"请输入举报理由" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                }
                [weakSelf addReportContent:textField.text];
            }
        }];
    }
}


#pragma mark - Request

- (void)deleteTopic
{
    BMWeakSelf
    [FSApiRequest deleteTopicWithId:self.m_TopicId success:^(id responseObject) {
        [weakSelf.m_ProgressHUD showAnimated:YES withDetailText:@"删除成功" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
}

- (void)collectionTopic
{
    BMWeakSelf
    [FSApiRequest collectionTopic:!self.m_TopicDetailModel.m_IsCollection topicId:[NSString stringWithFormat:@"%@", @(self.m_TopicId)] success:^(id responseObject) {
        
        [weakSelf.m_ProgressHUD showAnimated:YES withDetailText:weakSelf.m_TopicDetailModel.m_IsCollection ? @"取消收藏成功" : @"收藏成功" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        [[NSNotificationCenter defaultCenter]postNotificationName:refreshCollectionNotification object:nil userInfo:nil];
    } failure:^(NSError * _Nullable error) {
        
    }];
}

- (void)addReportContent:(NSString *)content
{
    BMWeakSelf
    [FSApiRequest addReportTopic:[NSString stringWithFormat:@"%@", @(self.m_TopicId)]  content:content type:@"POSTS"  success:^(id responseObject) {
       [weakSelf.m_ProgressHUD showAnimated:YES withDetailText:@"已举报该帖子" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    } failure:^(NSError *error) {
        
    }];
}

@end
