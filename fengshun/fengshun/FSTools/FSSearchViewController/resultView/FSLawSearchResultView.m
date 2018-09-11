//
//  FSLawSearchResultView.m
//  fengshun
//
//  Created by Aiwei on 2018/9/10.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSLawSearchResultView.h"
#import "FSLawSearchresultVC.h"

@interface FSLawSearchResultView()

@property(nonatomic, weak)FSLawSearchResultVC *m_lawResultVC;

@end

@implementation FSLawSearchResultView

-(instancetype)initWithFrame:(CGRect)frame andResultVC:(FSSearchResultVC *)resultVC
{
    self = [super initWithFrame:frame andResultVC:resultVC];
    if (self) {
        _m_lawResultVC = (FSLawSearchResultVC *)resultVC;
        BMWeakSelf
        resultVC.m_searchsucceed = ^(id resultModel) {
            BMStrongSelf
            // 持有返回结果
            [self setupFilterHeader];
        };
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andResultVC:[[FSLawSearchResultVC alloc] initWithNibName:nil bundle:nil freshViewType:BMFreshViewType_Bottom]];
}
- (void)configTableView
{
    [super configTableView];
    [self.m_tableView registerNib:[UINib nibWithNibName:@"FSLawSearchResultCell" bundle:nil] forCellReuseIdentifier:@"FSLawSearchResultCell"];
    self.m_tableView.estimatedRowHeight = 180;
}
- (NSInteger)m_totalCount
{
    return 0;
}

- (void)setupFilterHeader
{
 
    [self showFilterList];
}

- (void)searchWithKey:(NSString *)key
{
    [super searchWithKey:key];
    
    if ([self.m_searchKeys bm_isNotEmpty]) {
        [self.m_resultVC loadApiData];
    }
}
- (void)selectedRowAtIndex:(NSInteger)index isLeftfilter:(BOOL)isLeft
{
   
}
@end
