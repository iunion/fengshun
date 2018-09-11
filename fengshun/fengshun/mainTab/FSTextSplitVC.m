//
//  FSTextSplitVC.m
//  fengshun
//
//  Created by Aiwei on 2018/9/11.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSTextSplitVC.h"

@interface FSTextSplitVC ()

@end

@implementation FSTextSplitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bm_NavigationItemTintColor = UI_COLOR_B1;
    self.bm_NavigationShadowHidden = NO;
    self.bm_NavigationShadowColor = UI_COLOR_B6;
    
    [self bm_setNavigationWithTitle:@"文书范本" barTintColor:nil leftItemTitle:nil leftItemImage:nil leftToucheEvent:nil rightItemTitle:@"取消" rightItemImage:nil rightToucheEvent:@selector(cancelSearch:)];
    [self setBm_NavigationBarImage:[UIImage imageWithColor:[UIColor whiteColor]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
