//
//  FSVideoMessageListVC.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoMessageListVC.h"

@interface FSVideoMessageListVC ()

@end

@implementation FSVideoMessageListVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self bm_setNavigationWithTitle:@"消息记录" barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];

}


@end
