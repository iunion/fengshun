//
//  FSTextDetailVC.m
//  fengshun
//
//  Created by Aiwei on 2018/9/26.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSTextDetailVC.h"
#import "FSMoreViewVC.h"

@interface FSTextDetailVC ()
<
    FSShareManagerDelegate
>

@property(nonatomic, assign)BOOL s_isCollect;
@end

@implementation FSTextDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize buttonSize = CGSizeMake(115, 41.0f);
    UIButton *dowloadButton = [[UIButton alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - buttonSize.width, UI_SCREEN_HEIGHT -UI_NAVIGATION_BAR_HEIGHT- UI_STATUS_BAR_HEIGHT -buttonSize.height -45, buttonSize.width, buttonSize.height)];
    dowloadButton.backgroundColor = UI_COLOR_BL1;
    dowloadButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [dowloadButton setImage:[UIImage imageNamed:@"text_dowload"] forState:UIControlStateNormal];
    [dowloadButton setTitle:@"下载范本" forState:UIControlStateNormal];
    [dowloadButton bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:6];
    [dowloadButton addTarget:self action:@selector(downloadFile) forControlEvents:UIControlEventTouchUpInside];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:dowloadButton.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(buttonSize.height/2, buttonSize.height/2)].CGPath;
    [dowloadButton.layer setMask:maskLayer];
    
    [self.view addSubview:dowloadButton];
    [self addRightBtn];
    [self bringSomeViewToFront];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 添加更多按钮
- (void)addRightBtn
{
    [self bm_setNavigationWithTitle:@"文书范本" barTintColor:nil leftDicArray:nil rightDicArray:@[ [self bm_makeBarButtonDictionaryWithTitle:@" " image:@"community_more" toucheEvent:@"moreAction" buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:0]]];
}
// 更多按钮
- (void)moreAction
{
    //获取收藏状态
    [self.m_ProgressHUD showAnimated:YES];
    BMWeakSelf;
    [FSApiRequest getCollectStateID:self.m_docummentId type:@"DOCUMENT" Success:^(id  _Nullable responseObject) {
        [weakSelf.m_ProgressHUD hideAnimated:NO];
        NSInteger count = [responseObject integerValue];
        weakSelf.s_isCollect = count>0;
        [FSMoreViewVC showWebMoreDelegate:weakSelf isCollection:weakSelf.s_isCollect hasRefresh:YES];
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark - moreAlert
- (void)shareDidSucceed:(id)data
{
    [FSApiRequest addShareCountWithId:_m_docummentId andType:@"DOCUMENT" success:nil failure:nil];
}
- (void)moreViewClickWithType:(NSInteger)index
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@",FS_URL_SERVER,FS_FILE_ADRESS,_m_fileId];
    url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (index < 5)
    {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES withText:[NSString stringWithFormat:@"%@",url] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        [FSShareManager shareWebUrlWithTitle:self.title descr:nil thumImage:nil webpageUrl:url platform:index currentVC:self delegate:self];
    }
    else if (index == 5)//收藏
    {

        if (![FSUserInfoModel isLogin])
        {
            [self showLogin];
            return;
        }
        BMWeakSelf
        [FSApiRequest updateCollectStateID:self.m_docummentId isCollect:!weakSelf.s_isCollect guidingCase:@"" source:@"" title:@"" type:@"DOCUMENT" Success:^(id  _Nullable responseObject) {
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES withText:weakSelf.s_isCollect?@"取消收藏":@"收藏成功" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        } failure:^(NSError * _Nullable error) {
            
        }];
    }
    else if (index == 6)//刷新
    {
        [self refreshWebView];
    }
}

- (void)downloadFile
{
    if ([_m_fileId bm_isNotEmpty]) {
        NSString *url = [NSString stringWithFormat:@"%@%@%@",FS_URL_SERVER,FS_FILE_ADRESS,_m_fileId];
        url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:url]];
    }
}



@end
