//
//  FSCreateVideoMediateVC.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCreateVideoMediateVC.h"
#import "FSCreateVideoMediateHeader.h"
#import "FSVideoMediatePersonalCell.h"
#import "FSVideoInviteLitigantVC.h"

@interface FSCreateVideoMediateVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) VideoMediateListModel *m_CreateModel;

@property (nonatomic, strong) NSMutableArray *meetingAttendedList; // 参与人员列表

@end

@implementation FSCreateVideoMediateVC
@synthesize m_FreshViewType = _m_FreshViewType;

- (void)viewDidLoad {

    _m_FreshViewType = BMFreshViewType_NONE;
    
    [super viewDidLoad];

    self.bm_NavigationShadowHidden = NO;
    self.bm_NavigationShadowColor = UI_COLOR_B6;
    [self bm_setNavigationWithTitle:@"新建视频调解" barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];

    self.m_CreateModel = [VideoMediateListModel new];
    [self buildUI];
}

-(void)buildUI
{
    UIButton *bottom = [UIButton bm_buttonWithFrame:CGRectMake(0, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT - 48, self.view.bm_width, 48)
                                              title:@"确定"];
    bottom.backgroundColor = UI_COLOR_BL1;
    bottom.titleLabel.font = UI_FONT_17;
    [bottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottom addTarget:self action:@selector(bottomButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottom];
    
    self.m_TableView.frame = CGRectMake(0, 0, self.view.bm_width, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT - 48);
    
    FSCreateVideoMediateHeader *header = [[FSCreateVideoMediateHeader alloc] initWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 0)];
    self.m_TableView.tableHeaderView = header;
    header.m_Model = _m_CreateModel;

    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 24+44)];
    
    UIButton *btn = [UIButton bm_buttonWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 44)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = UI_FONT_14;
    [btn addTarget:self action:@selector(inviteAction) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btn];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"+  邀请当事人"
                                                                             attributes:@{NSForegroundColorAttributeName:UI_COLOR_BL1,
                                                                                          NSFontAttributeName:UI_FONT_14
                                                                                          }];
    [attr addAttribute:NSFontAttributeName value:UI_BOLDFONT_18 range:NSMakeRange(0, 1)];
    [btn setAttributedTitle:attr forState:UIControlStateNormal];
    self.m_TableView.tableFooterView = footer;
}

- (NSMutableArray *)meetingAttendedList
{
    if (_meetingAttendedList == nil) {
        _meetingAttendedList = [NSMutableArray array];
        [_meetingAttendedList addObject:[MeetingPersonnelModel userModel]];
        
        [_meetingAttendedList addObject:[MeetingPersonnelModel userModelWithState:0]];
        [_meetingAttendedList addObject:[MeetingPersonnelModel userModelWithState:1]];
    }
    
    return _meetingAttendedList;
}

- (void)inviteAction
{
    FSVideoInviteLitigantVC *vc = [FSVideoInviteLitigantVC new];
    vc.m_InviteList = self.meetingAttendedList;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)bottomButtonClickAction
{
    
}


#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.meetingAttendedList.count;
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
    label.text = [NSString stringWithFormat:@"参与人员：%ld人",_meetingAttendedList.count];
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
        cell = [[FSVideoMediatePersonalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    MeetingPersonnelModel *model = self.meetingAttendedList[indexPath.row];
    [cell setModel:model];
    return cell;
}


@end
