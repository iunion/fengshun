//
//  FSSetPassWordVC.m
//  fengshun
//
//  Created by jiang deng on 2018/8/30.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSetPassWordVC.h"

@interface FSSetPassWordVC ()
{
    BOOL s_eyeOpen;
}

@property (nonatomic, strong) NSString *m_PhoneNum;

@property (nonatomic, strong) BMTableViewSection *m_Section;
@property (nonatomic, strong) BMTextItem *m_PassWordItem;

@property (nonatomic, strong) UIButton *m_EyeBtn;

@property (nonatomic, strong) UIButton *m_ConfirmBtn;

@property (strong, nonatomic) NSURLSessionDataTask *m_SetPassWordTask;

@end

@implementation FSSetPassWordVC

- (void)dealloc
{
    [_m_SetPassWordTask cancel];
    _m_SetPassWordTask = nil;
}

- (instancetype)initWithPhoneNum:(NSString *)phoneNum
{
    self = [super init];
    
    if (self)
    {
        _m_PhoneNum = phoneNum;
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
    
    [self bm_setNavigationWithTitle:@"设置密码" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:@"navigationbar_close_icon" rightToucheEvent:@selector(closeAction:)];

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
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginProgressStateChanged:)])
    {
        if (self.m_IsRegist)
        {
            [self.delegate loginProgressStateChanged:FSLoginProgress_SetPassWord];
        }
        else
        {
            [self.delegate loginProgressStateChanged:FSLoginProgress_ChangePassWord];
        }
    }
    
    [self interfaceSettings];
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
            if (self.m_IsRegist)
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
    
    self.m_PassWordItem = [BMTextItem itemWithTitle:nil value:nil placeholder:@"请输入密码"];
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
    btn.titleLabel.font = UI_FONT_17;
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

    if (![self verifyPassword:self.m_PassWordItem.value])
    {
        return;
    }
}

@end
