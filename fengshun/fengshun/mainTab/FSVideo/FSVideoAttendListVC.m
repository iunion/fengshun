//
//  FSVideoAttendListVC.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoAttendListVC.h"
#import "FSVideoMediatePersonalCell.h"
#import "FSVideoInviteLitigantVC.h"

@interface FSVideoAttendListVC ()

@end

@implementation FSVideoAttendListVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.bm_NavigationShadowHidden = NO;
    self.bm_NavigationShadowColor = UI_COLOR_B6;
    [self bm_setNavigationWithTitle:@"参与人员" barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    
    if (self.meetingId > 0 && self.m_AttendList.count < FSMEETING_PERSON_MAX_COUNT) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self rightItemButton]];
    }

    [self.m_TableView reloadData];
}

- (UIButton *)rightItemButton
{
    UIButton *btn = [UIButton bm_buttonWithFrame:CGRectMake(0, 0, 60, 44)];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(addLitigantAction) forControlEvents:UIControlEventTouchUpInside];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"+  邀请"
                                                                             attributes:@{NSForegroundColorAttributeName:UI_COLOR_BL1,
                                                                                          NSFontAttributeName:UI_FONT_16
                                                                                          }];
    [attr addAttribute:NSFontAttributeName value:UI_BOLDFONT_18 range:NSMakeRange(0, 1)];
    [btn setAttributedTitle:attr forState:UIControlStateNormal];

    return btn;
}

- (void)addLitigantAction
{
    FSVideoInviteLitigantVC *vc = [FSVideoInviteLitigantVC new];
    vc.meetingId = self.meetingId;
    vc.existingLitigantCount = self.m_AttendList.count;
    BMWeakSelf
    vc.inviteComplete = ^(NSArray *litigantList) {
        if (weakSelf.inviteComplete) {
            weakSelf.inviteComplete(litigantList);
        }
        if (litigantList.count) {
            NSMutableArray *newList = [NSMutableArray arrayWithArray:weakSelf.m_AttendList];
            [newList addObjectsFromArray:litigantList];
            weakSelf.m_AttendList = newList;
            if (weakSelf.m_AttendList.count >= FSMEETING_PERSON_MAX_COUNT) {
                self.navigationItem.rightBarButtonItem = nil;
            }
            [weakSelf.m_TableView reloadData];
        }
    };
    
    [self.navigationController pushViewController:vc animated:YES];
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
    view.backgroundColor = FS_VIEW_BGCOLOR;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, self.m_TableView.bm_width-28, 24)];
    label.text = [NSString stringWithFormat:@"参与人员：%@人",@(_m_AttendList.count)];
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
    
    if (indexPath.row == self.m_AttendList.count -1) {
        [cell showCellLine:NO];
    } else {
        [cell showCellLine:YES];
    }
    return cell;
}

@end
