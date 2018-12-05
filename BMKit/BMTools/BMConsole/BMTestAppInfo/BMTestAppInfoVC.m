//
//  BMTestAppInfoVC.m
//  fengshun
//
//  Created by jiang deng on 2018/12/4.
//  Copyright © 2018 FS. All rights reserved.
//

#import "BMTestAppInfoVC.h"
#import "BMTableViewManager.h"

@interface BMTestAppInfoVC ()
<
    BMTableViewManagerDelegate
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) BMTableViewManager *tableManager;

@end

@implementation BMTestAppInfoVC

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self bm_setNavigationWithTitle:@"App基本信息" barTintColor:nil leftItemTitle:nil leftItemImage:nil leftToucheEvent:nil rightItemTitle:nil rightItemImage:@"navigationbar_close_icon" rightToucheEvent:@selector(close)];
    
    [self makeUI];
    
    [self freshViews];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)makeUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    self.tableManager = [[BMTableViewManager alloc] initWithTableView:self.tableView];
    self.tableManager.delegate = self;
}

- (void)freshViews
{
    [self.tableManager removeAllSections];
    
    BMTableViewSection *section1 = [BMTableViewSection section];
    section1.headerTitle = @"设备信息";
    section1.headerHeight = 30.0f;
    section1.footerHeight = 0;

    // 获取手机型号
    NSString *iphoneType = [UIDevice bm_devicePlatformString];
    [section1 addItem:[self makeItemWithTitle:@"设备型号" content:iphoneType last:NO]];

    //获取手机系统版本
    NSString *phoneVersion = [UIDevice bm_OSVersion];
    [section1 addItem:[self makeItemWithTitle:@"系统版本" content:phoneVersion last:YES]];

    BMTableViewSection *section2 = [BMTableViewSection section];
    section2.headerTitle = @"APP信息";
    section2.headerHeight = 30.0f;
    section2.footerHeight = 0;
    
    // 获取bundle id
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    [section2 addItem:[self makeItemWithTitle:@"Bundle ID" content:bundleId last:NO]];
    
    // 获取App Build版本号
    NSString *bundleVersionCode = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [section2 addItem:[self makeItemWithTitle:@"Build版本" content:bundleVersionCode last:NO]];

    // 获取App版本
    NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [section2 addItem:[self makeItemWithTitle:@"App版本" content:bundleVersion last:YES]];

    BMTableViewSection *section3 = [BMTableViewSection section];
    section3.headerTitle = @"权限信息";
    section3.headerHeight = 30.0f;
    section3.footerHeight = 0;

    // 地理位置权限
    NSString *locationAuthority = [UIDevice locationAuthority];
    [section3 addItem:[self makeItemWithTitle:@"地理位置权限" content:locationAuthority last:NO]];

    // 网络权限
    NSString *netAuthority = [UIDevice netAuthority];
    [section3 addItem:[self makeItemWithTitle:@"网络权限" content:netAuthority last:NO]];

    // push权限
    NSString *pushAuthority = [UIDevice pushAuthority];
    [section3 addItem:[self makeItemWithTitle:@"push权限" content:pushAuthority last:NO]];

    // 拍照权限
    NSString *cameraAuthority = [UIDevice cameraAuthority];
    [section3 addItem:[self makeItemWithTitle:@"拍照权限" content:cameraAuthority last:NO]];

    // 相册权限
    NSString *photoAuthority = [UIDevice photoAuthority];
    [section3 addItem:[self makeItemWithTitle:@"相册权限" content:photoAuthority last:NO]];

    // 麦克风权限
    NSString *audioAuthority = [UIDevice audioAuthority];
    [section3 addItem:[self makeItemWithTitle:@"麦克风权限" content:audioAuthority last:NO]];
    
    // 通讯录权限
    NSString *addressAuthority = [UIDevice addressAuthority];
    [section3 addItem:[self makeItemWithTitle:@"通讯录权限" content:addressAuthority last:NO]];
    
    // 日历权限
    NSString *calendarAuthority = [UIDevice calendarAuthority];
    [section3 addItem:[self makeItemWithTitle:@"通讯录权限" content:calendarAuthority last:NO]];
    
    // 提醒事项权限
    NSString *remindAuthority = [UIDevice remindAuthority];
    [section3 addItem:[self makeItemWithTitle:@"提醒事项权限" content:remindAuthority last:NO]];
    
    // 蓝牙权限
    NSString *bluetoothAuthority = [UIDevice bluetoothAuthority];
    [section3 addItem:[self makeItemWithTitle:@"蓝牙权限" content:bluetoothAuthority last:YES]];

    [self.tableManager addSection:section1];
    [self.tableManager addSection:section2];
    [self.tableManager addSection:section3];
}

- (BMTableViewItem *)makeItemWithTitle:(NSString *)title content:(NSString *)content last:(BOOL)last
{
    BMTableViewItem *item = [BMTableViewItem itemWithTitle:title subTitle:content imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorAllLeftInset accessoryView:nil selectionHandler:nil];
    item.enabled = NO;
    item.cellStyle = UITableViewCellStyleValue1;
    item.cellHeight = 50.0f;
    item.detailTextAlignment = NSTextAlignmentRight;
    item.underLineColor = UI_DEFAULT_LINECOLOR;
    if (last)
    {
        item.underLineDrawType = BMTableViewCell_UnderLineDrawType_None;
    }
    
    return item;
}

@end
