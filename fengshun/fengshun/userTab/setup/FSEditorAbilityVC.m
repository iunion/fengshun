//
//  FSEditorAbilityVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/7.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSEditorAbilityVC.h"
#import "AppDelegate.h"
#import "FSGlobleDataModel.h"

@interface FSEditorCombineModel : NSObject

@property (nonatomic, strong) NSString *m_Title;

@property (nonatomic, strong) NSMutableArray <NSString *> *m_ItemArray;

@end

@implementation FSEditorCombineModel
@end

@interface FSEditorAbilityVC ()

// 用户擅长领域数据
@property (nonatomic, strong) NSMutableArray <FSEditorCombineModel *> *m_UserAbilityInfo;
@property (nonatomic, strong) NSMutableArray *m_SeletedIndexArray;


@property (nonatomic, strong) NSMutableArray *m_AbilityArray;

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

- (instancetype)initWithAbilityArray:(NSArray *)abilityArray
{
    self = [self init];
    if (self)
    {
        if ([abilityArray bm_isNotEmpty])
        {
            self.m_AbilityArray = [NSMutableArray arrayWithArray:abilityArray];
        }
        else
        {
            self.m_AbilityArray = [NSMutableArray array];
        }
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeUserAbilityInfo];
    [self makeUserAbilitySelectedIndex];

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

- (void)makeUserAbilityInfo
{
    NSMutableArray *userAbilityInfo = [NSMutableArray array];
    
    for (FSGlobleDataModel *globleData in GetAppDelegate.m_Globle_UserAbilityInfo)
    {
        if ([globleData.m_Children bm_isNotEmpty])
        {
            FSEditorCombineModel *combineModel = [[FSEditorCombineModel alloc] init];
            combineModel.m_Title = globleData.m_Value;
            NSMutableArray *items = [NSMutableArray array];
            for (FSGlobleDataModel *childGlobleData in globleData.m_Children)
            {
                [items addObject:childGlobleData.m_Value];
            }
            combineModel.m_ItemArray = items;
            
            [userAbilityInfo addObject:combineModel];
       }
     }
    
    self.m_UserAbilityInfo = userAbilityInfo;
}

- (void)makeUserAbilitySelectedIndex
{
    NSMutableArray *selectedIndexArray = [NSMutableArray array];
    
    for (NSUInteger i=0; i<self.m_UserAbilityInfo.count; i++)
    {
        NSMutableArray *subSelectedIndexArray = [NSMutableArray array];
        FSEditorCombineModel *combineModel = self.m_UserAbilityInfo[i];
        for (NSUInteger index=0; index<combineModel.m_ItemArray.count; index++)
        {
            NSString *ability = combineModel.m_ItemArray[index];
            if ([self checkHasAbility:ability])
            {
                [subSelectedIndexArray addObject:@(index)];
            }
        }
        
        [selectedIndexArray addObject:subSelectedIndexArray];
    }
    
    self.m_SeletedIndexArray = selectedIndexArray;
}

- (BOOL)checkHasAbility:(NSString *)ability
{
    for (NSString *hability in self.m_AbilityArray)
    {
        if ([ability isEqual:hability])
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)interfaceSettings
{
    [super interfaceSettings];
    
    self.m_Section = [BMTableViewSection section];
    
    for (NSUInteger i=0; i<self.m_UserAbilityInfo.count; i++)
    {
        FSEditorCombineModel *combineModel = self.m_UserAbilityInfo[i];
        [self addCombineItemWithTitle:combineModel.m_Title itemArray:combineModel.m_ItemArray selectedIndexArray:self.m_SeletedIndexArray[i]];
    }
    
    self.m_Section.headerHeight = 10.0f;
    self.m_Section.footerHeight = 0.0f;
    
    [self.m_TableManager addSection:self.m_Section];
}

- (void)addCombineItemWithTitle:(NSString *)title itemArray:(NSArray<NSString *> *)itemArray selectedIndexArray:(NSArray<NSNumber *> *)selectedIndexArray
{
    BMWeakSelf
    
    BMCombineItem *item = [[BMCombineItem alloc] initWithTitle:title itemArray:itemArray selectedIndexArray:selectedIndexArray];
    item.isShowAllItem = YES;
    item.isMutableSelect = YES;
    [item caleCellHeightWithTableView:self.m_TableView];
    
    item.showAllHandler = ^(BMCombineItem *item) {
        
        [item caleCellHeightWithTableView:weakSelf.m_TableView];
        [weakSelf.m_TableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    item.selectedHandler = ^(BMCombineItem *item) {
        
#if DEBUG
        for (NSNumber *num in item.selectedIndexArray)
        {
            BMLog(@"++++%@", num);
        }
#endif
        [weakSelf freshAbilityList];
    };
    
    [self.m_Section addItem:item];
}

- (void)freshAbilityList
{
    NSMutableArray *abilityArray = [NSMutableArray array];
    for (BMCombineItem *item in self.m_Section.items)
    {
        for (NSNumber *indexNum in item.selectedIndexArray)
        {
            [abilityArray addObject:item.itemArray[indexNum.integerValue]];
        }
    }
    
    self.m_AbilityArray = abilityArray;
    self.m_Ability = [self.m_AbilityArray componentsJoinedByString:@","];
}

// 修改擅长领域数据
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
    BMLog(@"修改擅长领域返回数据是:+++++%@", responseStr);
#endif
    
    NSInteger statusCode = [resDic bm_intForKey:@"code"];
    if (statusCode == 1000)
    {
        [self.m_ProgressHUD hideAnimated:NO];
        
        FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
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
    if ([self checkRequestStatus:statusCode message:message responseDic:resDic logOutQuit:YES showLogin:YES])
    {
        [self.m_ProgressHUD hideAnimated:YES];
    }
    else
    {
        [self.m_ProgressHUD showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }
}

- (void)updateAbilityRequestFailed:(NSURLResponse *)response error:(NSError *)error
{
    BMLog(@"修改擅长领域失败的错误:++++%@", [FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE]);
    
    [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
}

@end
