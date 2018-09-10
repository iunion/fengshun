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

@interface FSCommunitySecVC ()
<
    FSScrollPageViewDataSource,
    FSScrollPageViewDelegate
>
// 板块id
@property (nonatomic, assign) NSInteger m_FourmId;
// headerView
@property (nonatomic, strong) FSCommunityHeaderView *m_HeaderView;
@property (nonatomic, strong) FSScrollPageSegment *  m_SegmentBar;
@property (nonatomic, strong) FSScrollPageView *     m_ScrollPageView;

@end

@implementation FSCommunitySecVC

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
    self.bm_NavigationBarHidden = YES;
    [self bm_setNeedsUpdateNavigationBarAlpha];
    self.view.backgroundColor = FS_VIEW_BGCOLOR;
    [self createUI];
    [self getInfoMsg];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI

- (void)createUI
{
    _m_HeaderView = [[NSBundle mainBundle] loadNibNamed:@"FSCommunityHeaderView" owner:self options:nil].firstObject;
    [self.view addSubview:_m_HeaderView];
    [_m_HeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(-(UI_NAVIGATION_BAR_DEFAULTHEIGHT + UI_STATUS_BAR_HEIGHT));
        make.height.mas_equalTo(200);
    }];

    // 切换视图
    self.m_SegmentBar = [[FSScrollPageSegment alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44) titles:nil titleColor:nil selectTitleColor:nil showUnderLine:NO moveLineFrame:CGRectZero isEqualDivide:YES fresh:YES];
    [self.view addSubview:_m_SegmentBar];
    [self.m_SegmentBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_m_HeaderView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    _m_SegmentBar.backgroundColor = [UIColor whiteColor];

    // 内容视图
    self.m_ScrollPageView = [[FSScrollPageView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - 44) titleColor:UI_COLOR_B1 selectTitleColor:UI_COLOR_B1 scrollPageSegment:_m_SegmentBar isSubViewPageSegment:NO];
    [self.view addSubview:self.m_ScrollPageView];
    [self.m_ScrollPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.m_SegmentBar.mas_bottom);
    }];
    self.m_ScrollPageView.datasource = self;
    self.m_ScrollPageView.delegate   = self;
    [self.m_ScrollPageView setM_MoveLineColor:UI_COLOR_BL1];
    [self.m_ScrollPageView reloadPage];
    [self.m_ScrollPageView scrollPageWithIndex:0];
}

#pragma mark - FSScrollPageView Delegate & DataSource

- (NSUInteger)scrollPageViewNumberOfPages:(FSScrollPageView *)scrollPageView
{
    return 4;
}

- (NSString *)scrollPageView:(FSScrollPageView *)scrollPageView titleAtIndex:(NSUInteger)index
{
    switch (index)
    {
        case 0:
            return @"最新回复";
            break;

        case 1:
            return @"最新发布";
            break;
        case 2:
            return @"热门";
            break;
        case 3:
            return @"精华";
            break;
        default:
            return @"默认标题";
            break;
    }
}

- (id)scrollPageView:(FSScrollPageView *)scrollPageView pageAtIndex:(NSUInteger)index
{
    UIView *aView = [[UIView alloc] initWithFrame:scrollPageView.bounds];
    // 最新
    if (index == 0)
    {
        FSTopicListVC *vc = [[FSTopicListVC alloc] initWithTopicSortType:FSTopicSortTypeNewReply formId:self.m_FourmId];
        [aView addSubview:vc.view];
    }
    else if (index == 1)
    {
        FSTopicListVC *vc = [[FSTopicListVC alloc] initWithTopicSortType:FSTopicSortTypeNewPulish formId:self.m_FourmId];
        [aView addSubview:vc.view];
    }
    else if (index == 2)
    {
        FSTopicListVC *vc = [[FSTopicListVC alloc] initWithTopicSortType:FSTopicSortTypeHot formId:self.m_FourmId];
        [aView addSubview:vc.view];
    }
    else
    {
        FSTopicListVC *vc = [[FSTopicListVC alloc] initWithTopicSortType:FSTopicSortTypeEssence formId:self.m_FourmId];
        [aView addSubview:vc.view];
    }
    return aView;
}

#pragma mark - request

- (void)getInfoMsg
{
    [FSApiRequest getTwoLevelFourmInfoWithId:self.m_FourmId success:^(id  _Nullable responseObject) {
        if ([responseObject bm_isNotEmptyDictionary]) {
            
        }
    } failure:^(NSError * _Nullable error) {
        
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
