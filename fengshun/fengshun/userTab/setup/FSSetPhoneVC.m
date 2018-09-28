//
//  FSSetPhoneVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/11.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSetPhoneVC.h"
#import "AppDelegate.h"
#import "FSAppInfo.h"

#import "BMVerifiTimeManager.h"

@interface FSSetPhoneVC ()

@property (nonatomic, strong) BMTableViewSection *m_Section;
@property (nonatomic, strong) BMTextItem *m_PhoneItem;
@property (nonatomic, strong) BMTextItem *m_VerifyItem;

@property (nonatomic, strong) UIButton *m_ClockBtn;

@property (nonatomic, strong) UIView *m_FooterView;
@property (nonatomic, strong) UILabel *m_ErrorLabel;

@property (nonatomic, strong) UIButton *m_UpdateBtn;

@property (strong, nonatomic) NSURLSessionDataTask *m_VerificationCodeTask;
@property (nonatomic, strong) NSURLSessionDataTask *m_PhoneTask;

@property (nonatomic, strong) NSString *m_PhoneNum;
@property (nonatomic, strong) NSString *m_VerificationCode;

@end

@implementation FSSetPhoneVC

- (void)dealloc
{
    [_m_VerificationCodeTask cancel];
    _m_VerificationCodeTask = nil;
    
    [_m_PhoneTask cancel];
    _m_PhoneTask = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = FS_VIEW_BGCOLOR;
    self.m_TableView.bounces = YES;
    
    [self bm_setNavigationWithTitle:@"绑定手机" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    
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
    
    self.m_PhoneItem = [BMTextItem itemWithTitle:@"手机号码" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:nil selectionHandler:nil];
    self.m_PhoneItem.placeholder = @"输入要绑定的新手机号";
    self.m_PhoneItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_PhoneItem.textFieldTextFont = FS_CELLTITLE_TEXTFONT;
    self.m_PhoneItem.keyboardType = UIKeyboardTypeNumberPad;
    self.m_PhoneItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.m_PhoneItem.underLineColor = FS_LINECOLOR;
    self.m_PhoneItem.cellHeight = 50.0f;
    self.m_PhoneItem.charactersLimit = FSPHONENUMBER_LENGTH;
    self.m_PhoneItem.editable = YES;
    self.m_PhoneItem.imageH = 16.0f;
    self.m_PhoneItem.imageW = 16.0f;
    self.m_PhoneItem.image = [UIImage imageNamed:@"user_mobileicon"];

    self.m_PhoneItem.onChange = ^(BMInputItem *item) {
        weakSelf.m_PhoneNum = item.value;
        [weakSelf checkPhoneNum:weakSelf.m_PhoneNum verificationCode:weakSelf.m_VerificationCode];
    };

    // 获取验证码
    UIButton *clockBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90.0f, 30.0f)];
    self.m_ClockBtn = clockBtn;
    [clockBtn addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    clockBtn.exclusiveTouch = YES;

    // 客户端不做计时判断
    [[BMVerifiTimeManager manager] stopAllType];
    [self freshClockBtn:0];
//    [[BMVerifiTimeManager manager] checkTimeWithType:BMVerificationCodeType_Type5 process:^(BMVerificationCodeType type, NSInteger ticket, BOOL stop) {
//        [weakSelf freshClockBtn:ticket];
//    }];

    self.m_VerifyItem = [BMTextItem itemWithTitle:@"验证码" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:clockBtn selectionHandler:nil];
    self.m_VerifyItem.placeholder = @"输入验证码";
    self.m_VerifyItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_VerifyItem.textFieldTextFont = FS_CELLTITLE_TEXTFONT;
    self.m_VerifyItem.keyboardType = UIKeyboardTypeNumberPad;
    self.m_VerifyItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.m_VerifyItem.cellHeight = 50.0f;
    self.m_VerifyItem.charactersLimit = 4;
    self.m_VerifyItem.editable = YES;
    self.m_VerifyItem.imageH = 16.0f;
    self.m_VerifyItem.imageW = 16.0f;
    self.m_VerifyItem.image = [UIImage imageNamed:@"user_verifyicon"];
    
    self.m_VerifyItem.onChange = ^(BMInputItem *item) {
        weakSelf.m_VerificationCode = item.value;
        [weakSelf checkPhoneNum:weakSelf.m_PhoneNum verificationCode:weakSelf.m_VerificationCode];
    };
    
    self.m_Section.headerHeight = 10.0f;
    self.m_Section.footerHeight = 0.0f;
    [self.m_Section addItem:self.m_PhoneItem];
    [self.m_Section addItem:self.m_VerifyItem];
    
    // footer
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 100.0f)];
    footerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [UILabel bm_labelWithFrame:CGRectMake(15.0f, 4.0f, self.m_TableView.bm_width-30.0f, 24.0f) text:@"" fontSize:12.0f color:UI_COLOR_R1 alignment:NSTextAlignmentLeft lines:1];
    [footerView addSubview:label];
    self.m_ErrorLabel = label;
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
    btn.bm_top = label.bm_bottom + 4.0f;
    btn.backgroundColor = UI_COLOR_BL1;
    btn.titleLabel.font = FS_BUTTON_LARGETEXTFONT;
    btn.exclusiveTouch = YES;
    [btn addTarget:self action:@selector(updateMobile:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确认绑定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn bm_roundedRect:4.0f];
    self.m_UpdateBtn = btn;
    
    [footerView addSubview:btn];
    [btn bm_centerHorizontallyInSuperView];
    self.m_FooterView = footerView;
    
    [self checkPhoneNum:nil verificationCode:nil];
    
    [self.m_TableManager addSection:self.m_Section];
    
    self.m_TableView.tableFooterView = self.m_FooterView;
}

- (void)checkPhoneNum:(NSString *)phoneNum verificationCode:(NSString *)code
{
    BOOL enabled = YES;
    if (phoneNum.length != FSPHONENUMBER_LENGTH)
    {
        enabled = NO;
        self.m_ClockBtn.enabled = NO;
        self.m_ClockBtn.backgroundColor = UI_COLOR_B5;
        [self.m_ClockBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.m_ClockBtn bm_roundedRect:4.0f borderWidth:0.0f borderColor:UI_COLOR_BL1];
    }
    else
    {
        self.m_ClockBtn.enabled = YES;
        self.m_ClockBtn.backgroundColor = UI_COLOR_BL2;
        [self.m_ClockBtn setTitleColor:UI_COLOR_BL1 forState:UIControlStateNormal];
        [self.m_ClockBtn bm_roundedRect:4.0f borderWidth:1.0f borderColor:UI_COLOR_BL1];

        if (code.length != 4)
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

- (void)freshClockBtn:(NSInteger)ticket
{
    if (ticket > 0)
    {
        self.m_ClockBtn.userInteractionEnabled = NO;
        self.m_ClockBtn.titleLabel.font = UI_FONT_12;
        self.m_ClockBtn.backgroundColor = UI_COLOR_B5;
        [self.m_ClockBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.m_ClockBtn bm_roundedRect:4.0f borderWidth:0.0f borderColor:UI_COLOR_BL1];
        //self.m_ClockBtn.titleLabel.text = [NSString stringWithFormat:@"%@秒后可操作", @(ticket)];
        [self.m_ClockBtn setTitle:[NSString stringWithFormat:@"%@秒后可操作", @(ticket)] forState:UIControlStateNormal];
    }
    else
    {
        self.m_ClockBtn.userInteractionEnabled = YES;
        self.m_ClockBtn.titleLabel.font = UI_FONT_14;
        self.m_ClockBtn.backgroundColor = UI_COLOR_BL2;
        [self.m_ClockBtn setTitleColor:UI_COLOR_BL1 forState:UIControlStateNormal];
        [self.m_ClockBtn bm_roundedRect:4.0f borderWidth:1.0f borderColor:UI_COLOR_BL1];
        if (self.m_VerificationCodeTask)
        {
            [self.m_ClockBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        }
        else
        {
            [self.m_ClockBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
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


#pragma mark -
#pragma mark 获取verificationCode

- (void)getVerificationCode:(UIButton *)clockBtn
{
    [self.view endEditing:YES];
    
    //[self.m_ProgressHUD showAnimated:YES showBackground:NO];
    
    BMWeakSelf
    [[BMVerifiTimeManager manager] startTimeWithType:BMVerificationCodeType_Type5 process:^(BMVerificationCodeType type, NSInteger ticket, BOOL stop) {
        [weakSelf freshClockBtn:ticket];
    }];
    
    [self sendGetVerificationCodeWithType:BMVerificationCodeType_Type5 phoneNum:self.m_PhoneNum];
}

// 获取短信验证码
- (void)sendGetVerificationCodeWithType:(BMVerificationCodeType)verificationCodeType phoneNum:(NSString *)phoneNum
{
    self.m_ErrorLabel.hidden = YES;
    
    FSVerificationCodeType verificationType = FSVerificationCodeType_UpdatePhoneNumNew;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest getVerificationCodeWithType:verificationType phoneNum:phoneNum];
    if (request)
    {
        [self.m_ProgressHUD showAnimated:YES showBackground:NO];
        
        [self.m_VerificationCodeTask cancel];
        self.m_VerificationCodeTask = nil;
        
        BMWeakSelf
        self.m_VerificationCodeTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error)
            {
                BMLog(@"Error: %@", error);
                [weakSelf getVerificationCodeRequestFailed:response error:error];
                
            }
            else
            {
#ifdef DEBUG
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
#endif
                [weakSelf getVerificationCodeRequestFinished:response responseDic:responseObject];
            }
        }];
        [self.m_VerificationCodeTask resume];
    }
    else
    {
        [[BMVerifiTimeManager manager] stopTimeWithType:BMVerificationCodeType_Type5];
        [self freshClockBtn:0];
    }
}

- (void)getVerificationCodeRequestFinished:(NSURLResponse *)response responseDic:(NSDictionary *)resDic
{
    if (![resDic bm_isNotEmptyDictionary])
    {
        [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];

        [[BMVerifiTimeManager manager] stopTimeWithType:BMVerificationCodeType_Type5];
        [self freshClockBtn:0];

        return;
    }
    
#ifdef DEBUG
    NSString *responseStr = [[NSString stringWithFormat:@"%@", resDic] bm_convertUnicode];
    BMLog(@"获取短信验证码返回数据是:+++++%@", responseStr);
#endif
    
    NSInteger statusCode = [resDic bm_intForKey:@"code"];
    if (statusCode == 1000)
    {
        [self.m_ProgressHUD hideAnimated:NO];
        
        [self freshViews];
        
        return;
    }
    else
    {
        NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
        //[self.m_ProgressHUD showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        [self.m_ProgressHUD hideAnimated:NO];
        
        [[BMVerifiTimeManager manager] stopTimeWithType:BMVerificationCodeType_Type5];
        [self freshClockBtn:0];

        [self freshErrorLabelWithMessage:message];
    }
}

- (void)getVerificationCodeRequestFailed:(NSURLResponse *)response error:(NSError *)error
{
    BMLog(@"获取短信验证码失败的错误:++++%@", [FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE]);
    
    [[BMVerifiTimeManager manager] stopTimeWithType:BMVerificationCodeType_Type5];
    [self freshClockBtn:0];

    [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
}


#pragma mark -
#pragma mark 绑定手机

- (void)updateMobile:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    if (![self verifyPhoneNum:self.m_PhoneNum])
    {
        return;
    }
    
    [self updatePhoneNum:self.m_PhoneNum verificationCode:self.m_VerificationCode];
}


- (void)updatePhoneNum:(NSString *)phoneNum verificationCode:(NSString *)code
{
    self.m_ErrorLabel.hidden = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest changeMobilePhoneWithOldPhoneNum:self.m_OldPhoneNum oldVerificationCode:self.m_OldVerificationCode newPhoneNum:self.m_PhoneNum newVerificationCode:self.m_VerificationCode];
    if (request)
    {
        [self.m_ProgressHUD showAnimated:YES showBackground:NO];
        
        [self.m_PhoneTask cancel];
        self.m_PhoneTask = nil;
        
        BMWeakSelf
        self.m_PhoneTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error)
            {
                BMLog(@"Error: %@", error);
                [weakSelf changeMobilePhoneRequestFailed:response error:error];
                
            }
            else
            {
#ifdef DEBUG
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
#endif
                [weakSelf changeMobilePhoneRequestFinished:response responseDic:responseObject];
            }
        }];
        [self.m_PhoneTask resume];
    }
}

- (void)changeMobilePhoneRequestFinished:(NSURLResponse *)response responseDic:(NSDictionary *)resDic
{
    if (![resDic bm_isNotEmptyDictionary])
    {
        [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        return;
    }
    
#ifdef DEBUG
    NSString *responseStr = [[NSString stringWithFormat:@"%@", resDic] bm_convertUnicode];
    BMLog(@"绑定手机返回数据是:+++++%@", responseStr);
#endif
    
    NSInteger statusCode = [resDic bm_intForKey:@"code"];
    if (statusCode == 1000)
    {
        [self.m_ProgressHUD hideAnimated:NO];
        
        FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
        userInfo.m_UserBaseInfo.m_PhoneNum = self.m_PhoneNum;
        
        [FSAppInfo setCurrentPhoneNum:self.m_PhoneNum];

        [FSUserInfoDB insertAndUpdateUserInfo:userInfo];
        GetAppDelegate.m_UserInfo = userInfo;
        
        // 停止计时
        [[BMVerifiTimeManager manager] stopTimeWithType:BMVerificationCodeType_Type5];
        [self freshClockBtn:0];

        if (self.m_PopToViewController)
        {
            [self.m_PopToViewController freshViews];
            [self backToViewController:self.m_PopToViewController];
        }
        else
        {
            [self backAction:nil];
        }
        
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

- (void)changeMobilePhoneRequestFailed:(NSURLResponse *)response error:(NSError *)error
{
    BMLog(@"绑定手机失败的错误:++++%@", [FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE]);
    
    [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
}

@end
