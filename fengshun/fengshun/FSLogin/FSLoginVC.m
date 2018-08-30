//
//  FSLoginVC.m
//  fengshun
//
//  Created by jiang deng on 2018/8/29.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSLoginVC.h"
#import "FSAppInfo.h"
#import "NSString+BMFormat.h"

#import "FSLoginVerifyVC.h"

@interface FSLoginVC ()
{
    BOOL s_isLogin;
}

@property (nonatomic, strong) BMTableViewSection *m_Section;

@property (nonatomic, strong) BMTextItem *m_PhoneItem;
@property (nonatomic, strong) BMTextItem *m_PassWordItem;

@property (nonatomic, strong) UILabel *m_WelcomeLabel;
@property (nonatomic, strong) UIButton *m_ConfirmBtn;
@property (nonatomic, strong) UIButton *m_ForgetBtn;

@property (nonatomic, strong) NSString *m_PhoneNum;

@end

@implementation FSLoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    s_isLogin = NO;
    
    self.bm_NavigationBarStyle = UIBarStyleDefault;
    self.bm_NavigationBarBgTintColor = [UIColor whiteColor];
    self.bm_NavigationItemTintColor = UI_COLOR_B2;
    
    [self bm_setNavigationWithTitle:@"" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_close_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];

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

- (BOOL)needKeyboardEvent
{
    return YES;
}

- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginClosedWithProgressState:)])
        {
            if (self->s_isLogin)
            {
                [self.delegate loginClosedWithProgressState:FSLoginProgress_InputPassWord];
            }
            else
            {
                [self.delegate loginClosedWithProgressState:FSLoginProgress_LoginPhone];
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
    
    self.m_PhoneItem = [BMTextItem itemWithTitle:nil value:nil placeholder:@"请输入手机号码"];
    self.m_PhoneItem.keyboardType = UIKeyboardTypeNumberPad;
    self.m_PhoneItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.m_PhoneItem.underLineDrawType = BMTableViewCell_UnderLineDrawType_SeparatorAllLeftInset;
    self.m_PhoneItem.underLineColor = FS_LINECOLOR;
    self.m_PhoneItem.cellBgColor = [UIColor clearColor];

    self.m_PhoneItem.image = [UIImage imageNamed:@"login_mobile"];
    
    // 获取预留电话号码
    self.m_PhoneItem.value = [FSAppInfo getCurrentPhoneNum];
    self.m_PhoneItem.charactersLimit = FSPHONENUMBER_LENGTH;
    
    BMWeakSelf
    self.m_PhoneItem.onChange = ^(BMInputItem *item) {
        NSString *phoneNum = item.value;
        [weakSelf checkPhoneNum:phoneNum];
    };
    
    [self.m_Section addItem:self.m_PhoneItem];
    [self.m_TableManager addSection:self.m_Section];
    
    // header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 200.0f)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150.0f, 150.0f)];
    logoImageView.image = [UIImage imageNamed:@"login_logo"];
    [headerView addSubview:logoImageView];
    [logoImageView bm_centerHorizontallyInSuperViewWithTop:10.0f];
    
    self.m_WelcomeLabel = [UILabel bm_labelWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 24.0f) text:@"" fontSize:15.0f color:UI_COLOR_B5 alignment:NSTextAlignmentCenter lines:1];
    [headerView addSubview:self.m_WelcomeLabel];
    [self.m_WelcomeLabel bm_centerHorizontallyInSuperViewWithTop:logoImageView.bm_bottom+10];
    self.m_WelcomeLabel.hidden = YES;

    self.m_TableView.tableHeaderView = headerView;
    
    // footer
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 130.0f)];
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
    btn.titleLabel.font = UI_FONT_17;
    btn.exclusiveTouch = YES;
    [btn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn bm_roundedRect:4.0f];
    self.m_ConfirmBtn = btn;
    
    [footerView addSubview:btn];
    [btn bm_centerHorizontallyInSuperViewWithTop:10.0f];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(btn.bm_right-60, btn.bm_bottom+10, 60, 40);
    forgetBtn.backgroundColor = [UIColor clearColor];
    forgetBtn.titleLabel.font = UI_FONT_14;
    forgetBtn.exclusiveTouch = YES;
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:UI_COLOR_B4 forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:forgetBtn];
    forgetBtn.hidden = YES;
    self.m_ForgetBtn = forgetBtn;

    self.m_TableView.tableFooterView = footerView;

    [weakSelf checkPhoneNum:self.m_PhoneItem.value];

    [self.m_TableView reloadData];
}

- (void)checkPhoneNum:(NSString *)phoneNum
{
    self.m_ConfirmBtn.enabled = (phoneNum.length == FSPHONENUMBER_LENGTH);
    if (self.m_ConfirmBtn.enabled)
    {
        self.m_ConfirmBtn.backgroundColor = UI_COLOR_BL1;
    }
    else
    {
        self.m_ConfirmBtn.backgroundColor = UI_COLOR_B5;
    }
}

- (void)confirmClick:(UIButton *)btn
{
    FSLoginVerifyVC *loginVerifyVC = [[FSLoginVerifyVC alloc] initWithVerificationType:BMVerificationCodeType_Type1 phoneNum:@"13569768888"];
    loginVerifyVC.m_IsRegist = YES;
    [self.navigationController pushViewController:loginVerifyVC animated:YES];
    
    return;
    
    if (!s_isLogin)
    {
        //NSString *phoneNum = [self.m_PhoneItem.value bm_trim];
        if (![self verifyPhoneNum:self.m_PhoneItem.value])
        {
            return;
        }
        
        self.m_PhoneNum = self.m_PhoneItem.value;
        
        s_isLogin = YES;
        
        [self freshView];
    }
    else
    {
        if (![self verifyPassword:self.m_PassWordItem.value])
        {
            return;
        }
        
        [self backAction:nil];
    }
}

- (void)freshView
{
    if (!s_isLogin)
    {
        return;
    }
    
    [self.m_Section removeAllItems];

    self.m_WelcomeLabel.hidden = NO;
    self.m_WelcomeLabel.text = [NSString stringWithFormat:@"欢迎%@登录", [self.m_PhoneNum bm_maskAtRang:NSMakeRange(3, 4) withMask:'*']];
    
    [self.m_ConfirmBtn setTitle:@"登录" forState:UIControlStateNormal];
    self.m_ForgetBtn.hidden = NO;

    self.m_PassWordItem = [BMTextItem itemWithTitle:nil value:nil placeholder:@"请输入账号密码"];
    self.m_PassWordItem.keyboardType = UIKeyboardTypeDefault;
    self.m_PassWordItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.m_PassWordItem.underLineDrawType = BMTableViewCell_UnderLineDrawType_SeparatorAllLeftInset;
    self.m_PassWordItem.underLineColor = FS_LINECOLOR;
    self.m_PassWordItem.cellBgColor = [UIColor clearColor];
    
    self.m_PassWordItem.image = [UIImage imageNamed:@"login_password"];
    
    self.m_PassWordItem.charactersLimit = FSPASSWORD_MAXLENGTH;
    
    BMWeakSelf
    self.m_PassWordItem.onChange = ^(BMInputItem *item) {
        NSString *password = item.value;
        [weakSelf checkPassword:password];
    };
    
    [self.m_Section addItem:self.m_PassWordItem];

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

- (void)forgetClick:(UIButton *)btn
{
    
}

@end
