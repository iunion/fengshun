//
//  FSSearchResultVC.m
//  fengshun
//
//  Created by Aiwei on 2018/9/10.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSearchResultVC.h"
#import "FSSearchResultView.h"
#define SEARCH_HEADER_HEIGHT 23.0f

@interface FSSearchResultVC ()

@end

@implementation FSSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewDeleaget&DataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view         = [UIView new];
    view.backgroundColor = FS_VIEW_BGCOLOR;
    UILabel *label       = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, self.view.bm_width - 32, SEARCH_HEADER_HEIGHT)];
    label.font           = [UIFont systemFontOfSize:12];
    label.textColor      = UI_COLOR_B4;
    label.text           = [NSString stringWithFormat:@"共%ld条", (long)self.m_resultView.m_totalCount];
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SEARCH_HEADER_HEIGHT;
}
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

@end
