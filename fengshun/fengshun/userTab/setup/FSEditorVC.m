//
//  FSEditorVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/7.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSEditorVC.h"

@interface FSEditorVC ()

@property (nonatomic, assign) FSUpdateUserInfoOperaType m_OperaType;

@property (nonatomic, assign) NSUInteger m_MinWordCount;
@property (nonatomic, assign) NSUInteger m_MaxWordCount;

@property (nonatomic, strong) NSString *m_Placeholder;

// 剩余字数提醒
@property (retain, nonatomic) UILabel *m_RemindLabel;

@property (nonatomic, retain) NSString *m_BackupText;

@property (nonatomic, strong) BMTableViewSection *m_Section;

@property (nonatomic, strong) BMLongTextItem *m_TextItem;

@property (nonatomic, strong) NSURLSessionDataTask *m_updateTask;

@end

@implementation FSEditorVC

- (void)dealloc
{
    [_m_updateTask cancel];
    _m_updateTask = nil;
}

- (BMFreshViewType)getFreshViewType
{
    return BMFreshViewType_NONE;
}

- (instancetype)initWithOperaType:(FSUpdateUserInfoOperaType)operaType minWordCount:(NSUInteger)minWordCount maxnWordCount:(NSUInteger)maxWordCount text:(NSString *)text placeholderText:(NSString *)placeholder
{
    self = [super init];
    if (self)
    {
        self.m_OperaType = operaType;
        
        self.m_MinWordCount = minWordCount;
        self.m_MaxWordCount = maxWordCount;
        
        self.m_BackupText = text;
        self.m_Placeholder = placeholder;
        
        if (!placeholder)
        {
            switch (operaType)
            {
                case FSUpdateUserInfo_NickName:
                    self.m_Placeholder = @"给自己取个好听的名字";
                    break;
                    
                case FSUpdateUserInfo_Organization:
                    self.m_Placeholder = @"请填写工作单位";
                    break;
                    
                case FSUpdateUserInfo_Job:
                    self.m_Placeholder = @"请填写职位信息";
                    break;
                    
                case FSUpdateUserInfo_Signature:
                    self.m_Placeholder = @"一句话介绍自己";
                    break;

                case FSUpdateUserInfo_WorkExperience:
                    self.m_Placeholder = @"请填写工作经历";
                    break;

                default:
                    break;
            }
        }
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = FS_VIEW_BGCOLOR;

    NSString *title = @"";
    switch (self.m_OperaType)
    {
        case FSUpdateUserInfo_NickName:
            title = @"昵称";
            break;
            
        case FSUpdateUserInfo_Organization:
            title = @"工作单位";
            break;
            
        case FSUpdateUserInfo_Job:
            title = @"职位";
            break;
            
        case FSUpdateUserInfo_Signature:
            title = @"个人签名";
            break;
            
        case FSUpdateUserInfo_WorkExperience:
            title = @"工作经历";
            break;
            
        default:
            break;
    }
    
    [self bm_setNavigationWithTitle:title barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:@"完成" rightItemImage:nil rightToucheEvent:@selector(updateAction:)];
    
    [self interfaceSettings];
}

- (BOOL)needKeyboardEvent
{
    return YES;
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
    BMLongTextItem *item = [BMLongTextItem itemWithTitle:nil value:self.m_BackupText placeholder:self.m_Placeholder];
    item.underLineDrawType = BMTableViewCell_UnderLineDrawType_None;
    item.cellBgColor = [UIColor whiteColor];
    item.charactersLimit = self.m_MaxWordCount;
    item.editable = YES;
    item.textViewLeftGap = 0.0f;
    item.textViewTopGap = 8.0f;
    item.showTextViewBorder = YES;
    item.textViewFont = [UIFont systemFontOfSize:16.0f];
    item.cellHeight = 120.0f;
    self.m_TextItem = item;
    
    self.m_Section.headerHeight = 0.0f;
    self.m_Section.footerHeight = 30.0f;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 0, UI_SCREEN_WIDTH-50.0f, 24.0f)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = UI_COLOR_B4;
    label.font = UI_FONT_12;
    label.textAlignment = NSTextAlignmentRight;
    //label.text = [NSString stringWithFormat:@"%@", @(self.m_MaxWordCount)];
    label.text = [NSString stringWithFormat:@"已输入%@/%@个字", @(item.value.length), @(self.m_MaxWordCount)];
    [view addSubview:label];
    self.m_RemindLabel = label;
    
    self.m_Section.footerView = view;

    [self.m_Section addItem:self.m_TextItem];
    
    item.onChange = ^(BMInputItem *item) {
        weakSelf.m_RemindLabel.text = [NSString stringWithFormat:@"已输入%@/%@个字", @(weakSelf.m_TextItem.value.length), @(weakSelf.m_MaxWordCount)];
    };
    
    [self.m_TableManager addSection:self.m_Section];
}

- (void)updateAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    NSString *value = self.m_TextItem.value;
    if ([value isEqual:self.m_BackupText])
    {
        return;
    }
    
    [self sendUpdateUserInfoWithOperaType:self.m_OperaType changeValue:value];
}


#pragma mark -
#pragma mark send request

// 更新用户信息
- (void)sendUpdateUserInfoWithOperaType:(FSUpdateUserInfoOperaType)operaType changeValue:(id)value
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest updateUserInfoWithOperaType:operaType changeValue:(id)value];
    if (request)
    {
        [self.m_ProgressHUD showAnimated:YES showBackground:NO];
        
        [self.m_updateTask cancel];
        self.m_updateTask = nil;
        
        BMWeakSelf
        self.m_updateTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error)
            {
                BMLog(@"Error: %@", error);
                [weakSelf updateRequestFailed:response error:error];
                
            }
            else
            {
#ifdef DEBUG
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
#endif
                [weakSelf updateRequestFinished:response responseDic:responseObject];
            }
        }];
        [self.m_updateTask resume];
    }
}

- (void)updateRequestFinished:(NSURLResponse *)response responseDic:(NSDictionary *)resDic
{
    if (![resDic bm_isNotEmptyDictionary])
    {
        [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        return;
    }
    
#ifdef DEBUG
    NSString *responseStr = [[NSString stringWithFormat:@"%@", resDic] bm_convertUnicode];
    BMLog(@"更新返回数据是:+++++%@", responseStr);
#endif
    
    NSInteger statusCode = [resDic bm_intForKey:@"code"];
    if (statusCode == 1000)
    {
        [self.m_ProgressHUD hideAnimated:NO];
        
        if ([self.delegate respondsToSelector:@selector(editorFinishedWithOperaType:value:)])
        {
            [self.delegate editorFinishedWithOperaType:self.m_OperaType value:self.m_TextItem.value];
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

- (void)updateRequestFailed:(NSURLResponse *)response error:(NSError *)error
{
    BMLog(@"更新失败的错误:++++%@", [FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE]);
    
    [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
}

@end
