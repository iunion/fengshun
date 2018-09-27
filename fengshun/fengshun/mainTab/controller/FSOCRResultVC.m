//
//  FSOCRResultVC.m
//  fengshun
//
//  Created by Aiwei on 2018/9/17.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSOCRResultVC.h"
#import "FSOCRManager.h"
#import "MBProgressHUD.h"
#import "FSMoreViewVC.h"

@interface FSOCRResultVC ()
<
FSMoreViewVCDelegate
>
@property (nonatomic, strong) MBProgressHUD *m_ProgressHUD;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *m_toolButtons;
@property (weak, nonatomic) IBOutlet UITextView *m_textView;
@end

@implementation FSOCRResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self OCRAction];
}
- (void)setupUI
{
    self.bm_NavigationShadowHidden = NO;
    self.bm_NavigationShadowColor  = UI_COLOR_B6;
    [self bm_setNavigationLeftItemTintColor:UI_COLOR_B1];
    [self bm_setNavigationWithTitle:nil barTintColor:nil leftItemTitle:@"" leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    [self setBm_NavigationBarImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    for (UIButton *toolButton in _m_toolButtons)
    {
        [toolButton bm_roundedRect:15 borderWidth:0.5 borderColor:UI_COLOR_BL1];
    }
    self.m_ProgressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.m_ProgressHUD.animationType = MBProgressHUDAnimationFade;
    [self.view addSubview:self.m_ProgressHUD];
    self.m_textView.textContainerInset = UIEdgeInsetsMake(22, 15, 22, 15);
}
- (void)OCRAction
{
    if (![_m_orcImage bm_isNotEmpty]) {
        return;
    }
    [self.m_ProgressHUD showAnimated:YES showBackground:NO];
    [[FSOCRManager manager]ocr_getTextWithImage:_m_orcImage succeed:^(NSString *text) {
        [self.m_ProgressHUD hideAnimated:YES];
        self.m_textView.text = text;
    } failed:^(NSError *error) {
        [self.m_ProgressHUD showAnimated:YES withText:@"文字识别出错" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toolButtonAction:(UIButton *)sender {
    if (sender.tag) {
        // 复制全部
        if ([_m_textView.text bm_isNotEmpty]) {
            UIPasteboard *pBoard = [UIPasteboard generalPasteboard];
            pBoard.string = _m_textView.text;
            [self.m_ProgressHUD showAnimated:YES withText:@"已复制到粘贴板" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
    }
    else
    {
        // 分享
        [FSMoreViewVC showShareAlertView:self delegate:self];
    }
}
// 分享
- (void)moreViewClickWithType:(NSInteger)index
{
    
}

@end
