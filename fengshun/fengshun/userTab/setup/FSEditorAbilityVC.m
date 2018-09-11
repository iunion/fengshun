//
//  FSEditorAbilityVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/7.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSEditorAbilityVC.h"
#import "AppDelegate.h"

@interface FSEditorAbilityVC ()

@property (nonatomic, strong) BMTableViewSection *m_Section;

@property (nonatomic, strong) NSURLSessionDataTask *m_AbilityTask;

@property (nonatomic, strong) NSString *m_Ability;

@end

@implementation FSEditorAbilityVC

- (void)dealloc
{
    [_m_AbilityTask cancel];
    _m_AbilityTask = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = FS_VIEW_BGCOLOR;
    self.m_TableView.bounces = YES;
    
    [self bm_setNavigationWithTitle:@"擅长领域" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:@"保存" rightItemImage:nil rightToucheEvent:@selector(updateClicked:)];
    
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
    
    self.m_Section = [BMTableViewSection section];
    
    BMWeakSelf
    
    BMCombineItem *item1 = [[BMCombineItem alloc] initWithTitle:@"法律" itemArray:@[@"以上信息", @"严格保密", @"认证使用", @"严格保密", @"认证使用", @"严格保密", @"认证使用", @"严格保密", @"认证使用", @"严格保密", @"认证使用"]];
    item1.isShowAllItem = YES;
    [item1 caleCellHeightWithTableView:self.m_TableView];
    item1.showAllHandler = ^(BMCombineItem *item) {
        
        [item caleCellHeightWithTableView:weakSelf.m_TableView];
        [weakSelf.m_TableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    item1.selectedHandler = ^(BMCombineItem *item) {
        
        for (NSNumber *num in item.selectedIndexArray)
        {
            BMLog(@"++++%@", num);
        }
    };
    
    BMCombineItem *item2 = [[BMCombineItem alloc] initWithTitle:@"法律" itemArray:@[@"以上信息", @"严格保密", @"认证使用", @"严格保密", @"认证使用", @"严格保密", @"认证使用", @"严格保密", @"认证使用", @"严格保密", @"认证使用"]];
    item2.isShowAllItem = YES;
    item2.isMutableSelect = YES;
    [item2 caleCellHeightWithTableView:self.m_TableView];
    item2.showAllHandler = ^(BMCombineItem *item) {
        
        [item caleCellHeightWithTableView:weakSelf.m_TableView];
        [weakSelf.m_TableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    item2.selectedHandler = ^(BMCombineItem *item) {
        
        for (NSNumber *num in item.selectedIndexArray)
        {
            BMLog(@"++++%@", num);
        }
    };
    item2.underLineDrawType = BMTableViewCell_UnderLineDrawType_None;
    
    self.m_Section.headerHeight = 10.0f;
    self.m_Section.footerHeight = 0.0f;
    [self.m_Section addItem:item1];
    [self.m_Section addItem:item2];
    
    [self.m_TableManager addSection:self.m_Section];
}

// 获取短信验证码
- (void)updateClicked:(UIButton *)btn
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest updateUserInfoWithOperaType:FSUpdateUserInfo_Ability changeValue:self.m_Ability];
    if (request)
    {
        [self.m_ProgressHUD showAnimated:YES showBackground:NO];
        
        [self.m_AbilityTask cancel];
        self.m_AbilityTask = nil;
        
        BMWeakSelf
        self.m_AbilityTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error)
            {
                BMLog(@"Error: %@", error);
                [weakSelf updateAbilityRequestFailed:response error:error];
                
            }
            else
            {
#if DEBUG
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
#endif
                [weakSelf updateAbilityRequestFinished:response responseDic:responseObject];
            }
        }];
        [self.m_AbilityTask resume];
    }
}

- (void)updateAbilityRequestFinished:(NSURLResponse *)response responseDic:(NSDictionary *)resDic
{
    if (![resDic bm_isNotEmptyDictionary])
    {
        [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        return;
    }
    
#if DEBUG
    NSString *responseStr = [[NSString stringWithFormat:@"%@", resDic] bm_convertUnicode];
    BMLog(@"实名认证返回数据是:+++++%@", responseStr);
#endif
    
    NSInteger statusCode = [resDic bm_intForKey:@"code"];
    if (statusCode == 1000)
    {
        [self.m_ProgressHUD hideAnimated:NO];
        
        FSUserInfoModle *userInfo = [FSUserInfoModle userInfo];
        userInfo.m_UserBaseInfo.m_Ability = self.m_Ability;
        
        [FSUserInfoDB insertAndUpdateUserInfo:userInfo];
        GetAppDelegate.m_UserInfo = userInfo;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(editorAbilityFinished:ability:)])
        {
            [self.delegate editorAbilityFinished:self ability:self.m_Ability];
        }
        
        [self backAction:nil];
        
        return;
    }
    
    NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
    [self.m_ProgressHUD showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
}

- (void)updateAbilityRequestFailed:(NSURLResponse *)response error:(NSError *)error
{
    BMLog(@"实名认证失败的错误:++++%@", [FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE]);
    
    [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
}

@end
