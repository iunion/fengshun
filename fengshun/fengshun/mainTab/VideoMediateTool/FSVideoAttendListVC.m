//
//  FSVideoAttendListVC.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoAttendListVC.h"
#import "FSVideoMediatePersonalCell.h"

@interface FSVideoAttendListVC ()

@end

@implementation FSVideoAttendListVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self bm_setNavigationWithTitle:@"参与人员" barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];

    [self.m_TableView reloadData];
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_AttendList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, self.m_TableView.bm_width-28, 24)];
    label.text = [NSString stringWithFormat:@"参与人员：%ld人",_m_AttendList.count];
    label.textColor = UI_COLOR_B4;
    label.font = UI_FONT_12;
    [view addSubview:label];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"FSVideoMediatePersonalCell";
    
    FSVideoMediatePersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[FSVideoMediatePersonalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID selectEnable:NO];
    }
    FSMeetingPersonnelModel *model = self.m_AttendList[indexPath.row];
    [cell setModel:model];
    return cell;
}

@end
