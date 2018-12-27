//
//  FSNoticeMessagesDetailVC.m
//  fengshun
//
//  Created by Aiwei on 2018/12/24.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSNoticeMessagesDetailVC.h"
#import "FSMessage.h"

@interface FSNoticeMessagesDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *m_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_signatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_dateLabel;
@property (nonatomic, strong)FSNoticeDetailModel *m_model;

@end

@implementation FSNoticeMessagesDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bm_setNavigationWithTitle:@"消息详情" barTintColor:nil leftItemTitle:@"" leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    [self updateUIWithModel];
    [self loadApiData];
}
- (void)updateUIWithModel
{
    _m_titleLabel.text = _m_model.m_Title;
    _m_contentLabel.text = _m_model.m_Content;
    _m_signatureLabel.text = _m_model.m_signature;
    _m_dateLabel.text = _m_model?[[NSDate dateWithTimeIntervalSince1970:_m_model.m_CreateTime] bm_stringWithFormat:@"yyyy-MM-dd"]:nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableURLRequest *)setLoadDataRequest
{
    if (![_m_NoticeMessagesId bm_isNotEmpty]) {
        return nil;
    }
    return [FSApiRequest getUserNoticeMessageDetailWithId:_m_NoticeMessagesId];
}
- (BOOL) succeedLoadedRequestWithDic:(NSDictionary *)requestDic
{
    if ([requestDic bm_isNotEmpty]) {
        self.m_model = [FSNoticeDetailModel noticeMessageModelWithServerDic:requestDic];
        [self updateUIWithModel];
    }
    return YES;
}
@end
