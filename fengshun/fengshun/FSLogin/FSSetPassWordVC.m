//
//  FSSetPassWordVC.m
//  fengshun
//
//  Created by jiang deng on 2018/8/30.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSetPassWordVC.h"
#import "AppDelegate.h"

@interface FSSetPassWordVC ()
{
    BOOL s_eyeOpen;
}

@property (nonatomic, assign) BMVerificationCodeType m_VerificationType;

@property (nonatomic, strong) NSString *m_PhoneNum;
@property (nonatomic, strong) NSString *m_VerificationCode;

@property (nonatomic, strong) BMTableViewSection *m_Section;
@property (nonatomic, strong) BMTextItem *m_PassWordItem;

@property (nonatomic, strong) UIButton *m_EyeBtn;

@property (nonatomic, strong) UIButton *m_ConfirmBtn;

@property (strong, nonatomic) NSURLSessionDataTask *m_RegistTask;
@property (strong, nonatomic) NSURLSessionDataTask *m_ResetPassWordTask;

@end

@implementation FSSetPassWordVC

- (void)dealloc
{
    [_m_RegistTask cancel];
    _m_RegistTask = nil;
    
    [_m_ResetPassWordTask cancel];
    _m_ResetPassWordTask = nil;
}

- (instancetype)initWithVerificationType:(BMVerificationCodeType)verificationType phoneNum:(NSString *)phoneNum verificationCode:(NSString *)VerificationCode
{
    self = [super init];
    
    if (self)
    {
        _m_VerificationType = verificationType;
        _m_PhoneNum = phoneNum;
        _m_VerificationCode = VerificationCode;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    s_eyeOpen = NO;
    
    self.bm_NavigationBarStyle = UIBarStyleDefault;
    self.bm_NavigationBarBgTintColor = [UIColor whiteColor];
    self.bm_NavigationItemTintColor = UI_COLOR_B2;
    
    if (self.m_VerificationType == BMVerificationCodeType_Type1)
    {
        [self bm_setNavigationWithTitle:@"设置密码" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_popback_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:@"navigationbar_close_icon" rightToucheEvent:@selector(closeAction:)];
    }
    else
    {
        [self bm_setNavigationWithTitle:@"重设密码" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_popback_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:@"navigationbar_close_icon" rightToucheEvent:@selector(closeAction:)];
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
        if (self.m_VerificationType == BMVerificationCodeType_Type1)
        {
            [self.delegate loginProgressStateChanged:FSLoginProgress_SetPassWord];
        }
        else
        {
            [self.delegate loginProgressStateChanged:FSLoginProgress_ChangePassWord];
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
            if (self.m_VerificationType == BMVerificationCodeType_Type1)
            {
                [self.delegate loginClosedWithProgressState:FSLoginProgress_SetPassWord];
            }
            else
            {
                [self.delegate loginClosedWithProgressState:FSLoginProgress_ChangePassWord];
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
    [super interfaceSettings];
    
    self.m_Section = [BMTableViewSection section];
    
    NSString *placeholder = [NSString stringWithFormat:@"请输入密码%@-%@位字母+数字", @(FSPASSWORD_MINLENGTH), @(FSPASSWORD_MAXLENGTH)];
    self.m_PassWordItem = [BMTextItem itemWithTitle:nil value:nil placeholder:placeholder];
    self.m_PassWordItem.textFieldTextFont = FS_CELLTITLE_TEXTFONT;
    self.m_PassWordItem.keyboardType = UIKeyboardTypeDefault;
    self.m_PassWordItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.m_PassWordItem.secureTextEntry = YES;
    self.m_PassWordItem.underLineDrawType = BMTableViewCell_UnderLineDrawType_SeparatorAllLeftInset;
    self.m_PassWordItem.underLineColor = FS_LINECOLOR;
    self.m_PassWordItem.cellBgColor = [UIColor clearColor];
    
    self.m_PassWordItem.image = [UIImage imageNamed:@"login_password"];
    
    self.m_PassWordItem.charactersLimit = FSPASSWORD_MAXLENGTH;
    
    UIButton *eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    eyeBtn.frame = CGRectMake(0, 0, 30.0f, 30.0f);
    eyeBtn.backgroundColor = [UIColor clearColor];
    [eyeBtn setImage:[UIImage imageNamed:@"login_closeeye"] forState:UIControlStateNormal];
    eyeBtn.exclusiveTouch = YES;
    [eyeBtn addTarget:self action:@selector(eyeClick:) forControlEvents:UIControlEventTouchUpInside];
    self.m_EyeBtn = eyeBtn;
    self.m_PassWordItem.accessoryView = eyeBtn;

    BMWeakSelf
    self.m_PassWordItem.onChange = ^(BMInputItem *item) {
        NSString *password = item.value;
        [weakSelf checkPassword:password];
    };
    
    [self.m_Section addItem:self.m_PassWordItem];
    [self.m_TableManager addSection:self.m_Section];
    
    // footer
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 70.0f)];
    footerView.backgroundColor = [UIColor clearColor];
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
    [btn setTitle:@"确认密码" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn bm_roundedRect:4.0f];
    self.m_ConfirmBtn = btn;
    
    [footerView addSubview:btn];
    [btn bm_centerInSuperView];

    [self checkPassword:nil];

    self.m_TableView.tableFooterView = footerView;
    [self.m_TableView reloadData];
}

- (void)checkPassword:(NSString *)password
{
    self.m_ConfirmBtn.enabled = (password.length >= FSPASSWORD_MINLENGTH && password.length <= FSPASSWORD_MAXLENGTH);
    if (self.m_ConfirmBtn.enabled)
    {
        self.m_ConfirmBtn.backgroundColor = UI_COLOR_BL1;
    }
    else
    {
        self.m_ConfirmBtn.backgroundColor = UI_COLOR_B5;
    }
}

- (void)eyeClick:(UIButton *)btn
{
    s_eyeOpen = !s_eyeOpen;
    
    self.m_PassWordItem.secureTextEntry = !s_eyeOpen;
    
    if (s_eyeOpen)
    {
        [self.m_EyeBtn setImage:[UIImage imageNamed:@"login_openeye"] forState:UIControlStateNormal];
    }
    else
    {
        [self.m_EyeBtn setImage:[UIImage imageNamed:@"login_closeeye"] forState:UIControlStateNormal];
    }
    
    [self.m_TableView reloadData];
}

- (void)confirmClick:(UIButton *)btn
{
    [self.view endEditing:YES];

    NSString *passWord = [self.m_PassWordItem.value bm_trim];
    if (![self verifyPassword:passWord])
    {
        return;
    }
    
    if (self.m_VerificationType == BMVerificationCodeType_Type1)
    {
        [self sendRegistRequestWithPhoneNum:self.m_PhoneNum passWord:passWord];
    }
    else
    {
        [self sendResetRequestWithPhoneNum:self.m_PhoneNum passWord:passWord];
    }
}


#pragma mark -
#pragma mark send request

// 注册
- (void)sendRegistRequestWithPhoneNum:(NSString *)phoneNum passWord:(NSString *)passWord
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest registWithPhoneNum:phoneNum password:passWord verificationCode:self.m_VerificationCode];
    if (request)
    {
        [self.m_ProgressHUD showAnimated:YES showBackground:NO];
        
        [self.m_RegistTask cancel];
        self.m_RegistTask = nil;
        
        BMWeakSelf
        self.m_RegistTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error)
            {
                BMLog(@"Error: %@", error);
                [weakSelf registRequestFailed:response error:error];
                
            }
            else
            {
#if DEBUG
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
#endif
                [weakSelf registRequestFinished:response responseDic:responseObject];
            }
        }];
        [self.m_RegistTask resume];
    }
}

- (void)registRequestFinished:(NSURLResponse *)response responseDic:(NSDictionary *)resDic
{
    if (![resDic bm_isNotEmptyDictionary])
    {
        [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailedWithProgressState:)])
        {
            [self.delegate loginFailedWithProgressState:FSLoginProgress_SetPassWord];
        }
        return;
    }
    
#if DEBUG
    NSString *responseStr = [[NSString stringWithFormat:@"%@", resDic] bm_convertUnicode];
    BMLog(@"注册返回数据是:+++++%@", responseStr);
#endif
    
    NSInteger statusCode = [resDic bm_intForKey:@"code"];
    if (statusCode == 1000)
    {
        [self.m_ProgressHUD hideAnimated:NO];
        
        NSDictionary *dataDic = [resDic bm_dictionaryForKey:@"data"];
        if ([dataDic bm_isNotEmptyDictionary])
        {
            FSUserInfoModle *userInfo = [FSUserInfoModle userInfoWithServerDic:dataDic isUpDateByUserInfoApi:NO];
            if (userInfo)
            {
                GetAppDelegate.m_UserInfo = userInfo;
                [FSUserInfoModle setCurrentUserID:userInfo.m_UserBaseInfo.m_UserId];
                [FSUserInfoModle setCurrentUserToken:userInfo.m_Token];
                
                [FSUserInfoDB insertAndUpdateUserInfo:userInfo];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(loginProgressStateChanged:)])
                {
                    [self.delegate loginProgressStateChanged:FSLoginProgress_FinishRegist];
                }
                
                [self closeAction:nil];
                
                return;
            }
        }
    }
    
    NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
    [self.m_ProgressHUD showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailedWithProgressState:)])
    {
        [self.delegate loginFailedWithProgressState:FSLoginProgress_SetPassWord];
    }
}

- (void)registRequestFailed:(NSURLResponse *)response error:(NSError *)error
{
    BMLog(@"注册失败的错误:++++%@", [FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE]);
    
    [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailedWithProgressState:)])
    {
        [self.delegate loginFailedWithProgressState:FSLoginProgress_SetPassWord];
    }
}

// 重置密码/忘记密码
- (void)sendResetRequestWithPhoneNum:(NSString *)phoneNum passWord:(NSString *)passWord
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request;
    
    if (self.m_VerificationType == BMVerificationCodeType_Type3)
    {
        request = [FSApiRequest changeUserPasswordWithPhoneNum:phoneNum newPassword:passWord verificationCode:self.m_VerificationCode];
    }
    else
    {
        request = [FSApiRequest resetUserPasswordWithPhoneNum:phoneNum newPassword:passWord verificationCode:self.m_VerificationCode];
    }
    if (request)
    {
        [self.m_ProgressHUD showAnimated:YES showBackground:NO];
        
        [self.m_ResetPassWordTask cancel];
        self.m_ResetPassWordTask = nil;
        
        BMWeakSelf
        self.m_ResetPassWordTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error)
            {
                BMLog(@"Error: %@", error);
                [weakSelf resetRequestFailed:response error:error];
                
            }
            else
            {
#if DEBUG
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
#endif
                [weakSelf resetRequestFinished:response responseDic:responseObject];
            }
        }];
        [self.m_ResetPassWordTask resume];
    }
}

- (void)resetRequestFinished:(NSURLResponse *)response responseDic:(NSDictionary *)resDic
{
    if (![resDic bm_isNotEmptyDictionary])
    {
        [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailedWithProgressState:)])
        {
            [self.delegate loginFailedWithProgressState:FSLoginProgress_ChangePassWord];
        }
        return;
    }
    
#if DEBUG
    NSString *responseStr = [[NSString stringWithFormat:@"%@", resDic] bm_convertUnicode];
    BMLog(@"重设密码返回数据是:+++++%@", responseStr);
#endif
    
    NSInteger statusCode = [resDic bm_intForKey:@"code"];
    if (statusCode == 1000)
    {
        [self.m_ProgressHUD hideAnimated:NO];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginProgressStateChanged:)])
        {
            [self.delegate loginProgressStateChanged:FSLoginProgress_FinishForget];
        }
        
        if (self.m_VerificationType == BMVerificationCodeType_Type3)
        {
            [GetAppDelegate logOut];
        }
        else
        {
            [self backRootAction:nil];
        }
        return;
    }
    
    NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
    [self.m_ProgressHUD showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailedWithProgressState:)])
    {
        [self.delegate loginFailedWithProgressState:FSLoginProgress_ChangePassWord];
    }
}

- (void)resetRequestFailed:(NSURLResponse *)response error:(NSError *)error
{
    BMLog(@"重设密码失败的错误:++++%@", [FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE]);
    
    [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailedWithProgressState:)])
    {
        [self.delegate loginFailedWithProgressState:FSLoginProgress_ChangePassWord];
    }
}


@end
