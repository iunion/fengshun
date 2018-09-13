//
//  FSCreateVideoMediateVC.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCreateVideoMediateVC.h"
#import "FSCreateVideoMediateHeader.h"

@interface FSCreateVideoMediateVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) VideoMediateListModel *m_CreateModel;

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
}


- (void)bottomButtonClickAction
{
    
}


#pragma mark -
#pragma mark Table Data Source Methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    
    if (sectionIndex == 2) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, self.m_TableView.bm_width-28, 23)];
        label.text = @"参与人员：2人";
        label.textColor = UI_COLOR_B4;
        label.font = UI_FONT_12;
        [view addSubview:label];
    }
    return view;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
