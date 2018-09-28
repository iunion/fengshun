//
//  FSCommunitySecVC.m
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCommunitySecVC.h"
#import "FSScrollPageView.h"
#import "FSCommunityHeaderView.h"
#import "FSApiRequest.h"
#import "FSTopicListVC.h"
#import "FSCommunityModel.h"
#import "BMAlertView.h"
#import "FSPushVCManager.h"
#import "FSAuthenticationVC.h"
#import "FSAlertView.h"

@interface
FSCommunitySecVC ()
<
    FSScrollPageViewDataSource,
    FSScrollPageViewDelegate,
    FSCommunityHeaderViewDelegate,
    FSAuthenticationDelegate
>
// 板块id
@property (nonatomic, assign) NSInteger m_FourmId;
// headerView
@property (nonatomic, strong) FSCommunityHeaderView *m_HeaderView;
@property (nonatomic, strong) FSScrollPageSegment *  m_SegmentBar;
@property (nonatomic, strong) FSScrollPageView *     m_ScrollPageView;
@property (nonatomic, strong) UIButton *m_PulishBtn;
@property (nonatomic, strong) NSMutableArray *       m_dataArray;
@property (nonatomic, strong) NSMutableArray *       m_vcArray;

@property (nonatomic, strong) FSForumModel *m_ForumModel;

@end

@implementation FSCommunitySecVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:userInfoChangedNotification object:nil];
}

- (instancetype)initWithFourmId:(NSInteger)fourmId
{
    if (self = [super init])
    {
        self.m_FourmId = fourmId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    [self bm_setNavigationWithTitle:@"" barTintColor:nil leftDicArray:@[ [self bm_makeBarButtonDictionaryWithTitle:@"   " image:@"community_white_back" toucheEvent:@"popViewController" buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:5] ] rightDicArray:nil];
    self.bm_NavigationBarHidden = YES;
    [self bm_getNavigationLeftItemAtIndex:0].tintColor = [UIColor whiteColor];
    [self bm_setNeedsUpdateNavigationBar];
    
    self.view.backgroundColor = FS_VIEW_BGCOLOR;
    self.m_dataArray          = [NSMutableArray arrayWithCapacity:0];
    self.m_vcArray            = [NSMutableArray array];

    [self createUI];
    [self loadApiData];
    [self getHeaderInfoMsg];
    
    // 登录状态改变刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHeaderInfoMsg) name:userInfoChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.bm_NavigationBarStyle = UIBarStyleBlack;
    [self bm_setNeedsUpdateNavigationBarStyle];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.bm_NavigationBarStyle = UIBarStyleDefault;
    [self bm_setNeedsUpdateNavigationBarStyle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI

- (void)createUI
{
    _m_HeaderView          = (FSCommunityHeaderView *)[[NSBundle mainBundle] loadNibNamed:@"FSCommunityHeaderView" owner:self options:nil].firstObject;
    _m_HeaderView.delegate = self;
    [self.view addSubview:_m_HeaderView];
    _m_HeaderView.frame = CGRectMake(0, -(UI_NAVIGATION_BAR_HEIGHT+20), UI_SCREEN_WIDTH, 200);

    // 切换视图
    self.m_SegmentBar = [[FSScrollPageSegment alloc] initWithFrame:CGRectMake(0, _m_HeaderView.bm_bottom + 8, UI_SCREEN_WIDTH, 44) titles:nil titleColor:nil selectTitleColor:nil showUnderLine:YES moveLineFrame:CGRectZero isEqualDivide:YES fresh:YES];
    [self.view addSubview:_m_SegmentBar];
    _m_SegmentBar.backgroundColor = [UIColor whiteColor];

    // 内容视图
    self.m_ScrollPageView = [[FSScrollPageView alloc] initWithFrame:CGRectMake(0, _m_SegmentBar.bm_bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT -UI_STATUS_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT - UI_HOME_INDICATOR_HEIGHT- _m_SegmentBar.bm_bottom) titleColor:UI_COLOR_B1 selectTitleColor:UI_COLOR_BL1 scrollPageSegment:_m_SegmentBar isSubViewPageSegment:NO];
    [self.view addSubview:self.m_ScrollPageView];
    self.m_ScrollPageView.datasource = self;
    self.m_ScrollPageView.delegate   = self;
    [self.m_ScrollPageView setM_MoveLineColor:UI_COLOR_BL1];
    [self.m_ScrollPageView reloadPage];
    [self.m_ScrollPageView scrollPageWithIndex:0];
    
    self.m_PulishBtn = [UIButton bm_buttonWithFrame:CGRectMake(UI_SCREEN_WIDTH - 52 - 20, UI_SCREEN_HEIGHT-UI_STATUS_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT- UI_HOME_INDICATOR_HEIGHT- 20.f - 52.f, 52.f, 52.f) image:[UIImage imageNamed:@"community_comment"]];
    [self.m_PulishBtn addTarget:self action:@selector(pulishTopicAction) forControlEvents:UIControlEventTouchUpInside];
    self.m_PulishBtn.layer.masksToBounds = NO;
    self.m_PulishBtn.layer.shadowOffset = CGSizeZero;
    self.m_PulishBtn.layer.shadowRadius = 20;
    self.m_PulishBtn.layer.shadowOpacity = 0.3;
    self.m_PulishBtn.layer.shadowColor = [UIColor blueColor].CGColor;
    [self.view addSubview:self.m_PulishBtn];
    
}

#pragma mark - Action

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 发帖
- (void)pulishTopicAction{
    if (![FSUserInfoModel isLogin])
    {
        [self showLogin];
        return;
    }
    if (![FSUserInfoModel userInfo].m_UserBaseInfo.m_IsRealName)
    {
        BMWeakSelf;
        [FSAlertView showAlertWithTitle:@"温馨提示" message:@"认证后才能发帖" cancelTitle:@"取消" otherTitle:@"去认证" completion:^(BOOL cancelled, NSInteger buttonIndex) {
            if (buttonIndex == 1)
            {
                FSAuthenticationVC *vc = [[FSAuthenticationVC alloc] init];
                vc.delegate = weakSelf;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
        return;
    }
    [FSPushVCManager showSendPostWithPushVC:self isEdited:NO relatedId:self.m_FourmId callBack:^ {
        
    }];
}
//认证完成
- (void)authenticationFinished:(FSAuthenticationVC *)vc
{
    BMLog(@"认证完成");
}

#pragma mark - FSScrollPageView Delegate & DataSource

- (NSUInteger)scrollPageViewNumberOfPages:(FSScrollPageView *)scrollPageView
{
    return self.m_dataArray.count;
}

- (NSString *)scrollPageView:(FSScrollPageView *)scrollPageView titleAtIndex:(NSUInteger)index
{
    FSTopicTypeModel *model = self.m_dataArray[index];
    return model.m_PostListName;
}

- (id)scrollPageView:(FSScrollPageView *)scrollPageView pageAtIndex:(NSUInteger)index
{
    FSTopicTypeModel *model = self.m_dataArray[index];
    FSTopicListVC *vc       = [[FSTopicListVC alloc] initWithTopicSortType:model.m_PostListType formId:self.m_FourmId];
    [self.m_vcArray addObject:vc];
    return vc;
}

#pragma mark - 关注

- (void)followForumAction:(FSCommunityHeaderView *)aView
{
    if (![FSUserInfoModel isLogin])
    {
        [self showLogin];
        return ;
    }
    FSForumFollowState state = self.m_ForumModel.m_AttentionFlag;
    [FSApiRequest updateFourmAttentionStateWithFourmId:self.m_ForumModel.m_Id followStatus:!state success:^(id  _Nullable responseObject) {
        if (self.m_AttentionChangeBlock) {
            self.m_AttentionChangeBlock();
        }
        [self getHeaderInfoMsg];
    } failure:^(NSError * _Nullable error) {
        [self checkXMApiWithError:error];
    }];
}

#pragma mark - request

- (NSMutableURLRequest *)setLoadDataRequest
{
    return [FSApiRequest getTopicListWithType:@"" forumId:self.m_FourmId pageIndex:1 pageSize:10];
}

- (BOOL)succeedLoadedRequestWithArray:(NSArray *)requestArray
{
    if ([requestArray bm_isNotEmpty])
    {
        NSMutableArray *data = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in requestArray)
        {
            FSTopicTypeModel *model = [FSTopicTypeModel topicTypeModelWithDic:dic];
            if (model)
            {
                [data addObject:model];
            }
        }
        [self.m_dataArray addObjectsFromArray:data];
        [self.m_ScrollPageView reloadPage];
        [self.m_ScrollPageView scrollPageWithIndex:0];
        return YES;
    }
    return NO;
}

- (void)getHeaderInfoMsg
{
    [FSApiRequest getTwoLevelFourmInfoWithId:self.m_FourmId success:^(id  _Nullable responseObject) {
        if ([responseObject bm_isNotEmptyDictionary])
        {
            FSForumModel *model = [FSForumModel forumModelWithServerDic:responseObject];
            self.m_ForumModel = model;
            [_m_HeaderView updateHeaderViewWith:model];
        }
    } failure:^(NSError * _Nullable error) {
        [self checkXMApiWithError:error];
    }];
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
