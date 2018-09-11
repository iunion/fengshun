//
//  FSTopicListVC.m
//  fengshun
//
//  Created by best2wa on 2018/9/10.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSTopicListVC.h"
#import "FSForumDetailListCell.h"

@interface
FSTopicListVC ()

// 排序类型
@property (nonatomic, strong) NSString *m_SortType;
// 板块id
@property (nonatomic, assign) NSInteger m_ForumId;

@end

@implementation FSTopicListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
    [self loadApiData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithTopicSortType:(NSString *)sortType formId:(NSInteger)formId
{
    if (self = [super init])
    {
        self.m_SortType = sortType;
        self.m_ForumId  = formId;
    }
    return self;
}

- (void)createUI
{
}

- (NSMutableURLRequest *)setLoadDataRequestWithFresh:(BOOL)isLoadNew
{
    return [FSApiRequest getTopicListWithType:self.m_SortType forumId:self.m_ForumId pageIndex:1 pageSize:10];
}

- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)requestDic
{
    return YES;
}

- (BOOL)succeedLoadedRequestWithArray:(NSArray *)requestArray
{
    return YES;
}


#pragma mark - tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 107.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *      cellId = @"cellId";
    FSForumDetailListCell *cell   = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FSForumDetailListCell" owner:self options:nil].firstObject;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
