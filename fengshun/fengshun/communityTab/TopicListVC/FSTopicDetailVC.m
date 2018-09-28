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

@interface
FSTopicDetailVC ()
<
FSMoreViewVCDelegate,
FSReportViewDelegate
>

@property (nonatomic, assign) NSInteger m_TopicId;
// 帖子详情model
@property (nonatomic, strong) FSTopicDetailModel *m_TopicDetailModel;

@end

@implementation FSTopicDetailVC


- (instancetype)initWithTitle:(NSString *)title url:(NSString *)url showLoadingBar:(BOOL)showLoadingBar loadingBarColor:(nullable UIColor *)color delegate:(nullable id<FSWebViewControllerDelegate>)delegate topicId:(NSInteger)topicId
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

    [self bm_setNavigationWithTitle:@"" barTintColor:nil leftDicArray:nil rightDicArray:@[ [self bm_makeBarButtonDictionaryWithTitle:@" " image:@"community_more" toucheEvent:@"moreAction" buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:0]]];
    
    [self bringSomeViewToFront];
    
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
    [FSApiRequest getTopicDetail:self.m_TopicId success:^(id  _Nullable responseObject) {
        [self.m_ProgressHUD hideAnimated:NO];
        self.m_TopicDetailModel = [FSTopicDetailModel topicDetailModelWithDic:responseObject];
        if (self.m_TopicDetailModel == nil)
        {
            return ;
        }
        // 根据帖子详情接口 userId判断是否是本人帖子
        BOOL isOwner = [self.m_TopicDetailModel.m_UserId isEqualToString:[FSUserInfoModel userInfo].m_UserBaseInfo.m_UserId];
        [FSMoreViewVC showMore:self delegate:self isOwner:isOwner isCollection:self.m_TopicDetailModel.m_IsCollection];
    } failure:^(NSError * _Nullable error) {
        
    }];
}

- (void)moreViewClickWithType:(NSInteger)index
{
    BMLog(@"%ld", index);
    BMWeakSelf;
    switch (index)
    {
        case 0:  //微信
        case 1:  //朋友圈
        case 2:  //QQ
        case 3:  //QQ空间
        case 4:  //微博
        {
            [self.m_ProgressHUD showAnimated:YES withDetailText:[NSString stringWithFormat:@"分享:%ld",index] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
            break;
        case 5:  //收藏
        {
            if (![FSUserInfoModel isLogin]) {
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
            if (![FSUserInfoModel isLogin]) {
                [self showLogin];
                return;
            }
            [FSReportView showReportView:self];
        }
            break;
        case 8:  //编辑
        {
            [FSAlertView showAlertWithTitle:@"编辑帖子"
                                    message:@"您确定要编辑您的帖子？"
                                cancelTitle:@"取消"
                                 otherTitle:@"确定"
                                 completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                     if (buttonIndex == 1)
                                     {
                                         [FSPushVCManager showSendPostWithPushVC:self
                                                                        isEdited:YES
                                                                       relatedId:self.m_TopicId
                                                                        callBack:^{
                                                                            [weakSelf refreshWebView];
                                                                        }];
                                     }
                                 }];
        }
            break;
        case 9:  //删除
        {
            [FSAlertView showAlertWithTitle:@"删除帖子"
                                    message:@"您确定要删除您的帖子？"
                                cancelTitle:@"取消"
                                 otherTitle:@"确定"
                                 completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                     if (buttonIndex == 1)
                                     {
                                         [weakSelf deleteTopic];
                                     }
                                 }];
        }
            break;

        default:
            break;
    }
}

// 举报按钮点击
- (void)alertViewClick:(FSReportView *)aView index:(NSInteger)index
{
    if (index == 0)// 举报
    {
        [aView removeFromSuperview];
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 225, 70)];
        
        UILabel *cententLab = [[UILabel alloc]initWithFrame:CGRectMake(35/2, 0, 190, 40)];
        cententLab.numberOfLines = 2;
        cententLab.font = [UIFont systemFontOfSize:15.f];
        cententLab.textColor = [UIColor bm_colorWithHex:0x333333];
        cententLab.text = self.m_TopicDetailModel.m_Title;
        [contentView addSubview:cententLab];
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(35/2, cententLab.bm_bottom + 5, 190, 25)];
        textField.backgroundColor = [UIColor bm_colorWithHex:0xF6F6F6];
        textField.placeholder = @"请输入举报理由";
        textField.font = [UIFont systemFontOfSize:14.f];
        [contentView addSubview:textField];
        [textField becomeFirstResponder];
        BMWeakSelf;
        [FSAlertView showAlertWithTitle:@"举报理由说明" message:nil contentView:contentView cancelTitle:@"取消" otherTitle:@"确定" completion:^(BOOL cancelled, NSInteger buttonIndex) {
            BMLog(@"%@",textField.text);
            if (buttonIndex == 1) {
                if (![textField.text bm_isNotEmpty])
                {
                    [self.m_ProgressHUD showAnimated:YES withDetailText:@"请输入举报理由" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
                }
                [weakSelf addReportContent:textField.text];
            }
        }];
    }
}

#pragma mark - Request

- (void)deleteTopic
{
    [FSApiRequest deleteTopicWithId:self.m_TopicId success:^(id _Nullable responseObject){
//        if (self.m_DeleteTopicBlock) {
//            self.m_DeleteTopicBlock();
//        }
        [self.m_ProgressHUD showAnimated:YES withDetailText:@"删除成功" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *_Nullable error){
        
    }];
}

- (void)collectionTopic{
    [FSApiRequest collectionTopic:!self.m_TopicDetailModel.m_IsCollection topicId:[NSString stringWithFormat:@"%ld",self.m_TopicId] success:^(id  _Nullable responseObject) {
        [self.m_ProgressHUD showAnimated:YES withDetailText:self.m_TopicDetailModel.m_IsCollection?@"取消收藏成功":@"收藏成功" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    } failure:^(NSError * _Nullable error) {
        
    }];
}

- (void)addReportContent:(NSString *)content
{
    [FSApiRequest addReportTopic:[NSString stringWithFormat:@"%ld",self.m_TopicId] content:content success:^(id  _Nullable responseObject) {
       [self.m_ProgressHUD showAnimated:YES withDetailText:@"已举报该帖子" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    } failure:^(NSError * _Nullable error) {
        
    }];
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
