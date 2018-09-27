//
//  FSMoreViewVC.m
//  fengshun
//
//  Created by best2wa on 2018/9/17.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMoreViewVC.h"
#import "UIButton+BMContentRect.h"

#define MORE_VIEW_HEIGHT 238

@interface
FSMoreViewVC ()
// 是否是自己的帖子
@property (nonatomic , assign) BOOL m_isOwner;

// 是否收藏
@property (nonatomic , assign) BOOL m_Collection;

@property (nonatomic, strong) UIView *m_BgView;

@property (nonatomic, strong) UIButton *m_CancelBtn;

@property (nonatomic, assign)BOOL m_IsWebMore;

@end

@implementation FSMoreViewVC


+ (void)showMore:(UIViewController *)presentVC  delegate:(id)delegate isOwner:(BOOL)isOwner isCollection:(BOOL)isCollection
{
    FSMoreViewVC *moreVC = [[FSMoreViewVC alloc]init];
    moreVC.delegate = delegate;
    moreVC.m_isOwner = isOwner;
    moreVC.m_Collection = isCollection;
    presentVC.definesPresentationContext = YES;
    moreVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [presentVC.navigationController presentViewController:moreVC animated:NO completion:^{
        [UIView animateWithDuration:DEFAULT_DELAY_TIME
                         animations:^{
                             moreVC.m_BgView.bm_top = UI_SCREEN_HEIGHT - moreVC.m_BgView.bm_height;
                         }];
    }];
    moreVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

+ (void)showWebMore:(UIViewController *)presentVC delegate:(id)delegate isCollection:(BOOL)isCollection
{
    FSMoreViewVC *moreVC = [[FSMoreViewVC alloc]init];
    moreVC.delegate = delegate;
    moreVC.m_isOwner = NO;
    moreVC.m_IsWebMore = YES;
    moreVC.m_Collection = isCollection;
    presentVC.definesPresentationContext = YES;
    moreVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [presentVC.navigationController presentViewController:moreVC animated:NO completion:^{
        [UIView animateWithDuration:DEFAULT_DELAY_TIME
                         animations:^{
                             moreVC.m_BgView.bm_top = UI_SCREEN_HEIGHT - moreVC.m_BgView.bm_height;
                         }];
    }];
    moreVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat btnWid = UI_SCREEN_WIDTH /5;
    CGFloat btnHeight = 90.f;
    CGFloat space = 10.f;
    CGFloat cacenlBtnHeight = 44.f;
    
    self.m_BgView = [[UIView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, btnHeight*2 + space + cacenlBtnHeight + UI_HOME_INDICATOR_HEIGHT)];
    self.m_BgView.backgroundColor = [UIColor bm_colorWithHex:0xFFFFFF];
    [self.view addSubview:self.m_BgView];
    
    self.m_CancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, btnHeight*2 + space, UI_SCREEN_WIDTH, cacenlBtnHeight )];
    self.m_CancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    self.m_CancelBtn.backgroundColor = [ UIColor whiteColor];
    [self.m_CancelBtn setTitleColor:[UIColor bm_colorWithHex:0x333333] forState:UIControlStateNormal];
    [self.m_CancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.m_CancelBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [self.m_BgView addSubview:self.m_CancelBtn];
    
    UIView *spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, btnHeight*2, UI_SCREEN_WIDTH, space)];
    spaceView.backgroundColor = [UIColor bm_colorWithHex:0xF6F6F6];
    [self.m_BgView addSubview:spaceView];
    
    for (int i = 0; i < 2; i ++)
    {
        for (int j = 0; j < 5; j ++)
        {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(j*btnWid, i*btnHeight, btnWid, btnHeight)];
            btn.backgroundColor = [UIColor whiteColor];
            btn.titleLabel.font = [UIFont systemFontOfSize:11.f];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitle:@[@[@"微信",@"朋友圈",@"QQ",@"QQ空间",@"微博"],@[@"收藏",@"复制链接",@"举报",@"编辑",@"删除"]][i][j] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@[@[@"community_wechat",@"community_friends_cycle",@"community_QQ",@"community_zone",@"community_weibo"],@[@"community_collect",@"community_copy",@"community_report",@"community_edit",@"community_delete"]][i][j]] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor bm_colorWithHex:0x333333] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(moreViewAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = (i*5 + j) + 100;
            // 收藏按钮
            if (btn.tag == 105)
            {
                [btn setTitle:@"取消收藏" forState:UIControlStateSelected];
                [btn setImage:[UIImage imageNamed:@"community_collect_selected"] forState:UIControlStateSelected];
                btn.selected = self.m_Collection;
            }
            if (btn.tag == 107)
            {
                btn.hidden = self.m_IsWebMore;
            }
            // 编辑和删除按钮是否隐藏
            if (btn.tag == 108 || btn.tag == 109)
            {
                btn.hidden = !self.m_isOwner;
            }
            //[btn bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageTop imageTitleGap:5];
            
            CGFloat imageWidth = 30.0f;
            CGFloat titleheight = 28.0f;
            btn.bm_imageRect = CGRectMake((btnWid-imageWidth)*0.5, (btnHeight-(imageWidth+titleheight))*0.5, imageWidth, imageWidth);
            btn.bm_titleRect = CGRectMake(0, (btnHeight-(imageWidth+titleheight))*0.5+imageWidth, btnWid, titleheight);

            
            [self.m_BgView addSubview:btn];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)moreViewAction:(UIButton *)sender
{
    BMLog(@"%ld", sender.tag);
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreViewClickWithType:)]) {
        [self.delegate moreViewClickWithType:sender.tag - 100];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)removeView
{
    [self dismissViewControllerAnimated:NO completion:nil];
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
