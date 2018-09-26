//
//  FSDetailWebVC.m
//  fengshun
//
//  Created by best2wa on 2018/9/26.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSDetailWebVC.h"

@interface FSDetailWebVC ()

@end

@implementation FSDetailWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registerJS];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
- (void)registerJS
{
    // 分享
    [self registerHander:@"toShare" handler:^(id data, WVJBResponseCallback responseCallback) {
        
    }];
    // 收藏
    [self registerHander:@"toCollect" handler:^(id data, WVJBResponseCallback responseCallback) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
