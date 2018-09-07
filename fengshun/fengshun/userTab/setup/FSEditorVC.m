//
//  FSEditorVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/7.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSEditorVC.h"

@interface FSEditorVC ()

@end

@implementation FSEditorVC

- (BMFreshViewType)getFreshViewType
{
    return BMFreshViewType_NONE;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = FS_VIEW_BGCOLOR;

    [self bm_setNavigationWithTitle:@"" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_setup_icon" leftToucheEvent:@selector(setUpAction:) rightItemTitle:nil rightItemImage:@"navigationbar_message_icon" rightToucheEvent:@selector(messageAction:)];
    
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
}

@end
