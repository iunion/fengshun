//
//  FSTopicDetailVC.m
//  fengshun
//
//  Created by best2wa on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSTopicDetailVC.h"
#import "FSMoreViewVC.h"

@interface FSTopicDetailVC ()<FSMoreViewVCDelegate>

@end

@implementation FSTopicDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self bm_setNavigationWithTitle:@"" barTintColor:nil leftDicArray:nil rightDicArray:@[[self bm_makeBarButtonDictionaryWithTitle:@" " image:@"community_more" toucheEvent:@"shareAction" buttonEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:0]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareAction
{
    [FSMoreViewVC showMore:self delegate:self];
}

- (void)moreViewClickWithType:(NSInteger)index
{
    BMLog(@"%ld",index);
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
