//
//  FSTopicListVC.m
//  fengshun
//
//  Created by best2wa on 2018/9/10.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSTopicListVC.h"

@interface FSTopicListVC ()
// 排序类型
@property (nonatomic, assign)FSTopicSortType m_SortType;

@end

@implementation FSTopicListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithTopicSortType:(FSTopicSortType)sortType{
    if (self = [super init]) {
        self.m_SortType = sortType;
    }
    return self;
}

- (void)createUI{
    self.m_TableView.frame = self.view.bounds;
    
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
