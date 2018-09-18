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

@interface
FSTopicDetailVC () <FSMoreViewVCDelegate>
{
    BOOL _isCollection;// 用户是否收藏
}
@property (nonatomic, assign) NSInteger m_TopicId;

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

    [self bm_setNavigationWithTitle:@"" barTintColor:nil leftDicArray:nil rightDicArray:@[ [self bm_makeBarButtonDictionaryWithTitle:@" " image:@"community_more" toucheEvent:@"shareAction" buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:0] ]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 更多弹窗按钮
- (void)shareAction
{
    
    [FSApiRequest getTopicDetail:self.m_TopicId success:^(id  _Nullable responseObject) {
        // 根据帖子详情接口 userId判断是否是本人帖子
        BOOL isOwner = [[responseObject bm_stringForKey:@"userId"] isEqualToString:[FSUserInfoModle userInfo].m_UserBaseInfo.m_UserId];
        _isCollection = !([responseObject bm_intForKey:@"collection"] == 0);
        [FSMoreViewVC showMore:self delegate:self isOwner:isOwner isCollection:_isCollection];
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
        {
        }
        break;
        case 1:  //朋友圈
        {
        }
        break;
        case 2:  //QQ
        {
        }
        break;
        case 3:  //QQ空间
        {
        }
        break;
        case 4:  //微博
        {
        }
        break;
        case 5:  //收藏
        {
            [self collectionTopic];
        }
        break;
        case 6:  //复制
        {
            [[UIPasteboard generalPasteboard] setString:self.m_UrlString];
            [self.m_ProgressHUD showAnimated:YES withDetailText:@"复制成功" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
        break;
        case 7:  //举报
        {
        }
        break;
        case 8:  //编辑
        {
            [FSAlertView showAlertWithTitle:@"编辑帖子"
                                    message:@"您确定要编辑您的帖子？"
                                cancelTitle:@"取消"
                                 otherTitle:@"确定"
                                 completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                     if (!cancelled)
                                     {
                                         [FSPushVCManager showSendPostWithPushVC:self
                                                                        isEdited:YES
                                                                       relatedId:self.m_TopicId
                                                                        callBack:^(id object){

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
                                     if (!cancelled)
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

#pragma mark - Request

- (void)deleteTopic
{
    [FSApiRequest deleteTopicWithId:self.m_TopicId success:^(id _Nullable responseObject){
        [self.m_ProgressHUD showAnimated:YES withDetailText:@"删除成功" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *_Nullable error){

    }];
}

- (void)collectionTopic{
    [FSApiRequest collectionTopic:!_isCollection topicId:[NSString stringWithFormat:@"%ld",self.m_TopicId] success:^(id  _Nullable responseObject) {
        [self.m_ProgressHUD showAnimated:YES withDetailText:_isCollection?@"取消收藏成功":@"收藏成功" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
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
