//
//  FSSetupVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/5.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSetupVC.h"
#import "SDImageCache.h"
#import "AppDelegate.h"

#import "FSLoginVerifyVC.h"
#import "FSSetPhoneVC.h"

#import "FSAboutVC.h"
#import "FSAlertView.h"

typedef void(^FSSetupCalculateSizeBlock)(NSString *path, NSUInteger fileCount, NSUInteger totalSize, BOOL finished);
typedef void(^FSSetupClearDiskBlock)(NSString *path, BOOL finished);

@interface FSSetupVC ()

@property (nonatomic, strong) dispatch_queue_t m_CacheQueue;
@property (nonatomic, strong) NSFileManager *m_FileManager;

@property (nonatomic, strong) BMTableViewSection *m_LoginSection;

@property (nonatomic, strong) BMTableViewItem *m_PassWordItem;
@property (nonatomic, strong) BMTableViewItem *m_MobilePhoneItem;

@property (nonatomic, strong) BMTableViewSection *m_BaseSection;

@property (nonatomic, strong) BMTableViewItem *m_CacheItem;
@property (nonatomic, strong) BMTableViewItem *m_UserAgreementItem;
@property (nonatomic, strong) BMTableViewItem *m_AboutItem;

@property (nonatomic, strong) UIView *m_FooterView;
@property (nonatomic, strong) UIButton *m_LogoutBtn;

@end

@implementation FSSetupVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.m_CacheQueue = dispatch_queue_create("com.ftls.FSSetupCache", DISPATCH_QUEUE_SERIAL);
    self.m_FileManager = [[NSFileManager alloc] init];

    self.view.backgroundColor = FS_VIEW_BGCOLOR;
    
    [self bm_setNavigationWithTitle:@"设置" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    
    [self interfaceSettings];
}

- (BOOL)needKeyboardEvent
{
    return NO;
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
    
    self.m_LoginSection = [BMTableViewSection section];
    self.m_BaseSection = [BMTableViewSection section];

    self.m_PassWordItem = [BMTableViewItem itemWithTitle:@"登录密码" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_PassWordItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_PassWordItem.highlightBgColor = UI_COLOR_BL1;
    self.m_PassWordItem.cellHeight = 50.0f;

    self.m_MobilePhoneItem = [BMTableViewItem itemWithTitle:@"绑定手机" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
    }];
    self.m_MobilePhoneItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_MobilePhoneItem.highlightBgColor = UI_COLOR_BL1;
    self.m_MobilePhoneItem.cellHeight = 50.0f;

    self.m_LoginSection.headerHeight = 10.0f;
    self.m_LoginSection.footerHeight = 0.0f;
    [self.m_LoginSection addItem:self.m_PassWordItem];
    [self.m_LoginSection addItem:self.m_MobilePhoneItem];
    
    self.m_CacheItem = [BMTableViewItem itemWithTitle:@"清除缓存" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
        [weakSelf clearCacheDisk];
    }];
    self.m_CacheItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_CacheItem.highlightBgColor = UI_COLOR_BL1;
    self.m_CacheItem.cellHeight = 50.0f;
    
    self.m_UserAgreementItem = [BMTableViewItem itemWithTitle:@"用户协议" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
        NSString *url = [NSString stringWithFormat:@"%@/agreement", FS_H5_SERVER];
        [FSPushVCManager showWebView:weakSelf url:url title:nil];
    }];
    self.m_UserAgreementItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_UserAgreementItem.highlightBgColor = UI_COLOR_BL1;
    self.m_UserAgreementItem.cellHeight = 50.0f;
    
    self.m_AboutItem = [BMTableViewItem itemWithTitle:@"关于我们" imageName:nil underLineDrawType:BMTableViewCell_UnderLineDrawType_None accessoryView:[BMTableViewItem DefaultAccessoryView] selectionHandler:^(BMTableViewItem *item) {
        
        FSAboutVC *vc = [[FSAboutVC alloc] initWithNibName:@"FSAboutVC" bundle:nil];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    self.m_AboutItem.textFont = FS_CELLTITLE_TEXTFONT;
    self.m_AboutItem.highlightBgColor = UI_COLOR_BL1;
    self.m_AboutItem.cellHeight = 50.0f;
    
    self.m_BaseSection.headerHeight = 10.0f;
    [self.m_BaseSection addItem:self.m_CacheItem];
    [self.m_BaseSection addItem:self.m_UserAgreementItem];
    [self.m_BaseSection addItem:self.m_AboutItem];
    
    // footer
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 100.0f)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    CGRect frame;
//    if (IS_IPHONE6P || IS_IPHONEXP)
//    {
//        frame = CGRectMake(0, 0, self.m_TableView.bm_width-60.0f, 44);
//    }
//    else if (IS_IPHONE6 || IS_IPHONEX)
//    {
//        frame = CGRectMake(0, 0, self.m_TableView.bm_width-50.0f, 44);
//    }
//    else
//    {
//        frame = CGRectMake(0, 0, self.m_TableView.bm_width-30.0f, 44);
//    }
//    btn.frame = frame;
    btn.frame = CGRectMake(0, 0, self.m_TableView.bm_width-40.0f, 44);
    btn.backgroundColor = UI_COLOR_BL1;
    btn.titleLabel.font = FS_BUTTON_LARGETEXTFONT;
    btn.exclusiveTouch = YES;
    [btn addTarget:self action:@selector(logoutClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn bm_roundedRect:4.0f];
    self.m_LogoutBtn = btn;
    
    [footerView addSubview:btn];
    [btn bm_centerHorizontallyInSuperViewWithTop:10.0f];
    self.m_FooterView = footerView;

    [self freshViews];
}

- (void)clearCacheDisk
{
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicatorView startAnimating];
    self.m_CacheItem.accessoryView = activityIndicatorView;
    self.m_CacheItem.enabled = NO;
    
    NSMutableArray *cachePathArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    // SDWebImage cache
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSString *cachePath = [cache getDiskCachePath];
    [cachePathArray addObject:cachePath];

    // 搜索历史
    cachePath = [FSUserInfoDB getSearchHistoryPath];
    [cachePathArray addObject:cachePath];

    BMWeakSelf
    [self clearDiskWithFilePathArray:cachePathArray completionBlock:^(NSString *path, BOOL finished) {
        if (finished)
        {
            [weakSelf freshViews];
        }
    }];
    
    // 搜索历史
    //[FSUserInfoDB cleanUserSearchHistroyDataWithUserId:[FSUserInfoModel userInfo].m_UserBaseInfo.m_UserId];
}

- (void)calculateCacheDiskSize
{
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicatorView startAnimating];
    self.m_CacheItem.accessoryView = activityIndicatorView;
    self.m_CacheItem.enabled = NO;
    
    NSMutableArray *cachePathArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    // SDWebImage cache
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSString *cachePath = [cache getDiskCachePath];
    [cachePathArray addObject:cachePath];
    
    BMWeakSelf
    [self calculateSizeWithFilePathArray:cachePathArray completionBlock:^(NSString *path, NSUInteger fileCount, NSUInteger totalSize, BOOL finished) {
        if (finished)
        {
            BMImageTextView *imageTextView = [[BMImageTextView alloc] initWithText:[NSString bm_storeStringWithBitSize:totalSize]];
            imageTextView.textColor = UI_COLOR_B4;
            imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
            imageTextView.showTableCellAccessoryArrow = YES;
            weakSelf.m_CacheItem.accessoryView = imageTextView;
            weakSelf.m_CacheItem.enabled = YES;
            [weakSelf.m_TableView reloadData];
        }
    }];
}

- (void)freshViews
{
    [self.m_TableManager removeAllSections];
    
    BMWeakSelf
    
    BMImageTextView *imageTextView;

    if ([FSUserInfoModel isLogin])
    {
        FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
        
        NSString *text = nil;
        if ([userInfo.m_UserBaseInfo.m_PhoneNum bm_isNotEmpty])
        {
            self.m_PassWordItem.selectionHandler = ^(id item) {
                FSLoginVerifyVC *vc = [[FSLoginVerifyVC alloc] initWithVerificationType:FSVerificationCodeType_UpdatePassword phoneNum:userInfo.m_UserBaseInfo.m_PhoneNum];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            
            text = [userInfo.m_UserBaseInfo.m_PhoneNum bm_maskAtRang:NSMakeRange(3, 4) withMask:'*'];
            
            self.m_MobilePhoneItem.selectionHandler = ^(id item) {
                FSLoginVerifyVC *vc = [[FSLoginVerifyVC alloc] initWithVerificationType:FSVerificationCodeType_UpdatePhoneNumOld phoneNum:userInfo.m_UserBaseInfo.m_PhoneNum];
                vc.m_PopToViewController = weakSelf;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
        }
        else
        {
            text = @"未绑定";
            
//            self.m_MobilePhoneItem.selectionHandler = ^(id item) {
//                FSSetPhoneVC *vc = [[FSSetPhoneVC alloc] init];
//                [weakSelf.navigationController pushViewController:vc animated:YES];
//            };
        }
        imageTextView = [[BMImageTextView alloc] initWithText:text];
        imageTextView.textColor = UI_COLOR_B4;
        imageTextView.textFont = FS_CELLTITLE_TEXTFONT;
        imageTextView.showTableCellAccessoryArrow = YES;
        self.m_MobilePhoneItem.accessoryView = imageTextView;

        [self.m_TableManager addSection:self.m_LoginSection];
        
        self.m_TableView.tableFooterView = self.m_FooterView;
    }
    else
    {
        self.m_TableView.tableFooterView = nil;
    }
    
    [self calculateCacheDiskSize];
    
    [self.m_TableManager addSection:self.m_BaseSection];

    [self.m_TableView reloadData];
}

- (void)logoutClick:(UIButton *)btn
{
    FSAlertView *alertView = [FSAlertView showAlertWithTitle:@"确定退出当前账号？" message:nil cancelTitle:@"取消" otherTitle:@"退出" completion:^(BOOL cancelled, NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            [GetAppDelegate logOutWithApi];
        }
    }];
    alertView.otherBtnTextColor = [UIColor redColor];
}

- (void)calculateSizeWithFilePathArray:(NSArray *)filePathArray completionBlock:(FSSetupCalculateSizeBlock)completionBlock
{
    dispatch_async(self.m_CacheQueue, ^{
        NSUInteger allFileCount = 0;
        NSUInteger allTotalSize = 0;

        for (NSString *filPath in filePathArray)
        {
            NSURL *diskCacheURL = [NSURL fileURLWithPath:filPath isDirectory:YES];
            
            NSUInteger fileCount = 0;
            NSUInteger totalSize = 0;
            
            NSDirectoryEnumerator *fileEnumerator = [self.m_FileManager enumeratorAtURL:diskCacheURL
                                                             includingPropertiesForKeys:@[NSFileSize]
                                                                                options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                           errorHandler:NULL];
            
            for (NSURL *fileURL in fileEnumerator)
            {
                NSNumber *fileSize;
                [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
                totalSize += fileSize.unsignedIntegerValue;
                fileCount += 1;
            }
            
            allFileCount += fileCount;
            allTotalSize += totalSize;

            if (completionBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(filPath, fileCount, totalSize, NO);
                });
            }
        }
        
        if (completionBlock)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, allFileCount, allTotalSize, YES);
            });
        }
    });
}

- (void)clearDiskWithFilePathArray:(NSArray *)filePathArray completionBlock:(FSSetupClearDiskBlock)completion
{
    dispatch_async(self.m_CacheQueue, ^{
        for (NSString *filPath in filePathArray)
        {
            [self.m_FileManager removeItemAtPath:filPath error:nil];
            [self.m_FileManager createDirectoryAtPath:filPath
                          withIntermediateDirectories:YES
                                           attributes:nil
                                                error:NULL];
            
            if (completion)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(filPath, NO);
                });
            }
        }
        
        if (completion)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, YES);
            });
        }
    });
}

@end
