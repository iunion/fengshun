//
//  FSAuthVC.m
//  fengshun
//
//  Created by BeSt2wa on 2018/12/21.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSAuthVC.h"
#import "FSInputTextView.h"
#import "AppDelegate.h"

@interface FSAuthVC ()

@property (nonatomic , assign) FSAuthState m_AuthState;//认证和昵称状态
@property (nonatomic , strong) FSInputTextView *m_NikeName;///< 昵称
@property (nonatomic , strong) FSInputTextView *m_RealName;///< 真实姓名
@property (nonatomic , strong) FSInputTextView *m_IdCard;///< 身份证号码

@property (nonatomic , strong) UILabel *m_NikeNameLab;
@property (nonatomic , strong) UILabel *m_AuthLab;

@property (nonatomic , strong) UIButton *m_SubmitBtn;// 提交按钮

@end

@implementation FSAuthVC

+ (instancetype)vcWithAuthType:(FSAuthState)type
{
    FSAuthVC *vc = [FSAuthVC new];
    vc.m_AuthState = type;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}

- (void)createUI
{
    [self bm_setNavigationWithTitle:@"完善账户信息" barTintColor:nil leftDicArray:@[[self bm_makeBarButtonDictionaryWithTitle:@" " image:@"navigationbar_back_icon" toucheEvent:@"backAction:" buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:0]] rightDicArray:nil];
    CGFloat height = 45.f;
    CGFloat width  = UI_SCREEN_WIDTH;
    
    {
        _m_NikeNameLab = [UILabel bm_labelWithFrame:CGRectMake(20, 0, width - 40, height) text:@"发布内容前请设置昵称" fontSize:14.f color:RGBColor(153, 153, 153, 1) alignment:NSTextAlignmentLeft lines:1];
        [self.view addSubview:_m_NikeNameLab];
        _m_NikeName = [[FSInputTextView alloc]initWithFrame:CGRectMake(0, 0, width , height) title:@"昵称" content:@"" placeHolder:@"支持中英文数字及下划线，不超过16个字符"];
        _m_NikeName.m_IsShowBottomLine = NO;
        _m_NikeName.bm_width = width;
        _m_NikeName.bm_height = height;
        [self.view addSubview:_m_NikeName];
    }
    
    {
        _m_AuthLab = [UILabel bm_labelWithFrame:CGRectMake(20, 0, width - 40, height) text:@"发布内容前请完成实名认证" fontSize:14.f color:RGBColor(153, 153, 153, 1) alignment:NSTextAlignmentLeft lines:1];
        [self.view addSubview:_m_AuthLab];
        
        _m_RealName = [[FSInputTextView alloc]initWithFrame:CGRectMake(0, 0, width , height) title:@"姓名" content:@"" placeHolder:@"请输入您的姓名"];
        _m_RealName.bm_width = width;
        _m_RealName.bm_height = height;
        [self.view addSubview:_m_RealName];
        
        _m_IdCard = [[FSInputTextView alloc]initWithFrame:CGRectMake(0, 0, width , height) title:@"身份证号" content:@"" placeHolder:@"请输入您的身份证号码"];
        _m_IdCard.m_IsShowBottomLine = NO;
        _m_IdCard.bm_width = width;
        _m_IdCard.bm_height = height;
        [self.view addSubview:_m_IdCard];
    }
    {
        _m_SubmitBtn = [UIButton bm_buttonWithFrame:CGRectMake(20, 0, width - 40, 40.f) title:@"" backgroundImage:[UIImage imageWithColor:RGBColor(87, 126, 237, 1)] highlightedBackgroundImage:nil];
        [_m_SubmitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_m_SubmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_m_SubmitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _m_SubmitBtn.layer.masksToBounds = YES;
        _m_SubmitBtn.layer.cornerRadius = 4;
        [self.view addSubview:_m_SubmitBtn];
    }
    {
        [self updateState];
    }
    [self bringSomeViewToFront];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)submitBtnClick:(UIButton *)sender
{
    if (![self canSubmitMessage])
    {
        return;
    }
    BMWeakSelf
    [FSApiRequest completeUserMessageWithRealName:_m_RealName.m_Content idCard:_m_IdCard.m_Content nikeName:_m_NikeName.m_Content Success:^(id  _Nullable responseObject) {
        [weakSelf updateUserMsg];
        if (weakSelf.complateUserMessage)
        {
            weakSelf.complateUserMessage();
        }
        [self backAction:nil];
    } failure:^(NSError * _Nullable error) {
        
    }];
}



/**
 刷新视图
 */
- (void)updateState
{
    switch (self.m_AuthState) {
        case FSAuthStateNone:// 啥都没有
        {
            self.m_NikeNameLab.hidden = NO;
            self.m_NikeName.hidden = NO;
            self.m_AuthLab.hidden = NO;
            self.m_RealName.hidden = NO;
            self.m_IdCard.hidden = NO;
            
            self.m_AuthLab.bm_top = 0;
            self.m_RealName.bm_top = self.m_AuthLab.bm_bottom;
            self.m_IdCard.bm_top = self.m_RealName.bm_bottom;
            self.m_NikeNameLab.bm_top = self.m_IdCard.bm_bottom;
            self.m_NikeName.bm_top = self.m_NikeNameLab.bm_bottom;
            self.m_SubmitBtn.bm_top = self.m_NikeName.bm_bottom + 40.f;
        }
            break;
        case FSAuthStateNoAuth:// 没认证
        {
            self.m_NikeNameLab.hidden = YES;
            self.m_NikeName.hidden = YES;
            self.m_AuthLab.hidden = NO;
            self.m_RealName.hidden = NO;
            self.m_IdCard.hidden = NO;
            
            self.m_AuthLab.bm_top = 0;
            self.m_RealName.bm_top = self.m_AuthLab.bm_bottom;
            self.m_IdCard.bm_top = self.m_RealName.bm_bottom;
            self.m_SubmitBtn.bm_top = self.m_IdCard.bm_bottom + 40.f;
        }
            break;
        case FSAuthStateNoNickName:// 没昵称
        {
            self.m_NikeNameLab.hidden = NO;
            self.m_NikeName.hidden = NO;
            self.m_AuthLab.hidden = YES;
            self.m_RealName.hidden = YES;
            self.m_IdCard.hidden = YES;
            
            
            self.m_NikeNameLab.bm_top = 0;
            self.m_NikeName.bm_top = self.m_NikeNameLab.bm_bottom;
            self.m_SubmitBtn.bm_top = self.m_NikeName.bm_bottom + 40.f;
        }
            break;
        case FSAuthStateAllDone:
        default:
            self.m_NikeNameLab.hidden = YES;
            self.m_NikeName.hidden = YES;
            self.m_AuthLab.hidden = YES;
            self.m_RealName.hidden = YES;
            self.m_IdCard.hidden = YES;
            break;
    }
}

/**
 刷新本地数据库
 */
- (void)updateUserMsg
{
    FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
    switch (self.m_AuthState) {
        case FSAuthStateNone:// 啥都没有
        {
            userInfo.m_UserBaseInfo.m_RealName = _m_RealName.m_Content;
            userInfo.m_UserBaseInfo.m_IdCardNo = _m_IdCard.m_Content;
            userInfo.m_UserBaseInfo.m_IsRealName = YES;
            userInfo.m_UserBaseInfo.m_NickName = _m_NikeName.m_Content;
        }
            break;
        case FSAuthStateNoAuth:// 没认证
        {
            userInfo.m_UserBaseInfo.m_RealName = _m_RealName.m_Content;
            userInfo.m_UserBaseInfo.m_IdCardNo = _m_IdCard.m_Content;
            userInfo.m_UserBaseInfo.m_IsRealName = YES;
        }
            break;
        case FSAuthStateNoNickName:// 没昵称
        {
            userInfo.m_UserBaseInfo.m_NickName = _m_NikeName.m_Content;
        }
            break;
        case FSAuthStateAllDone:
        default:
            
            break;
    }
    [FSUserInfoDB insertAndUpdateUserInfo:userInfo];
    GetAppDelegate.m_UserInfo = userInfo;
}

/**
 提交参数判断

 @return 是否能提交
 */
- (BOOL)canSubmitMessage
{
    if (self.m_AuthState == FSAuthStateNoAuth)
    {
        if (![self.m_RealName.m_Content bm_isNotEmpty])
        {
            [self.m_ProgressHUD showAnimated:YES withText:@"请输入真实姓名" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            return NO;
        }
        if (![self.m_IdCard.m_Content bm_isNotEmpty] || self.m_IdCard.m_Content.length != 18)
        {
            [self.m_ProgressHUD showAnimated:YES withText:@"请输入正确身份证号码" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            return NO;
        }
        return YES;
    }
    else if (self.m_AuthState == FSAuthStateNoNickName)
    {
        if (![self.m_NikeName.m_Content bm_isNotEmpty])
        {
            [self.m_ProgressHUD showAnimated:YES withText:@"请输入昵称" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            return NO;
        }
        return YES;
    }else if (self.m_AuthState == FSAuthStateNone)
    {
        if (![self.m_RealName.m_Content bm_isNotEmpty])
        {
            [self.m_ProgressHUD showAnimated:YES withText:@"请输入真实姓名" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            return NO;
        }
        if (![self.m_IdCard.m_Content bm_isNotEmpty] || self.m_IdCard.m_Content.length != 18)
        {
            [self.m_ProgressHUD showAnimated:YES withText:@"请输入正确身份证号码" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            return NO;
        }
        if (![self.m_NikeName.m_Content bm_isNotEmpty])
        {
            [self.m_ProgressHUD showAnimated:YES withText:@"请输入昵称" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            return NO;
        }
        return YES;
    }
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
