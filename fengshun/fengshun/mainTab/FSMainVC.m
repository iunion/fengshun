//
//  FSMainVC.m
//  fengshun
//
//  Created by jiang deng on 2018/8/25.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMainVC.h"
#import "FSSearchViewController.h"

@interface FSMainVC ()

@end

@implementation FSMainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 80, 40)];
    [btn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)next:(id)sender
{
    FSSearchViewController *searchViewController = [[FSSearchViewController alloc] initWithSearchKey:@"test" hotSearchTags:@[@"1", @"2"] searchHandler:^(NSString *search) {
        NSLog(@"search");
    }];
    [self.navigationController pushViewController:searchViewController animated:YES];
}


@end
