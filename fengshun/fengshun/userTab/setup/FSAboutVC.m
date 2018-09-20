//
//  FSAboutVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/20.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSAboutVC.h"

@interface FSAboutVC ()

@property (weak, nonatomic) IBOutlet UIView *m_TopBgView;
@property (weak, nonatomic) IBOutlet UIImageView *m_IconImageView;
@property (weak, nonatomic) IBOutlet UILabel *m_VersionLabel;

@property (weak, nonatomic) IBOutlet UITextView *m_IntrTextView;

@property (weak, nonatomic) IBOutlet UIView *m_BottomBgView;
@property (weak, nonatomic) IBOutlet UILabel *m_CopyRightLabel;

@end

@implementation FSAboutVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = FS_VIEW_BGCOLOR;
    
    self.m_TableView.hidden = YES;

    [self bm_setNavigationWithTitle:@"关于我们" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    
    [self interfaceSettings];
}

- (BOOL)needKeyboardEvent
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)interfaceSettings
{
    [super interfaceSettings];
    
    self.m_IconImageView.image = [UIImage imageNamed:@"fs_icon"];
    
    self.m_VersionLabel.textColor = UI_COLOR_B4;
#ifdef DEBUG
    self.m_VersionLabel.text = [NSString stringWithFormat:@"枫调理顺V%@", APP_BUILDNO];
#else
    self.m_VersionLabel.text = [NSString stringWithFormat:@"枫调理顺V%@", APP_VERSIONNO];
#endif

    self.m_IntrTextView.textColor = UI_COLOR_B4;
    NSString *text = @"枫调理顺是北明软件专门为全国的调解员群体而研发推出的移动端应用。APP主要为调解员提供以下3方面的服务：\n1.常用的工具，利于调解员工作的展开；\n2.调解员培训，助力调解员的成长；\n3.社区，方便沟通，丰富生活。";
    NSMutableAttributedString *atrStr = [[NSMutableAttributedString alloc] initWithString:text];
    [atrStr bm_setFont:[UIFont systemFontOfSize:14.0f]];
    [atrStr bm_setTextColor:UI_COLOR_B4];
    [atrStr bm_setAttributeAlignmentStyle:NSTextAlignmentLeft lineSpaceStyle:6.0f paragraphSpaceStyle:8.0f lineBreakStyle:NSLineBreakByWordWrapping];
    self.m_IntrTextView.attributedText = atrStr;
    
    self.m_CopyRightLabel.textColor = UI_COLOR_B4;
}

@end
