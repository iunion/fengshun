//
//  FSMyColumnVC.m
//  fengshun
//
//  Created by 龚旭杰 on 2019/4/23.
//  Copyright © 2019年 FS. All rights reserved.
//

#import "FSMyColumnVC.h"
#import "FSSpecialColumnCell.h"

@interface FSMyColumnVC ()

@end

@implementation FSMyColumnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)createUI
{
    self.m_showEmptyView = YES;
    [self showEmptyViewWithType:BMEmptyViewType_NoData];
    [self.m_TableView registerNib:[UINib nibWithNibName:@"FSSpecialColumnCell" bundle:nil] forCellReuseIdentifier:@"FSSpecialColumnCell"];
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
