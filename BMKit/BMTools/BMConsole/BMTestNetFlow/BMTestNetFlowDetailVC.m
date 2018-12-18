//
//  BMTestNetFlowDetailVC.m
//  fengshun
//
//  Created by jiang deng on 2018/12/14.
//  Copyright © 2018 FS. All rights reserved.
//

#import "BMTestNetFlowDetailVC.h"
#import "BMTableViewManager.h"

typedef NS_ENUM(NSUInteger, NetFlowSelectState)
{
    NetFlowSelectState_Request = 0,
    NetFlowSelectState_Response
};

@interface BMTestNetFlowDetailVC ()
<
    BMTableViewManagerDelegate
>
{
    NetFlowSelectState selectState;
}

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIControl *requestControl;
@property (nonatomic, strong) UILabel *requestLabel;
@property (nonatomic, strong) UIControl *responseControl;
@property (nonatomic, strong) UILabel *responseLabel;
@property (nonatomic, strong) UIView *selectLine;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) BMTableViewManager *tableManager;

@end

@implementation BMTestNetFlowDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IOS_VERSION >= 7.0f)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    // 隐藏系统的返回按钮
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    self.bm_NavigationBarStyle = UIBarStyleDefault;
    self.bm_NavigationBarBgTintColor = [UIColor whiteColor];
    self.bm_NavigationTitleTintColor = [UIColor blackColor];
    self.bm_NavigationItemTintColor = [UIColor blackColor];
    self.bm_NavigationShadowHidden = YES;
    
    self.view.backgroundColor = [UIColor bm_colorWithHex:0xEEEEEE];
    
    [self bm_setNavigationWithTitle:@"流量监控详情" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    
    [self makeUI];
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)makeUI
{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-40, UI_SCREEN_WIDTH, 40.0f)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerView];
    
    self.requestControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH*0.5, 40.0f)];
    self.requestControl.backgroundColor = [UIColor clearColor];
    self.requestLabel = [[UILabel alloc] initWithFrame:self.requestControl.bounds];
    self.requestLabel.backgroundColor = [UIColor clearColor];
    self.requestLabel.textColor = [UIColor blackColor];
    self.requestLabel.textAlignment = NSTextAlignmentCenter;
    self.requestLabel.font = [UIFont systemFontOfSize:18.0f];
    self.requestLabel.text = @"请求";
    [self.requestControl addSubview:self.requestLabel];
    [self.headerView addSubview:self.requestControl];
    [self.requestControl addTarget:self action:@selector(changeTab:) forControlEvents:UIControlEventTouchUpInside];

    self.responseControl = [[UIControl alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH*0.5, 0, UI_SCREEN_WIDTH*0.5, 40.0f)];
    self.responseControl.backgroundColor = [UIColor clearColor];
    self.responseLabel = [[UILabel alloc] initWithFrame:self.responseControl.bounds];
    self.responseLabel.backgroundColor = [UIColor clearColor];
    self.responseLabel.textColor = [UIColor blackColor];
    self.responseLabel.textAlignment = NSTextAlignmentCenter;
    self.responseLabel.font = [UIFont systemFontOfSize:18.0f];
    self.responseLabel.text = @"应答";
    [self.responseControl addSubview:self.responseLabel];
    [self.headerView addSubview:self.responseControl];
    [self.responseControl addTarget:self action:@selector(changeTab:) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 2.0f)];
    self.selectLine.backgroundColor = [UIColor blueColor];
    [self.headerView addSubview:self.selectLine];
    self.selectLine.center = CGPointMake(UI_SCREEN_WIDTH*0.25, self.headerView.bm_height-3.0f);

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-self.headerView.bm_height)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableManager = [[BMTableViewManager alloc] initWithTableView:self.tableView];
    self.tableManager.delegate = self;
    
    [self changeTab:self.requestControl];
}

- (void)changeTab:(UIControl *)control
{
    if (control == self.requestControl)
    {
        selectState = NetFlowSelectState_Request;
        
        self.requestLabel.textColor = [UIColor blueColor];
        self.responseLabel.textColor = [UIColor blackColor];
        
        [UIView animateWithDuration:0.25f animations:^{
            self.selectLine.center = CGPointMake(UI_SCREEN_WIDTH*0.25, self.headerView.bm_height-3.0f);
        } completion:^(BOOL finished) {
        }];
        
        [self freshRequestTab];
    }
    else
    {
        selectState = NetFlowSelectState_Response;

        self.requestLabel.textColor = [UIColor blackColor];
        self.responseLabel.textColor = [UIColor blueColor];
        
        [UIView animateWithDuration:0.25f animations:^{
            self.selectLine.center = CGPointMake(UI_SCREEN_WIDTH*0.75, self.headerView.bm_height-3.0f);
        } completion:^(BOOL finished) {
        }];
        
        [self freshResponseTab];
    }
    
    [self.tableView reloadData];
}

- (void)freshRequestTab
{
    [self.tableManager removeAllSections];
    
    BMTableViewSection *section1 = [BMTableViewSection section];
    section1.headerTitle = @"消息体";
    section1.headerHeight = 50.0f;
    section1.footerHeight = 0;

    [section1 addItem:[self makeItemWithTitle:@"数据大小" content:self.httpModel.uploadFlow last:NO]];
    [section1 addItem:[self makeItemWithTitle:@"Method" content:self.httpModel.method last:NO]];
    [section1 addItem:[self makeItemWithTitle:@"开始时间" content:[NSDate bm_stringFromTs:self.httpModel.startTime] last:YES]];
    
    BMTableViewSection *section2 = [BMTableViewSection section];
    section2.headerTitle = @"链接";
    section2.headerHeight = 50.0f;
    section2.footerHeight = 0;
    
    [section2 addItem:[self makeHeightenItemWithTitle:self.httpModel.url content:nil last:YES]];
    
    BMTableViewSection *section3 = [BMTableViewSection section];
    section3.headerTitle = @"请求头";
    section3.headerHeight = 50.0f;
    section3.footerHeight = 0;
    
    NSDictionary<NSString *, NSString *> *allHTTPHeaderFields = self.httpModel.request.allHTTPHeaderFields;
    NSMutableString *allHTTPHeaderString = [NSMutableString string];
    for (NSString *key in allHTTPHeaderFields)
    {
        NSString *value = allHTTPHeaderFields[key];
        [allHTTPHeaderString appendFormat:@"%@ : %@\n", key, value];
    }
    if (allHTTPHeaderString.length == 0)
    {
        [allHTTPHeaderString appendString:@"NULL"];
    }
    [section3 addItem:[self makeHeightenItemWithTitle:allHTTPHeaderString content:nil last:YES]];
    
    BMTableViewSection *section4 = [BMTableViewSection section];
    section4.headerTitle = @"请求行";
    section4.headerHeight = 50.0f;
    section4.footerHeight = 0;
    
    NSString *requestBody = self.httpModel.requestBody;
    if (!requestBody || requestBody.length == 0)
    {
        requestBody = @"NULL";
    }
    [section4 addItem:[self makeHeightenItemWithTitle:requestBody content:nil last:YES]];
    
    [self.tableManager addSection:section1];
    [self.tableManager addSection:section2];
    [self.tableManager addSection:section3];
    [self.tableManager addSection:section4];
}

- (void)freshResponseTab
{
    [self.tableManager removeAllSections];
    
    BMTableViewSection *section1 = [BMTableViewSection section];
    section1.headerTitle = @"消息体";
    section1.headerHeight = 50.0f;
    section1.footerHeight = 0;
    
    [section1 addItem:[self makeItemWithTitle:@"数据大小" content:self.httpModel.downFlow last:NO]];
    [section1 addItem:[self makeItemWithTitle:@"mineType" content:self.httpModel.mineType last:NO]];
    [section1 addItem:[self makeItemWithTitle:@"接收时间" content:[NSDate bm_stringFromTs:self.httpModel.endTime] last:YES]];
    
    BMTableViewSection *section2 = [BMTableViewSection section];
    section2.headerTitle = @"响应头";
    section2.headerHeight = 50.0f;
    section2.footerHeight = 0;
    
    NSDictionary<NSString *, NSString *> *responseHeaderFields = ((NSHTTPURLResponse *)self.httpModel.response).allHeaderFields;
    NSMutableString *responseHeaderString = [NSMutableString string];
    for (NSString *key in responseHeaderFields)
    {
        NSString *value = responseHeaderFields[key];
        [responseHeaderString appendFormat:@"%@ : %@\r\n",key,value];
    }
    if (responseHeaderString.length == 0)
    {
        [allHTTPHeaderString appendString:@"NULL"];
    }
    [section2 addItem:[self makeHeightenItemWithTitle:responseHeaderString content:nil last:NO]];
    
    BMTableViewSection *section3 = [BMTableViewSection section];
    section3.headerTitle = @"响应行";
    section3.headerHeight = 50.0f;
    section3.footerHeight = 0;
    
    NSString *requestBody = self.httpModel.responseBody;
    if (!requestBody || requestBody.length == 0)
    {
        requestBody = @"NULL";
    }
    [section3 addItem:[self makeHeightenItemWithTitle:requestBody content:nil last:NO]];
    
    [self.tableManager addSection:section1];
    [self.tableManager addSection:section2];
    [self.tableManager addSection:section3];
}

- (BMTableViewItem *)makeItemWithTitle:(NSString *)title content:(NSString *)content last:(BOOL)last
{
    BMTableViewItem *item = [BMTableViewItem itemWithTitle:title subTitle:content imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorAllLeftInset accessoryView:nil selectionHandler:nil];
    item.enabled = NO;
    item.cellStyle = UITableViewCellStyleValue1;
    item.cellHeight = 40.0f;
    item.detailTextAlignment = NSTextAlignmentRight;
    item.underLineColor = UI_DEFAULT_LINECOLOR;
    if (last)
    {
        item.underLineDrawType = BMTableViewCell_UnderLineDrawType_None;
    }
    
    return item;
}

- (BMTableViewItem *)makeHeightenItemWithTitle:(NSString *)title content:(NSString *)content last:(BOOL)last
{
    BMTableViewItem *item = [BMTableViewItem itemWithTitle:title subTitle:content imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorAllLeftInset accessoryView:nil selectionHandler:nil];
    item.cellStyle = UITableViewCellStyleSubtitle;
    item.titleNumberOfLines = 0;
    item.contentMiddleGap = 0.0f;
    item.enabled = NO;
    item.underLineColor = UI_DEFAULT_LINECOLOR;
    if (last)
    {
        item.underLineDrawType = BMTableViewCell_UnderLineDrawType_None;
    }

    [item caleCellHeightWithTableView:self.tableView];

    return item;
}

@end
