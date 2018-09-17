//
//  FSAlertVC.m
//  fengshun
//
//  Created by best2wa on 2018/9/17.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSAlertVC.h"

@interface
FSAlertVC ()

@end

@implementation FSAlertVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.alertBgColor       = [UIColor whiteColor];
    self.alertMarkBgColor   = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    self.alertMarkBgEffect  = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.alertTitleFont     = [UIFont systemFontOfSize:18.f];
    self.alertTitleColor    = [UIColor bm_colorWithHexString:@"333333"];
    self.alertMessageFont   = [UIFont systemFontOfSize:14.f];
    self.alertMessageColor  = [UIColor bm_colorWithHexString:@"333333"];
    self.cancleBtnBgColor   = [UIColor whiteColor];
    self.otherBtnBgColor    = [UIColor whiteColor];
    self.cancleBtnTextColor = [UIColor bm_colorWithHexString:@"999999"];
    self.otherBtnTextColor  = [UIColor bm_colorWithHexString:@"577EEE"];
    self.btnFont            = [UIFont systemFontOfSize:16.f];
    self.alertGapLineColor  = [UIColor bm_colorWithHexString:@"D8D8D8"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
