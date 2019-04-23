//
//  FSSetCompanyVC.m
//  fengshun
//
//  Created by jiang deng on 2019/4/11.
//  Copyright © 2019 FS. All rights reserved.
//

#import "FSSetCompanyVC.h"
#import "AppDelegate.h"

//#import "FSAddressPickerVC.h"
#import "FSEditorVC.h"

@interface FSSetCompanyVC ()
<
    FSEditorDelegate
>

@property (nonatomic, strong) BMTableViewSection *m_WorkSection;

@property (nonatomic, strong) BMTableViewItem *m_NameItem;
//@property (nonatomic, strong) BMTableViewItem *m_AreaItem;
@property (nonatomic, strong) BMTableViewItem *m_AddressItem;

@end

@implementation FSSetCompanyVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = FS_VIEW_BGCOLOR;
    self.m_TableView.bounces = YES;
    
    [self bm_setNavigationWithTitle:@"所属单位" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    
    [self interfaceSettings];
}

- (BOOL)needKeyboardEvent
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)interfaceSettings
{
    [super interfaceSettings];
    
    BMWeakSelf
    
    self.m_WorkSection = [BMTableViewSection section];

    // 单位名称
    self.m_NameItem = [BMTableViewItem itemWithTitle:@"单位名称" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_NameItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_NameItem.highlightBgColor = UI_COLOR_BL1;
    self.m_NameItem.cellHeight = 50.0f;
    
    // 位置信息
//    self.m_AreaItem = [BMTableViewItem itemWithTitle:@"工作区域" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
//
//        FSAddressPickerVC *vc = [[FSAddressPickerVC alloc] init];
//
//        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//        weakSelf.modalPresentationStyle = UIModalPresentationCurrentContext;
//        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//
//        [weakSelf presentViewController:vc animated:YES completion:^{
//
//        }];
//    }];
//    self.m_AreaItem.textFont = FS_CELLTITLE_TEXTFONT;
//    self.m_AreaItem.highlightBgColor = UI_COLOR_BL1;
//    self.m_AreaItem.cellHeight = 50.0f;

    // 详细地址
    self.m_AddressItem = [BMTableViewItem itemWithTitle:@"详细地址" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_AddressItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_AddressItem.highlightBgColor = UI_COLOR_BL1;
    self.m_AddressItem.cellHeight = 50.0f;
    
    self.m_WorkSection.headerHeight = 10.0f;
    self.m_WorkSection.footerHeight = 0.0f;
    [self.m_WorkSection addItem:self.m_NameItem];
    //[self.m_WorkSection addItem:self.m_AreaItem];
    [self.m_WorkSection addItem:self.m_AddressItem];
    
    [self.m_TableManager addSection:self.m_WorkSection];
    
    [self freshViews];
}

- (void)freshViews
{
    FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
    
    BMWeakSelf
    
    NSString *text = nil;
    if ([userInfo.m_UserBaseInfo.m_Organization bm_isNotEmpty])
    {
        text = userInfo.m_UserBaseInfo.m_Organization;
    }
    else
    {
        text = @"请填写";
    }
    BMImageTextView *imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    self.m_NameItem.accessoryView = imageTextView;
    self.m_NameItem.selectionHandler = ^(id item) {
        FSEditorVC *editorVC = [[FSEditorVC alloc] initWithOperaType:FSUpdateUserInfo_Organization minWordCount:0 maxnWordCount:100 text:userInfo.m_UserBaseInfo.m_Organization placeholderText:nil];
        editorVC.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:editorVC animated:YES];
    };
    
//    if ([userInfo.m_UserBaseInfo.m_CompanyArea bm_isNotEmpty])
//    {
//        text = userInfo.m_UserBaseInfo.m_CompanyArea;
//    }
//    else
//    {
//        text = @"请选择";
//    }
//    imageTextView = [[BMImageTextView alloc] initWithText:text];
//    imageTextView.textColor = UI_COLOR_B4;
//    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
//    imageTextView.showTableCellAccessoryArrow = YES;
//    imageTextView.maxWidth = self.m_TableView.bm_width - 120.0f;
//    self.m_AreaItem.accessoryView = imageTextView;

    if ([userInfo.m_UserBaseInfo.m_CompanyAddress bm_isNotEmpty])
    {
        text = userInfo.m_UserBaseInfo.m_CompanyAddress;
    }
    else
    {
        text = @"请填写";
    }
    imageTextView = [[BMImageTextView alloc] initWithText:text];
    imageTextView.textColor = UI_COLOR_B4;
    imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
    imageTextView.showTableCellAccessoryArrow = YES;
    self.m_AddressItem.accessoryView = imageTextView;
    self.m_AddressItem.selectionHandler = ^(id item) {
        FSEditorVC *editorVC = [[FSEditorVC alloc] initWithOperaType:FSUpdateUserInfo_Organization minWordCount:0 maxnWordCount:100 text:userInfo.m_UserBaseInfo.m_Organization placeholderText:nil];
        editorVC.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:editorVC animated:YES];
    };
}


#pragma mark -
#pragma mark FSEditorDelegate

- (void)editorFinishedWithOperaType:(FSUpdateUserInfoOperaType)operaType value:(NSString *)value
{
    FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
    
    switch (operaType)
    {
        case FSUpdateUserInfo_Organization:
            userInfo.m_UserBaseInfo.m_Organization = value;
            break;
                        
        default:
            break;
    }
    
    [FSUserInfoDB insertAndUpdateUserInfo:userInfo];
    GetAppDelegate.m_UserInfo = userInfo;
    
    [self freshViews];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:userInfoChangedNotification object:nil userInfo:nil];
}


@end
