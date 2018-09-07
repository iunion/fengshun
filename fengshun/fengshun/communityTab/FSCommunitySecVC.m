//
//  FSCommunitySecVC.m
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCommunitySecVC.h"
#import "FSCommunityHeaderView.h"
#import "FSApiRequest.h"

@interface FSCommunitySecVC ()
// 板块id
@property (nonatomic, assign) NSInteger m_FourmId;
// headerView
@property (nonatomic, strong) FSCommunityHeaderView *m_HeaderView;

@end

@implementation FSCommunitySecVC

- (instancetype)initWithFourmId:(NSInteger )fourmId
{
    if (self = [super init])
    {
        self.m_FourmId = fourmId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    self.bm_NavigationBarHidden = YES;
    [self bm_setNeedsUpdateNavigationBarAlpha];
    self.view.backgroundColor = FS_VIEW_BGCOLOR;
    [self createUI];
    [self getInfoMsg];
    [self getListWithListType:1 page:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI

- (void)createUI
{
    _m_HeaderView = [[NSBundle mainBundle]loadNibNamed:@"FSCommunityHeaderView" owner:self options:nil].firstObject;
    [self.view addSubview:_m_HeaderView];
    [_m_HeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
    
    
    
}

#pragma mark - Request

- (void)getInfoMsg
{
    [FSApiRequest getTwoLevelFourmInfoWithId:self.m_FourmId success:^(id  _Nullable responseObject) {
        [_m_HeaderView updateHeaderViewWith:[FSCommunityDetailInfoModel infoModelWithDic:[responseObject bm_dictionaryForKey:@"communityForumDTO"]]];
    } failure:^(NSError * _Nullable error) {
        
    }];
}

- (void)getListWithListType:(FSCommunityDetailListType )listType page:(NSInteger )page
{
    [FSApiRequest getTwoLevelFourmListWithListType:listType topicIdId:self.m_FourmId PageIndex:page pageSize:10 success:^(id  _Nullable responseObject) {
        /*
         {
             endRow = 10;
             hasNextPage = 1;
             hasPreviousPage = 0;
             lastPage = 0;
             list =     (
                 {
                     commentCount = 200;
                     nickName = "\U6635\U79f01";
                     postsCreateTime = 1536304426774;
                     postsFlag = "\U7f6e\U9876";
                     postsLastReplyTime = 1536304426774;
                     postsTitle = "\U6700\U65b0\U56de\U590d\U5e16\U5b50\U6807\U98981";
                 }
             );
             pageIndex = 1;
             pageSize = 10;
             startRow = 0;
             totalPages = 3;
             totalRows = 30;
         }
         */
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
