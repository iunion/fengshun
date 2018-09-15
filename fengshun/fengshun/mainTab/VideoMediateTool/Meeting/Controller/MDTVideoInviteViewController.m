//
//  MDTVideoInviteViewController.m
//  ODR
//
//  Created by DH on 2018/7/16.
//  Copyright © 2018年 DH. All rights reserved.
//
#define kMarginButtonToTitleRight 25

#import "MDTVideoInviteViewController.h"
//#import "UIButton+XQAdd.h"
//#import "NSString+XQAdd.h"//校验手机号、邮箱正则

@interface MDTVideoInviteViewController ()
@property (nonatomic, assign) NSInteger meetingID;
@property (nonatomic, assign) NSInteger caseId;
@property (nonatomic, strong) UITextField *phoneTextField;

@end


@implementation MDTVideoInviteViewController
+ (instancetype)vcWithMeetingID:(NSInteger )meetingID caseId:(NSInteger)caseID{
    MDTVideoInviteViewController *vc= [MDTVideoInviteViewController new];
    vc.meetingID = meetingID;
    vc.caseId = caseID;
    return vc;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
//    self.navigationItem.title = @"邀请观摩";
//    self.view.backgroundColor = kBGColor;
//
//    UIView *view01 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
//    view01.backgroundColor = kWhiteColor;
//    [self.view addSubview:view01];
//    {
//        UILabel *lable01 = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 14*4+2, 14)];
//        lable01.text = @"手机号";
//        lable01.font = kFont(14);
//        lable01.textAlignment = NSTextAlignmentLeft;
//        lable01.textColor = kGrayColor3;
//        [view01 addSubview:lable01];
//
//        UITextField *textfield01 = [[UITextField alloc] initWithFrame:CGRectMake(20+14*3+2+26, 18, kScreenWidth-(20+14*3+2+26)-5-80-10-5, 14)];
//        textfield01.placeholder = @"请输入手机号";
//        textfield01.clearButtonMode=UITextFieldViewModeNever;
//        textfield01.textAlignment = NSTextAlignmentLeft;
//        textfield01.keyboardType = UIKeyboardTypeNumberPad;
//        textfield01.textColor = kGrayColor3;
//        textfield01.font = kFont(14);
//        _phoneTextField = textfield01;
//        [view01 addSubview:textfield01];
//    }
//    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(15, 50, kScreenWidth-30, 0.5)];
//    lineView1.backgroundColor = kLineColor;
//    [self.view addSubview:lineView1];
//
//    CGFloat cpViewHeigh = 60;
//    UIView *sendView = [[UIView alloc] initWithFrame:CGRectMake(0, 50.5+20, kScreenWidth, cpViewHeigh)];
//    sendView.backgroundColor = kBGColor;
//    [self.view addSubview:sendView];
//    {
//        CGFloat cpBtnW = 300*kScreenWidth/375.0;
//        CGFloat cpBtnH = 40*cpViewHeigh/60.0;
//        CGFloat cpBtnX = (kScreenWidth- cpBtnW)/2;
//        CGFloat cpBtnY = (cpViewHeigh - cpBtnH)/2;
//        UIButton *cpBtn = [[UIButton alloc] initWithFrame:CGRectMake(cpBtnX, cpBtnY, cpBtnW, cpBtnH)];
//        cpBtn.backgroundColor = kAOrangeColor;
//        cpBtn.layer.cornerRadius = 3;
//        [cpBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
//        [cpBtn setTitle:@"发送" forState:UIControlStateNormal];
//        cpBtn.titleLabel.font = kFont16;
//        [cpBtn addTarget:self action:@selector(onClickSaveButton:) forControlEvents:UIControlEventTouchUpInside];
//        [sendView addSubview:cpBtn];
//    }
}

- (void)onClickSaveButton:(UIButton *)sender {
    
//    if (_phoneTextField.text.hash == @"".hash) {
//        showError(@"请输入11位有效手机号码", self.navigationController.view);
//        return;
//    }
//    
//    if (![_phoneTextField.text jk_isMobileNumber]) {
//        showError(@"请输入11位有效手机号码", self.navigationController.view);
//        return;
//    }
//    
//    NSDictionary *params = @{@"caseId" : @(_caseId),
//                             @"meetingId" : @(_meetingID),
//                             @"phone" : _phoneTextField.text
//                             };
//    //选择的是普通用户
//    DHProgressHUD *hud = [DHProgressHUD dh_showJuHuaWithTitle:nil addToView:self.navigationController.view];
//    [[RequestClient sharedClient] POST:@"mastiff/caseMeeting/inviteSendSms" parameters:params configurationHandler:nil completeBlock:^(NSError *error, id result, BOOL isFromCache, NSURLSessionTask *task) {
//        if (!error) {
//            //成功了 退回当前页面
//            showSuccess(@"操作成功", self.view);
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//        } else {
//            showError(error.localizedFailureReason, self.navigationController.view);
//        }
//        [hud dh_hiddenJuHua];
//    }];
}


@end
