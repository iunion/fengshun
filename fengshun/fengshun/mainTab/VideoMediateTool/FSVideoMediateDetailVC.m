//
//  FSVideoMediateDetailVC.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoMediateDetailVC.h"

@interface FSVideoMediateDetailVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *m_TableView;

@end

@implementation FSVideoMediateDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bm_NavigationShadowHidden = NO;
    self.bm_NavigationShadowColor = UI_COLOR_B6;
    [self bm_setNavigationWithTitle:@"视频详情" barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    
    [self buildUI];
}
-(void)buildUI
{
    UIButton *bottom = [UIButton bm_buttonWithFrame:CGRectMake(0, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT - 48, self.view.bm_width, 48)
                                              title:@"进入视频"];
    bottom.backgroundColor = UI_COLOR_BL1;
    bottom.titleLabel.font = UI_FONT_17;
    [bottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottom addTarget:self action:@selector(bottomButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottom];
    
    self.m_TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bm_width, 0) style:UITableViewStylePlain];
    self.m_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.m_TableView.backgroundColor = [UIColor clearColor];
    self.m_TableView.delegate = self;
    self.m_TableView.dataSource = self;
    [self.view addSubview:self.m_TableView];
}


- (void)bottomButtonClickAction
{
    
}


#pragma mark -
#pragma mark Table Data Source Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
    //    static NSString *taskCellIdentifier = @"VideoMediateListCell";
    //    VideoMediateListCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
    //
    //    if (cell == nil)
    //    {
    //        cell = [[[NSBundle mainBundle] loadNibNamed:@"VideoMediateListCell" owner:self options:nil] lastObject];
    //    }
    //
    //    [cell setModel:self.m_DataArray[indexPath.row]];
    //
    //    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
