//
//  FSSearchResultView.h
//  fengshun
//
//  Created by Aiwei on 2018/9/4.
//  Copyright © 2018 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSSearchResultVC.h"
#import "FSApiRequest.h"

#define SEARCH_DEFAULT_SIZE 10.0f
#define SEARCH_HEADER_HEIGHT 23.0f

@interface FSSearchResultView : UIView
<
    UITableViewDelegate
>

// 结果VC,负责管理数据的相关事件
@property (nonatomic, readonly) FSSearchResultVC *m_resultVC;

// 主VC,负责管理页面push
@property (nonatomic, weak)     UIViewController *m_masterVC;
@property (nonatomic, readonly) FSTableView *     m_tableView;
@property (nonatomic, readonly) NSString *        m_searchKey;
@property (nonatomic, readonly) NSArray *         m_searchKeys;
@property (nonatomic, readonly) NSInteger         m_totalCount;

- (instancetype)initWithFrame:(CGRect)frame andResultVC:(FSSearchResultVC *)resultVC;

// 这些方法供子类使用
- (void)configTableView;

- (void)searchWithKey:(NSString *)key;
- (void)keysRemoveKey:(NSString *)key;

// 这些方法需子类实现
- (void)searchAction;


@end
