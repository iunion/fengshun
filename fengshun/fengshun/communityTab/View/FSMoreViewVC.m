//
//  FSMoreViewVC.m
//  fengshun
//
//  Created by best2wa on 2018/9/17.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMoreViewVC.h"
#import "UIButton+BMContentRect.h"
#import "FSUserMainVC.h"

#define MORE_VIEW_HEIGHT 238

@interface FSMoreViewVC ()

// 是否是自己的帖子 （是否显示编辑、删除功能）
@property (nonatomic , assign) BOOL m_isOwner;

// 是否收藏 （收藏按钮选中状态）
@property (nonatomic , assign) BOOL m_Collection;

@property (nonatomic, strong) UIView *m_BgView;

@property (nonatomic, strong) UIButton *m_CancelBtn;
// 是否是web more按钮（是否显示举报 web不显示，帖子显示）
@property (nonatomic, assign)BOOL m_IsWebMore;
// 是否只有分享按钮 （单行 只显示分享）
@property (nonatomic, assign) BOOL m_IsShareSheet;
// yes=刷新、no=复制
@property (nonatomic, assign) BOOL m_isRefresh;
// 是否只有刷新功能（课堂案例详情页面使用1.1版本）
@property (nonatomic, assign) BOOL m_isSingleRefresh;

@end

@implementation FSMoreViewVC

+ (FSMoreViewVC *)showTopicMoreDelegate:(id)delegate isOwner:(BOOL)isOwner isCollection:(BOOL)isCollection presentVC:(UIViewController *)presentVC
{
    FSMoreViewVC *moreVC = [[FSMoreViewVC alloc]init];
    moreVC.delegate = delegate;
    moreVC.m_isOwner = isOwner;
    moreVC.m_Collection = isCollection;
    moreVC.m_IsWebMore = NO;
    moreVC.m_IsShareSheet = NO;
    moreVC.m_isRefresh = NO;
    moreVC.m_isSingleRefresh = NO;
    moreVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    moreVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [presentVC presentViewController:moreVC animated:NO completion:^{
        [UIView animateWithDuration:DEFAULT_DELAY_TIME animations:^{
            moreVC.m_BgView.bm_top = UI_SCREEN_HEIGHT - moreVC.m_BgView.bm_height;
        }];
    }];
    return moreVC;
}

+ (FSMoreViewVC *)showTopicMoreDelegate:(id)delegate isOwner:(BOOL)isOwner isCollection:(BOOL)isCollection
{
    FSMoreViewVC *moreVC = [[FSMoreViewVC alloc]init];
    moreVC.delegate = delegate;
    moreVC.m_isOwner = isOwner;
    moreVC.m_Collection = isCollection;
    moreVC.m_IsWebMore = NO;
    moreVC.m_IsShareSheet = NO;
    moreVC.m_isRefresh = NO;
    moreVC.m_isSingleRefresh = NO;
    moreVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    moreVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:moreVC animated:NO completion:^{
        [UIView animateWithDuration:DEFAULT_DELAY_TIME animations:^{
            moreVC.m_BgView.bm_top = UI_SCREEN_HEIGHT - moreVC.m_BgView.bm_height;
        }];
    }];
    return moreVC;
}

+ (FSMoreViewVC *)showWebMoreDelegate:(id)delegate isCollection:(BOOL)isCollection hasRefresh:(BOOL)hasRefresh presentVC:(UIViewController *)presentVC
{
    FSMoreViewVC *moreVC = [[FSMoreViewVC alloc]init];
    moreVC.delegate = delegate;
    moreVC.m_isOwner = NO;//隐藏编辑删除
    moreVC.m_IsWebMore = YES;//隐藏举报
    moreVC.m_Collection = isCollection;
    moreVC.m_IsShareSheet = NO;
    moreVC.m_isRefresh = hasRefresh;
    moreVC.m_isSingleRefresh = NO;
    moreVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    moreVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [presentVC presentViewController:moreVC animated:NO completion:^{
        [UIView animateWithDuration:DEFAULT_DELAY_TIME animations:^{
            moreVC.m_BgView.bm_top = UI_SCREEN_HEIGHT - moreVC.m_BgView.bm_height;
        }];
    }];
    return moreVC;
}

+ (FSMoreViewVC *)showSingleShareAlertViewDelegate:(id)delegate presentVC:(UIViewController *)presentVC
{
    FSMoreViewVC *moreVC = [[FSMoreViewVC alloc]init];
    moreVC.delegate = delegate;
    moreVC.m_IsShareSheet = YES;//单行
    moreVC.m_isOwner = NO;
    moreVC.m_IsWebMore = NO;
    moreVC.m_Collection = NO;
    moreVC.m_isRefresh = NO;
    moreVC.m_isSingleRefresh = NO;
    moreVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    moreVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [presentVC presentViewController:moreVC animated:NO completion:^{
        [UIView animateWithDuration:DEFAULT_DELAY_TIME animations:^{
            if ([presentVC isMemberOfClass:[FSUserMainVC class]])
            {
                moreVC.m_BgView.bm_height -= UI_HOME_INDICATOR_HEIGHT;
                moreVC.m_BgView.bm_top = UI_SCREEN_HEIGHT - moreVC.m_BgView.bm_height - UI_TAB_BAR_HEIGHT;
            }
            else
            {
                moreVC.m_BgView.bm_top = UI_SCREEN_HEIGHT - moreVC.m_BgView.bm_height;
            }
        }];
    }];
    return moreVC;
}

+ (FSMoreViewVC *)showClassroomCaseDetailShareAlertViewDelegate:(id)delegate presentVC:(UIViewController *)presentVC
{
    FSMoreViewVC *moreVC = [[FSMoreViewVC alloc]init];
    moreVC.delegate = delegate;
    moreVC.m_isOwner = NO;//隐藏编辑删除
    moreVC.m_Collection = NO;
    moreVC.m_IsWebMore = YES;//隐藏举报
    moreVC.m_IsShareSheet = NO;
    moreVC.m_isRefresh = NO;
    moreVC.m_isSingleRefresh = YES;
    moreVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    moreVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [presentVC presentViewController:moreVC animated:NO completion:^{
        [UIView animateWithDuration:DEFAULT_DELAY_TIME animations:^{
            moreVC.m_BgView.bm_top = UI_SCREEN_HEIGHT - moreVC.m_BgView.bm_height;
        }];
    }];
    return moreVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat btnWid = UI_SCREEN_WIDTH / 5.f;
    CGFloat btnHeight = 90.f;
    CGFloat space = 10.f;
    CGFloat cacenlBtnHeight = 44.f;
    CGFloat totalBtnHeight = self.m_IsShareSheet ? btnHeight : btnHeight*2;
    
    self.m_BgView = [[UIView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, totalBtnHeight + space + cacenlBtnHeight + UI_HOME_INDICATOR_HEIGHT)];
    self.m_BgView.backgroundColor = [UIColor bm_colorWithHex:0xFFFFFF];
    [self.view addSubview:self.m_BgView];
    
    self.m_CancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, totalBtnHeight + space, UI_SCREEN_WIDTH, cacenlBtnHeight )];
    self.m_CancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    self.m_CancelBtn.backgroundColor = [ UIColor whiteColor];
    [self.m_CancelBtn setTitleColor:[UIColor bm_colorWithHex:0x333333] forState:UIControlStateNormal];
    [self.m_CancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.m_CancelBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [self.m_BgView addSubview:self.m_CancelBtn];
    
    UIView *spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, totalBtnHeight, UI_SCREEN_WIDTH, space)];
    spaceView.backgroundColor = [UIColor bm_colorWithHex:0xF6F6F6];
    [self.m_BgView addSubview:spaceView];
    
    NSInteger row = self.m_IsShareSheet ? 1 : 2;
    
    for (NSUInteger i = 0; i < row ; i ++)
    {
        for (NSUInteger j = 0; j < 5; j ++)
        {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(j*btnWid, i*btnHeight, btnWid, btnHeight)];
            btn.backgroundColor = [UIColor whiteColor];
            btn.titleLabel.font = [UIFont systemFontOfSize:11.f];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitle:@[@[@"微信",@"朋友圈",@"QQ",@"QQ空间",@"微博"],@[self.m_isSingleRefresh?@"刷新":@"收藏",self.m_isRefresh ? @"刷新":@"复制链接",@"举报",@"编辑",@"删除"]][i][j] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@[@[@"community_wechat",@"community_friends_cycle",@"community_QQ",@"community_zone",@"community_weibo"],@[self.m_isSingleRefresh?@"more_refresh":@"community_collect",self.m_isRefresh?@"more_refresh":@"community_copy",@"community_report",@"community_edit",@"community_delete"]][i][j]] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor bm_colorWithHex:0x333333] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(moreViewAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = (i*5 + j) + 100;
            // 收藏||刷新
            if (btn.tag == 105)
            {
                if (!self.m_isSingleRefresh)//收藏
                {
                    [btn setTitle:@"取消收藏" forState:UIControlStateSelected];
                    [btn setImage:[UIImage imageNamed:@"community_collect_selected"] forState:UIControlStateSelected];
                    btn.selected = self.m_Collection;
                }
                else// 刷新
                {
                    
                }
            }
            if (btn.tag == 106)// 刷新||复制
            {
                btn.hidden = self.m_isSingleRefresh;
            }
            // 举报
            if (btn.tag == 107)
            {
                btn.hidden = self.m_IsWebMore;
                btn.enabled = !self.m_isOwner;
            }
            // 编辑和删除按钮是否隐藏
            if (btn.tag == 108 || btn.tag == 109)
            {
                btn.hidden = !self.m_isOwner;
            }
            
            CGFloat imageWidth = 30.0f;
            CGFloat titleheight = 28.0f;
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;

            btn.bm_imageRect = CGRectMake((btnWid-imageWidth)*0.5, (btnHeight-(imageWidth+titleheight))*0.5, imageWidth, imageWidth);
            btn.bm_titleRect = CGRectMake(0, (btnHeight-(imageWidth+titleheight))*0.5+imageWidth, btnWid, titleheight);
            
            if (IOS_VERSION >= 12.0)
            {
                [btn bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageTop imageTitleGap:0];
            }
            
            [self.m_BgView addSubview:btn];
        }
    }
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeMoreView)]];
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeMoreView
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)moreViewAction:(UIButton *)sender
{
    BMLog(@"%@", @(sender.tag));
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreViewClickWithType:)])
    {
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
