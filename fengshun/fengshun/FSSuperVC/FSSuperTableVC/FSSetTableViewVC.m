//
//  FSSetTableViewVC.m
//  fengshun
//
//  Created by jiang deng on 2018/8/29.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSetTableViewVC.h"
#import "NSString+BMRegEx.h"

@interface FSSetTableViewVC ()

@property (nonatomic, strong) BMTableViewManager *m_TableManager;

@end

@implementation FSSetTableViewVC
@synthesize m_FreshViewType = _m_FreshViewType;

- (BMFreshViewType)getFreshViewType
{
    return BMFreshViewType_NONE;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _m_FreshViewType = BMFreshViewType_NONE;
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil freshViewType:(BMFreshViewType)freshViewType
{
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil freshViewType:BMFreshViewType_NONE];
}


- (void)viewDidLoad
{
    _m_FreshViewType = [self getFreshViewType];
    
    self.m_TableViewStyle = UITableViewStyleGrouped;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.m_TableView.bounces = NO;

    s_IsNoMorePage = YES;

//    if (IS_IPHONE6P || IS_IPHONEXP)
//    {
//        self.m_TableView.bm_left = 20.0f;
//        self.m_TableView.bm_width = UI_SCREEN_WIDTH-40.0f;
//    }
//    else if (IS_IPHONE6 || IS_IPHONEX)
//    {
//        self.m_TableView.bm_left = 15.0f;
//        self.m_TableView.bm_width = UI_SCREEN_WIDTH-30.0f;
//    }
//    else
//    {
//        self.m_TableView.bm_left = 10.0f;
//        self.m_TableView.bm_width = UI_SCREEN_WIDTH-20.0f;
//    }
    
    self.m_showEmptyView = NO;
    self.m_AllowEmptyJson = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)needKeyboardEvent
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self needKeyboardEvent])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        // 监听输入法状态
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeInputMode:) name:UITextInputCurrentInputModeDidChangeNotification object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self needKeyboardEvent])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        //[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextInputCurrentInputModeDidChangeNotification object:nil];
    }
}


#pragma mark -
#pragma mark keyboardEvent

- (void)keyboardWillShow:(NSNotification *)notification
{
    UIView *view = [self.m_TableView bm_firstResponder];
    BMTableViewCell *cell = (BMTableViewCell *)[view bm_superViewWithClass:[BMTableViewCell class]];
    CGPoint relativePoint = [cell convertPoint:CGPointZero toView:[UIApplication sharedApplication].keyWindow];
//    CGPoint testPoint = [cell convertPoint:CGPointZero toView:self.m_TableView];
//    NSLog(@"testPoint = %@",NSStringFromCGPoint(testPoint));
    CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat actualHeight = CGRectGetHeight(cell.frame) + relativePoint.y + keyboardHeight;
    CGFloat overstep = actualHeight - CGRectGetHeight([UIScreen mainScreen].bounds);// + 5;
    if (overstep > 1)
    {
        CGFloat now = self.m_TableView.contentOffset.y;
        CGFloat new = now + overstep;
        [self.m_TableView setContentOffset:CGPointMake(0, new) animated:YES];
//        CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//        CGRect frame = [UIScreen mainScreen].bounds;
//        frame.origin.y -= overstep;
//        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations: ^{
//            [UIApplication sharedApplication].keyWindow.frame = frame;
//        } completion:nil];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = [UIScreen mainScreen].bounds;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations: ^{
        [UIApplication sharedApplication].keyWindow.frame = frame;
    } completion:nil];
}

//// 切换输入法
//- (void)keyboardChangeInputMode:(NSNotification *)notification
//{
//    //UITextInputMode *currentInputMode = [UITextInputMode currentInputMode];
//    UITextInputMode *currentInputMode = [notification object];
//
//    NSString *inputMethod = currentInputMode.primaryLanguage;
//    NSLog(@"inputMethod = %@", inputMethod);
//}

- (void)interfaceSettings
{
    self.m_TableManager = [[BMTableViewManager alloc] initWithTableView:self.m_TableView];
    self.m_TableManager.delegate = self;
}

- (void)freshViews
{
    
}


#pragma mark -
#pragma mark 输入校验

// 手机号
- (BOOL)verifyPhoneNum:(NSString *)phoneNum
{
    return [self verifyPhoneNum:phoneNum showMessage:YES];
}

- (BOOL)verifyPhoneNum:(NSString *)phoneNum showMessage:(BOOL)showMessage
{
    if (![phoneNum bm_isNotEmpty])
    {
        if (showMessage)
        {
            [self.m_ProgressHUD showAnimated:YES withDetailText:@"请输入手机号码" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
        
        return NO;
    }
    else if (![phoneNum bm_isValidChinesePhoneNumber])
    {
        if (showMessage)
        {
            [self.m_ProgressHUD showAnimated:YES withDetailText:@"请输入正确的手机号码" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
        
        return NO;
    }
    
    return YES;
}

// 密码
- (BOOL)verifyPassword:(NSString *)password
{
    return [self verifyPassword:password showMessage:YES];
}

- (BOOL)verifyPassword:(NSString *)password showMessage:(BOOL)showMessage
{
    if (![password bm_isNotEmpty])
    {
        if (showMessage)
        {
            [self.m_ProgressHUD showAnimated:YES withDetailText:@"请输入账户密码(8~16位)" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
        
        return NO;
    }
    else if (![password bm_isValidPassword])
    {
        if (showMessage)
        {
            [self.m_ProgressHUD showAnimated:YES withDetailText:[NSString stringWithFormat:@"请输入%@-%@位字母+数字，字母区分大小写", @(FSPASSWORD_MINLENGTH), @(FSPASSWORD_MAXLENGTH)] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
        
        return NO;
    }
    
    return YES;
}

// 身份证号
- (BOOL)verifyId:(NSString *)idNum
{
    return [self verifyId:idNum showMessage:YES];
}

- (BOOL)verifyId:(NSString *)idNum showMessage:(BOOL)showMessage
{
    if (![idNum bm_isNotEmpty])
    {
        if (showMessage)
        {
            [self.m_ProgressHUD showAnimated:YES withDetailText:@"请输入身份证号码" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
        
        return NO;
    }
    else if (![idNum bm_isValidChineseIDNumberString])
    {
        if (showMessage)
        {
            [self.m_ProgressHUD showAnimated:YES withDetailText:@"请输入正确的身份证号码" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
        
        return NO;
    }
    
    return YES;
}

@end
