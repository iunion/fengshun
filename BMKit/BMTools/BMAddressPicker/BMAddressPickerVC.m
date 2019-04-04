//
//  BMAddressPickerVC.m
//  BMBaseKit
//
//  Created by jiang deng on 2019/3/29.
//  Copyright © 2019 BM. All rights reserved.
//

#import "BMAddressPickerVC.h"
#import "BMAddressPickerView.h"

@interface BMAddressPickerVC ()

@end

@implementation BMAddressPickerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.definesPresentationContext = YES;

    //self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    BMAddressPickerView *view = [[BMAddressPickerView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT*2/5, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT*3/5)];
    BMWeakSelf
    view.backOnClickClose = ^{
        [weakSelf onClickClose];
    };

    [self.view addSubview:view];
}

- (void)onClickClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
