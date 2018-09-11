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


@interface FSSearchResultView : UIView


@property (nonatomic, readonly) FSSearchResultVC *m_resultVC;
@property (nonatomic, readonly) FSTableView *     m_tableView;
@property (nonatomic, readonly) NSString *        m_searchKey;
@property (nonatomic, readonly) NSArray *         m_searchKeys;
@property (nonatomic, readonly) NSInteger         m_totalCount;

- (instancetype)initWithFrame:(CGRect)frame andResultVC:(FSSearchResultVC *)resultVC;

// 这些方法供子类使用
- (void)configTableView;

- (void)searchWithKey:(NSString *)key;
- (void)keysRemoveKey:(NSString *)key;

@end
