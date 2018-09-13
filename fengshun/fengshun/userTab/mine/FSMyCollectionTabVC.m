//
//  FSMyCollectionTabVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMyCollectionTabVC.h"
#import "FSScrollPageView.h"

#import "FSMyCollectionVC.h"


@interface FSMyCollectionTabVC ()
<
    FSScrollPageViewDelegate,
    FSScrollPageViewDataSource
>

@property (nonatomic, strong) FSScrollPageSegment *m_SegmentBar;
@property (nonatomic, strong) FSScrollPageView *m_ScrollPageView;

// 帖子
@property (nonatomic, strong) FSMyCollectionVC *m_TopicCollectVC;
// 法规
@property (nonatomic, strong) FSMyCollectionVC *m_StatuteCollectVC;
// 案例
@property (nonatomic, strong) FSMyCollectionVC *m_CaseCollectVC;
// 文书范本
@property (nonatomic, strong) FSMyCollectionVC *m_DocumentCollectVC;
// 课程
@property (nonatomic, strong) FSMyCollectionVC *m_CourseCollectVC;


@end

@implementation FSMyCollectionTabVC

- (void)dealloc
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bm_NavigationShadowHidden   = NO;
    self.bm_NavigationShadowColor    = [UIColor bm_colorWithHexString:@"D8D8D8"];
    
    [self bm_setNavigationWithTitle:@"我的收藏" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
