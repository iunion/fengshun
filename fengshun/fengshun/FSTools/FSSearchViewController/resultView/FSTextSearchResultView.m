//
//  FSTextSearchResultView.m
//  fengshun
//
//  Created by Aiwei on 2018/9/10.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSTextSearchResultView.h"
#import "FSTextSearchResultVC.h"


@interface FSTextSearchResultView()

@property(nonatomic, strong)NSArray <FSListTextModel *>* m_textList;
@property(nonatomic, weak)FSTextSearchResultVC *m_textResultVC;

@end
@implementation FSTextSearchResultView

-(instancetype)initWithFrame:(CGRect)frame andResultVC:(FSSearchResultVC *)resultVC
{
    self = [super initWithFrame:frame andResultVC:resultVC];
    if (self) {
        _m_textResultVC = (FSTextSearchResultVC *)resultVC;
        BMWeakSelf
        resultVC.m_searchsucceed = ^(id resultModel) {
            weakSelf.m_textList = resultModel;

        };
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andResultVC:[[FSTextSearchResultVC alloc]initWithNibName:nil bundle:nil freshViewType:BMFreshViewType_NONE]];
}
- (void)configTableView
{
    [super configTableView];

    [self.m_tableView registerNib:[UINib nibWithNibName:@"FSTextListCell" bundle:nil] forCellReuseIdentifier:@"FSTextListCell"];
    self.m_tableView.estimatedRowHeight = 52;
}
- (NSInteger)m_totalCount
{
    return _m_textList.count;
}
- (void)searchAction
{
    _m_textResultVC.m_keyword = self.m_searchKey;
    [_m_textResultVC loadApiData];
}
@end
