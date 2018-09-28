//
//  FSAuthenticationVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/7.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSAuthenticationVC.h"
#import "AppDelegate.h"

@interface FSAuthenticationVC ()

@property (nonatomic, strong) BMTableViewSection *m_Section;
@property (nonatomic, strong) BMTextItem *m_NameItem;
@property (nonatomic, strong) BMTextItem *m_IdItem;

@property (nonatomic, strong) UIView *m_FooterView;
@property (nonatomic, strong) UILabel *m_Label;
@property (nonatomic, strong) UILabel *m_ErrorLabel;

@property (nonatomic, strong) UIButton *m_UpdateBtn;

@property (nonatomic, strong) NSURLSessionDataTask *m_AuthenticationTask;

@property (nonatomic, strong) NSString *m_Name;
@property (nonatomic, strong) NSString *m_IdNum;

@end

@implementation FSAuthenticationVC

- (void)dealloc
{
    [_m_AuthenticationTask cancel];
    _m_AuthenticationTask = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = FS_VIEW_BGCOLOR;
    self.m_TableView.bounces = YES;
    
    [self bm_setNavigationWithTitle:@"实名认证" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    
    [self interfaceSettings];
}
 
- (void)backAction:(id)sender
{
    [self.view endEditing:YES];
    
    if (self.presentingViewController)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    
    self.m_NameItem = [BMTextItem itemWithTitle:@"姓名" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:nil selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_NameItem.placeholder = @"请输入您的姓名";
    self.m_NameItem.editable = YES;
    self.m_NameItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_NameItem.textFieldTextFont = FS_CELLTITLE_TEXTFONT;
    self.m_NameItem.highlightBgColor = UI_COLOR_BL1;
    self.m_NameItem.cellHeight = 50.0f;
    self.m_NameItem.charactersLimit = 8;
    self.m_NameItem.onChange = ^(BMInputItem *item) {
        weakSelf.m_Name = item.value;
        [weakSelf checkAuthenticationWithName:weakSelf.m_Name idNum:weakSelf.m_IdNum];
    };

    self.m_IdItem = [BMTextItem itemWithTitle:@"身份证号" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:nil selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_IdItem.placeholder = @"请输入您的身份证号码";
    self.m_IdItem.editable = YES;
    self.m_IdItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_IdItem.textFieldTextFont = FS_CELLTITLE_TEXTFONT;
    self.m_IdItem.highlightBgColor = UI_COLOR_BL1;
    self.m_IdItem.cellHeight = 50.0f;
    self.m_IdItem.charactersLimit = 18;
    self.m_IdItem.onChange = ^(BMInputItem *item) {
        weakSelf.m_IdNum = item.value;
        [weakSelf checkAuthenticationWithName:weakSelf.m_Name idNum:weakSelf.m_IdNum];
    };

    self.m_Section.headerHeight = 10.0f;
    self.m_Section.footerHeight = 0.0f;
    [self.m_Section addItem:self.m_NameItem];
    [self.m_Section addItem:self.m_IdItem];

    // footer
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 100.0f)];
    footerView.backgroundColor = [UIColor clearColor];

    UILabel *label1 = [UILabel bm_labelWithFrame:CGRectMake(15.0f, 4.0f, self.m_TableView.bm_width-30.0f, 24.0f) text:@"以上信息只供认证使用，我们将严格保密" fontSize:12.0f color:UI_COLOR_B4 alignment:NSTextAlignmentLeft lines:1];
    [footerView addSubview:label1];
    self.m_Label = label1;

    UILabel *label2 = [UILabel bm_labelWithFrame:CGRectMake(15.0f, label1.bm_bottom + 4.0f, self.m_TableView.bm_width-30.0f, 24.0f) text:@"" fontSize:12.0f color:UI_COLOR_R1 alignment:NSTextAlignmentLeft lines:1];
    [footerView addSubview:label2];
    self.m_ErrorLabel = label2;
    self.m_ErrorLabel.hidden = YES;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    CGRect frame;
//    if (IS_IPHONE6P || IS_IPHONEXP)
//    {
//        frame = CGRectMake(0, 0, self.m_TableView.bm_width-60.0f, 44);
//    }
//    else if (IS_IPHONE6 || IS_IPHONEX)
//    {
//        frame = CGRectMake(0, 0, self.m_TableView.bm_width-50.0f, 44);
//    }
//    else
//    {
//        frame = CGRectMake(0, 0, self.m_TableView.bm_width-30.0f, 44);
//    }
//    btn.frame = frame;
    btn.frame = CGRectMake(0, 0, self.m_TableView.bm_width-40.0f, 44);
    btn.bm_top = label2.bm_bottom + 4.0f;
    btn.backgroundColor = UI_COLOR_BL1;
    btn.titleLabel.font = FS_BUTTON_LARGETEXTFONT;
    btn.exclusiveTouch = YES;
    [btn addTarget:self action:@selector(authenticate:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"认证" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn bm_roundedRect:4.0f];
    self.m_UpdateBtn = btn;
    
    [footerView addSubview:btn];
    [btn bm_centerHorizontallyInSuperView];
    self.m_FooterView = footerView;

    [self checkAuthenticationWithName:nil idNum:nil];
    
    [self.m_TableManager addSection:self.m_Section];
    
    self.m_TableView.tableFooterView = self.m_FooterView;
}

- (void)authenticate:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    if (![self.m_Name bm_isNotEmpty])
    {
        [self.m_ProgressHUD showAnimated:YES withDetailText:@"请填写本人姓名" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        return;
    }
    else
    {
        if (![self verifyId:self.m_IdNum])
        {
            return;
        }
    }

    [self authenticationWithIdNum:self.m_IdNum name:self.m_Name];
}

- (void)checkAuthenticationWithName:(NSString *)name idNum:(NSString *)idNum
{
    BOOL enabled = YES;
    if (![name bm_isNotEmpty])
    {
        enabled = NO;
    }
    else
    {
        if (idNum.length<15)
        {
            enabled = NO;
        }
    }
    
    self.m_UpdateBtn.enabled = enabled;
    if (self.m_UpdateBtn.enabled)
    {
        self.m_UpdateBtn.backgroundColor = UI_COLOR_BL1;
    }
    else
    {
        self.m_UpdateBtn.backgroundColor = UI_COLOR_B5;
    }
}

- (void)freshErrorLabelWithMessage:(NSString *)message
{
    if (![message bm_isNotEmpty])
    {
        return;
    }
    
    self.m_ErrorLabel.hidden = NO;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"login_error"];
    attch.bounds = CGRectMake(0, -2.0f, 12.0f, 12.0f);
    // 创建带有图片的富文本
    NSAttributedString *errorIcon = [NSAttributedString attributedStringWithAttachment:attch];
    [attrString appendAttributedString:errorIcon];
    
    // 文本
    NSMutableAttributedString *errorString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" \"%@\"", message]];
    [errorString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:UI_COLOR_R1} range:NSMakeRange(0, errorString.string.length)];
    [attrString appendAttributedString:errorString];
    
    self.m_ErrorLabel.attributedText = attrString;
}

// 获取短信验证码
- (void)authenticationWithIdNum:(NSString *)idNum name:(NSString *)name
{
    self.m_ErrorLabel.hidden = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest authenticationWithId:idNum name:name];
    if (request)
    {
        [self.m_ProgressHUD showAnimated:YES showBackground:NO];
        
        [self.m_AuthenticationTask cancel];
        self.m_AuthenticationTask = nil;
        
        BMWeakSelf
        self.m_AuthenticationTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error)
            {
                BMLog(@"Error: %@", error);
                [weakSelf authenticationRequestFailed:response error:error];
                
            }
            else
            {
#ifdef DEBUG
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
#endif
                [weakSelf authenticationRequestFinished:response responseDic:responseObject];
            }
        }];
        [self.m_AuthenticationTask resume];
    }
}

- (void)authenticationRequestFinished:(NSURLResponse *)response responseDic:(NSDictionary *)resDic
{
    if (![resDic bm_isNotEmptyDictionary])
    {
        [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];

        return;
    }
    
#ifdef DEBUG
    NSString *responseStr = [[NSString stringWithFormat:@"%@", resDic] bm_convertUnicode];
    BMLog(@"实名认证返回数据是:+++++%@", responseStr);
#endif
    
    NSInteger statusCode = [resDic bm_intForKey:@"code"];
    if (statusCode == 1000)
    {
        [self.m_ProgressHUD hideAnimated:NO];
        
        FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
        userInfo.m_UserBaseInfo.m_RealName = self.m_Name;
        userInfo.m_UserBaseInfo.m_IdCardNo = self.m_IdNum;
        userInfo.m_UserBaseInfo.m_IsRealName = YES;
        
        [FSUserInfoDB insertAndUpdateUserInfo:userInfo];
        GetAppDelegate.m_UserInfo = userInfo;

        if (self.delegate && [self.delegate respondsToSelector:@selector(authenticationFinished:)])
        {
            [self.delegate authenticationFinished:self];
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
        //[self.m_ProgressHUD showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        [self.m_ProgressHUD hideAnimated:NO];
    }
    
    [self freshErrorLabelWithMessage:message];
}

- (void)authenticationRequestFailed:(NSURLResponse *)response error:(NSError *)error
{
    BMLog(@"实名认证失败的错误:++++%@", [FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE]);
    
    [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
}

@end
