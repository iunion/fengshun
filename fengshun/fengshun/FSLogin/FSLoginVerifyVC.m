//
//  FSLoginVerifyVC.m
//  fengshun
//
//  Created by jiang deng on 2018/8/29.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSLoginVerifyVC.h"
#import "BMVerifyField.h"
#import "FSSetPassWordVC.h"

@interface FSLoginVerifyVC ()
<
    BMVerifyFieldDelegate
>

@property (nonatomic, strong) NSString *m_PhoneNum;

@property (nonatomic, strong) BMVerifyField *m_VerifyField;

@property (nonatomic, strong) UILabel *m_PhoneNumLabel;
@property (nonatomic, strong) UILabel *m_ErrorLabel;

@property (nonatomic, strong) UIButton *m_ClockBtn;
@property (nonatomic, strong) UIButton *m_ConfirmBtn;

@property (strong, nonatomic) NSURLSessionDataTask *m_VerificationCodeTask;
@property (strong, nonatomic) NSURLSessionDataTask *m_CheckVerificationCodeTask;

@end

@implementation FSLoginVerifyVC

- (void)dealloc
{
    [_m_VerificationCodeTask cancel];
    _m_VerificationCodeTask = nil;
    
    [_m_CheckVerificationCodeTask cancel];
    _m_CheckVerificationCodeTask = nil;
}

- (instancetype)initWithVerificationType:(BMVerificationCodeType)verificationType phoneNum:(NSString *)phoneNum
{
    self = [super init];
    
    if (self)
    {
        _m_VerificationType = verificationType;
        _m_PhoneNum = phoneNum;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bm_NavigationBarStyle = UIBarStyleDefault;
    self.bm_NavigationBarBgTintColor = [UIColor whiteColor];
    self.bm_NavigationItemTintColor = UI_COLOR_B2;
    
    if (self.m_IsRegist)
    {
        [self bm_setNavigationWithTitle:@"注册" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:@"navigationbar_close_icon" rightToucheEvent:@selector(closeAction:)];
    }
    else
    {
        [self bm_setNavigationWithTitle:@"验证" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:@"navigationbar_close_icon" rightToucheEvent:@selector(closeAction:)];
    }
    
    if (IS_IPHONE6P)
    {
        self.m_TableView.bm_left = 40.0f;
        self.m_TableView.bm_width = UI_SCREEN_WIDTH-80.0f;
    }
    else if (IS_IPHONE6 || IS_IPHONEX)
    {
        self.m_TableView.bm_left = 30.0f;
        self.m_TableView.bm_width = UI_SCREEN_WIDTH-60.0f;
    }
    else
    {
        self.m_TableView.bm_left = 20.0f;
        self.m_TableView.bm_width = UI_SCREEN_WIDTH-40.0f;
    }
    
    [self interfaceSettings];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginProgressStateChanged:)])
    {
        switch (self.m_VerificationType)
        {
            case BMVerificationCodeType_Type1:
                [self.delegate loginProgressStateChanged:FSLoginProgress_RegistVerify];
                break;
                
            case BMVerificationCodeType_Type2:
                [self.delegate loginProgressStateChanged:FSLoginProgress_ForgetVerify];
                break;
                
            default:
                break;
        }
    }
}

- (BOOL)needKeyboardEvent
{
    return YES;
}

- (void)closeAction:(id)sender
{
    [self.view endEditing:YES];

    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginClosedWithProgressState:)])
        {
            switch (self.m_VerificationType)
            {
                case BMVerificationCodeType_Type1:
                    [self.delegate loginClosedWithProgressState:FSLoginProgress_RegistVerify];
                    break;
                    
                case BMVerificationCodeType_Type2:
                    [self.delegate loginClosedWithProgressState:FSLoginProgress_ForgetVerify];
                    break;
                    
                default:
                    break;
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)interfaceSettings
{
    NSString *text = [NSString stringWithFormat:@"验证码已发送到手机%@", [self.m_PhoneNum bm_maskAtRang:NSMakeRange(3, 4) withMask:'*']];
    UILabel *label1 = [UILabel bm_labelWithFrame:CGRectMake(0, 20.0f, self.m_TableView.bm_width, 32.0f) text:text fontSize:18.0f color:UI_COLOR_B1 alignment:NSTextAlignmentLeft lines:1];
    [self.m_TableView addSubview:label1];
    self.m_PhoneNumLabel = label1;
    
    UILabel *label2 = [UILabel bm_labelWithFrame:CGRectMake(0, label1.bm_bottom+4.0f, self.m_TableView.bm_width, 40.0f) text:@"请在下方输入短信验证码" fontSize:14.0f color:UI_COLOR_B1 alignment:NSTextAlignmentLeft lines:1];
    [self.m_TableView addSubview:label2];

    // 获取验证码
    UIButton *clockBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.m_TableView.bm_width-90.0f, label2.bm_top+5.0f, 90.0f, 30.0f)];
    self.m_ClockBtn = clockBtn;
    [clockBtn addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    clockBtn.exclusiveTouch = YES;
    [self.m_TableView addSubview:clockBtn];

    BMWeakSelf
    [[BMVerifiTimeManager manager] checkTimeWithType:self.m_VerificationType process:^(BMVerificationCodeType type, NSInteger ticket, BOOL stop) {
        [weakSelf freshClockBtn:ticket];
    }];

    BMVerifyField *verifyField = [[BMVerifyField alloc] initWithFrame:CGRectMake(0, label2.bm_bottom+10.0f, self.m_TableView.bm_width, 40.0f)];
    [self.m_TableView addSubview:verifyField];
    verifyField.delegate = self;
    verifyField.trackBorderColor = UI_COLOR_BL1;
    verifyField.autoResignFirstResponderWhenInputFinished = YES;
    verifyField.userInteractionEnabled = NO;
    self.m_VerifyField = verifyField;
    
    UILabel *label3 = [UILabel bm_labelWithFrame:CGRectMake(0, verifyField.bm_bottom+10.0f, self.m_TableView.bm_width, 24.0f) text:@"" fontSize:12.0f color:UI_COLOR_R1 alignment:NSTextAlignmentLeft lines:1];
    [self.m_TableView addSubview:label3];
    self.m_ErrorLabel = label3;
    self.m_ErrorLabel.hidden = YES;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame;
    if (IS_IPHONE6P)
    {
        frame = CGRectMake(0, 0, self.m_TableView.bm_width-60.0f, 44);
    }
    else if (IS_IPHONE6 || IS_IPHONEX)
    {
        frame = CGRectMake(0, 0, self.m_TableView.bm_width-50.0f, 44);
    }
    else
    {
        frame = CGRectMake(0, 0, self.m_TableView.bm_width-30.0f, 44);
    }
    btn.frame = frame;
    btn.backgroundColor = UI_COLOR_BL1;
    btn.titleLabel.font = FS_BUTTON_LARGETEXTFONT;
    btn.exclusiveTouch = YES;
    [btn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.m_IsRegist)
    {
        [btn setTitle:@"提交注册" forState:UIControlStateNormal];
    }
    else
    {
        [btn setTitle:@"提交验证" forState:UIControlStateNormal];
    }
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn bm_roundedRect:4.0f];
    btn.backgroundColor = UI_COLOR_B5;
    btn.enabled = NO;

    [self.m_TableView addSubview:btn];
    [btn bm_centerHorizontallyInSuperViewWithTop:label3.bm_bottom+20.0f];
    self.m_ConfirmBtn = btn;
}

- (void)freshViews
{
    self.m_VerifyField.userInteractionEnabled = YES;
    [self.m_VerifyField becomeFirstResponder];
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
#pragma mark BMVerifyFieldDelegate

- (BOOL)verifyField:(BMVerifyField *)verifyField shouldChangeCharacterAtIndex:(NSUInteger)index replacementString:(NSString *)string
{
    if (index >= 3 && ![string isEqualToString:@""])
    {
        self.m_ConfirmBtn.enabled = YES;
    }
    else
    {
        self.m_ConfirmBtn.enabled = NO;
    }
    
    if (self.m_ConfirmBtn.enabled)
    {
        self.m_ConfirmBtn.backgroundColor = UI_COLOR_BL1;
    }
    else
    {
        self.m_ConfirmBtn.backgroundColor = UI_COLOR_B5;
    }
    
    return YES;
}

#pragma mark -
#pragma mark 获取verificationCode

- (void)getVerificationCode:(UIButton *)clockBtn
{
    [self.view endEditing:YES];
    
    //[self.m_ProgressHUD showAnimated:YES showBackground:NO];
    
    BMWeakSelf
    [[BMVerifiTimeManager manager] startTimeWithType:self.m_VerificationType process:^(BMVerificationCodeType type, NSInteger ticket, BOOL stop) {
        [weakSelf freshClockBtn:ticket];
    }];

    [self sendGetVerificationCodeWithType:self.m_VerificationType phoneNum:self.m_PhoneNum];
}


#pragma mark -
#pragma mark 验证verificationCode

- (void)confirmClick:(UIButton *)btn
{
    [self.view endEditing:YES];

    [self sendCheckVerificationCodeWithType:self.m_VerificationType phoneNum:self.m_PhoneNum verificationCode:self.m_VerifyField.text];
}


#pragma mark -
#pragma mark send request

- (FSVerificationCodeType)getFSVerificationCodeType:(BMVerificationCodeType)verificationCodeType
{
    FSVerificationCodeType verificationType = FSVerificationCodeType_Unknown;
    switch (verificationCodeType)
    {
        case BMVerificationCodeType_Type1:
            verificationType = FSMVerificationCodeType_Register;
            break;
            
        case BMVerificationCodeType_Type2:
            verificationType = FSVerificationCodeType_ResetPassword;
            break;
            
        case BMVerificationCodeType_Type3:
            verificationType = FSVerificationCodeType_UpdatePhoneNum;
            break;
            
        default:
            verificationType = FSVerificationCodeType_Unknown;
            break;
    }
    
    return verificationType;
}

// 获取短信验证码
- (void)sendGetVerificationCodeWithType:(BMVerificationCodeType)verificationCodeType phoneNum:(NSString *)phoneNum
{
    self.m_ErrorLabel.hidden = YES;

    FSVerificationCodeType verificationType = [self getFSVerificationCodeType:verificationCodeType];
    
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
                BMLog(@"%@ %@", response, responseObject);
                [weakSelf getVerificationCodeRequestFinished:response responseDic:responseObject];
            }
        }];
        [self.m_VerificationCodeTask resume];
    }
}

- (void)getVerificationCodeRequestFinished:(NSURLResponse *)response responseDic:(NSDictionary *)resDic
{
    if (![resDic bm_isNotEmptyDictionary])
    {
        [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailedWithProgressState:)])
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(loginClosedWithProgressState:)])
            {
                switch (self.m_VerificationType)
                {
                    case BMVerificationCodeType_Type1:
                        [self.delegate loginFailedWithProgressState:FSLoginProgress_RegistVerify];
                        break;
                        
                    case BMVerificationCodeType_Type2:
                        [self.delegate loginFailedWithProgressState:FSLoginProgress_ForgetVerify];
                        break;
                        
                    default:
                        break;
                }
            }
        }
        return;
    }
    
    BMLog(@"获取短信验证码返回数据是:+++++%@", resDic);
    
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
        
        [self freshErrorLabelWithMessage:message];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailedWithProgressState:)])
    {
        switch (self.m_VerificationType)
        {
            case BMVerificationCodeType_Type1:
                [self.delegate loginFailedWithProgressState:FSLoginProgress_RegistVerify];
                break;
                
            case BMVerificationCodeType_Type2:
                [self.delegate loginFailedWithProgressState:FSLoginProgress_ForgetVerify];
                break;
                
            default:
                break;
        }
    }
}

- (void)getVerificationCodeRequestFailed:(NSURLResponse *)response error:(NSError *)error
{
    BMLog(@"获取短信验证码失败的错误:++++%@", [FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE]);
    
    [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailedWithProgressState:)])
    {
        switch (self.m_VerificationType)
        {
            case BMVerificationCodeType_Type1:
                [self.delegate loginFailedWithProgressState:FSLoginProgress_RegistVerify];
                break;
                
            case BMVerificationCodeType_Type2:
                [self.delegate loginFailedWithProgressState:FSLoginProgress_ForgetVerify];
                break;
                
            default:
                break;
        }
    }
}

// 验证验证码
- (void)sendCheckVerificationCodeWithType:(BMVerificationCodeType)verificationCodeType phoneNum:(NSString *)phoneNum verificationCode:(NSString *)verificationCode
{
    self.m_ErrorLabel.hidden = YES;
    
    FSVerificationCodeType verificationType = [self getFSVerificationCodeType:verificationCodeType];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest checkVerificationCodeWithType:verificationType phoneNum:phoneNum verificationCode:verificationCode];
    if (request)
    {
        [self.m_ProgressHUD showAnimated:YES showBackground:NO];
        
        [self.m_CheckVerificationCodeTask cancel];
        self.m_CheckVerificationCodeTask = nil;
        
        BMWeakSelf
        self.m_CheckVerificationCodeTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error)
            {
                BMLog(@"Error: %@", error);
                [weakSelf checkVerificationCodeRequestFailed:response error:error];
                
            }
            else
            {
                BMLog(@"%@ %@", response, responseObject);
                [weakSelf checkVerificationCodeRequestFinished:response responseDic:responseObject];
            }
        }];
        [self.m_CheckVerificationCodeTask resume];
    }
}

- (void)checkVerificationCodeRequestFinished:(NSURLResponse *)response responseDic:(NSDictionary *)resDic
{
    if (![resDic bm_isNotEmptyDictionary])
    {
        [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailedWithProgressState:)])
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(loginClosedWithProgressState:)])
            {
                switch (self.m_VerificationType)
                {
                    case BMVerificationCodeType_Type1:
                        [self.delegate loginFailedWithProgressState:FSLoginProgress_RegistVerify];
                        break;
                        
                    case BMVerificationCodeType_Type2:
                        [self.delegate loginFailedWithProgressState:FSLoginProgress_ForgetVerify];
                        break;
                        
                    default:
                        break;
                }
            }
        }
        return;
    }
    
    BMLog(@"验证短信验证码返回数据是:+++++%@", resDic);
    
    NSInteger statusCode = [resDic bm_intForKey:@"code"];
    if (statusCode == 1000)
    {
        [self.m_ProgressHUD hideAnimated:NO];
        
        FSSetPassWordVC *setPassWordVC = [[FSSetPassWordVC alloc] initWithPhoneNum:self.m_PhoneNum verificationCode:self.m_VerifyField.text];
        setPassWordVC.delegate = self.delegate;
        setPassWordVC.m_IsRegist = self.m_IsRegist;
        [self.navigationController pushViewController:setPassWordVC animated:YES];
        
        return;
    }
    else
    {
        NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
        //[self.m_ProgressHUD showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        [self.m_ProgressHUD hideAnimated:NO];
        
        [self freshErrorLabelWithMessage:message];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailedWithProgressState:)])
    {
        switch (self.m_VerificationType)
        {
            case BMVerificationCodeType_Type1:
                [self.delegate loginFailedWithProgressState:FSLoginProgress_RegistVerify];
                break;
                
            case BMVerificationCodeType_Type2:
                [self.delegate loginFailedWithProgressState:FSLoginProgress_ForgetVerify];
                break;
                
            default:
                break;
        }
    }
}

- (void)checkVerificationCodeRequestFailed:(NSURLResponse *)response error:(NSError *)error
{
    BMLog(@"验证短信验证码失败的错误:++++%@", [FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE]);
    
    [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailedWithProgressState:)])
    {
        switch (self.m_VerificationType)
        {
            case BMVerificationCodeType_Type1:
                [self.delegate loginFailedWithProgressState:FSLoginProgress_RegistVerify];
                break;
                
            case BMVerificationCodeType_Type2:
                [self.delegate loginFailedWithProgressState:FSLoginProgress_ForgetVerify];
                break;
                
            default:
                break;
        }
    }
}


@end
