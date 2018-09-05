//
//  FSRulesSearchResultView.m
//  fengshun
//
//  Created by Aiwei on 2018/9/4.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSRulesSearchResultView.h"

@implementation FSRulesSearchResultView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.m_leftButton setTitle:@"效力级别" forState:UIControlStateNormal];
        [self.m_rightButton setTitle:@"时效性" forState:UIControlStateNormal];
        [self loadData];
    }
    return self;
}
- (void)loadData
{
    // 调试时使用,实际为网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.m_leftFilters = @[@"1",@"2",@"3"];
        self.m_rightFilters = @[@"one",@"two",@"three"];
        if (self.m_showList) {
            self.m_filterArray = (self.m_showList == FSFilterShowList_Left)?self.m_leftFilters:self.m_rightFilters;
            [self showFilterList];
        }
    });
    
}
@end
