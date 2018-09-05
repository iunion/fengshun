//
//  FSSearchReaultView.m
//  fengshun
//
//  Created by Aiwei on 2018/9/4.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSearchReaultView.h"


@interface
FSSearchReaultView ()


@end

@implementation FSSearchReaultView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = FS_VIEW_BGCOLOR;
        [self configTableViewWithStartY:0];
    }
    return self;
}
- (void)configTableViewWithStartY:(CGFloat)startY
{
    _m_tableView                   = [[FSTableView alloc] initWithFrame:CGRectMake(0, startY, self.bm_width, self.bm_height - startY) style:UITableViewStylePlain freshViewType:BMFreshViewType_Bottom];
    _m_tableView.delegate          = self;
    _m_tableView.dataSource        = self;
    _m_tableView.tableViewDelegate = self;
}
- (void)addSearchkey:(NSString *)searchkey
{
    
}
#pragma mark - tableViewDeleaget&DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)freshDataWithTableView:(FSTableView *)tableView
{
    // 协议中为必须实现,其实本视图中无下拉刷新
}

- (void)loadNextDataWithTableView:(FSTableView *)tableView
{
    BMLog(@"上拉加载,请在子类中实现此功能");
}



@end
