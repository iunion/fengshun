//
//  FSCreateVideoMediateVC.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCreateVideoMediateVC.h"
#import "BMTableViewManager.h"

@interface FSCreateVideoMediateVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BMTableViewManager *m_TableManager;

@property (nonatomic, strong) BMTableViewSection *m_BasicSection;
@property (nonatomic, strong) BMTableViewSection *m_ContentSection;
@property (nonatomic, strong) BMTableViewSection *m_AttendedSection;


@end

@implementation FSCreateVideoMediateVC
@synthesize m_FreshViewType = _m_FreshViewType;

- (void)viewDidLoad {

    _m_FreshViewType = BMFreshViewType_NONE;
    
    [super viewDidLoad];

    self.bm_NavigationShadowHidden = NO;
    self.bm_NavigationShadowColor = UI_COLOR_B6;
    [self bm_setNavigationWithTitle:@"新建视频调解" barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];

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
    
    self.m_TableManager = [[BMTableViewManager alloc] initWithTableView:self.m_TableView];
    self.m_BasicSection = [BMTableViewSection section];
    self.m_ContentSection = [BMTableViewSection section];
    self.m_AttendedSection = [BMTableViewSection section];

    _m_BasicSection.headerHeight = 9.0f;
    _m_ContentSection.headerHeight = 9.0f;
    _m_AttendedSection.headerHeight = 23.0f;
    [self.m_TableManager addSectionsFromArray:@[_m_BasicSection, _m_ContentSection, _m_AttendedSection]];
    
    
    BMTableViewItem *item1 = [BMTableViewItem itemWithTitle:@"名称" underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    item1.textColor = UI_COLOR_B1;
    
    BMTableViewItem *item2 = [BMTableViewItem itemWithTitle:@"类型" underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    item2.textColor = UI_COLOR_B1;

    BMTableViewItem *item3 = [BMTableViewItem itemWithTitle:@"时间" underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    item3.textColor = UI_COLOR_B1;

    BMTableViewItem *item4 = [BMTableViewItem itemWithTitle:@"时长" underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    item4.textColor = UI_COLOR_B1;

    [_m_BasicSection addItemsFromArray:@[item1, item2, item3, item4]];
    
    
    BMLongTextItem *item5 = [BMLongTextItem itemWithTitle:@"内容" value:nil placeholder:@"请输入内容"];
    item5.underLineDrawType = BMTableViewCell_UnderLineDrawType_None;
    item5.cellBgColor = [UIColor whiteColor];
    item5.editable = YES;
    item5.textViewLeftGap = 0.0f;
    item5.textViewTopGap = 8.0f;
    item5.showTextViewBorder = NO;
    item5.textViewFont = [UIFont systemFontOfSize:16.0f];
    item5.cellHeight = 128.0f;
    item5.textColor = UI_COLOR_B1;
    item5.textViewTextColor = UI_COLOR_B1;
    item5.textViewPlaceholderColor = [UIColor bm_colorWithHex:0xB5B5B5];

    item5.onChange = ^(BMInputItem * _Nonnull item) {
        NSLog(@"item %@", item.value);
    };

    [_m_ContentSection addItem:item5];
    
    
    BMTableViewItem *item6 = [BMTableViewItem itemWithTitle:@"时间" underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    item6.textColor = UI_COLOR_B1;
    [_m_AttendedSection addItem:item6];
    
    _m_AttendedSection.headerTitle = @"参与人员：2人";
    
    [self.m_TableView reloadData];
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
