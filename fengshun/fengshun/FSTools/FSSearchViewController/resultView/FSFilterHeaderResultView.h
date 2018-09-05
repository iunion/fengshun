//
//  FSFilterHeaderResultView.h
//  fengshun
//
//  Created by Aiwei on 2018/9/4.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSearchReaultView.h"
#import "BMTableViewManager.h"

#define FILTER_HEADER_HEIGHT 85.0f
#define FILTER_BUTTON_HEIGHT 40.0f
#define FILTER_ROW_HEIGHT 42.0f
#define FILTER_ANIM_DUR 1.5f


typedef NS_ENUM(NSUInteger, FSFilterShowList) {
    FSFilterShowList_None,
    FSFilterShowList_Left,
    FSFilterShowList_Right
};

@interface FSFilterHeaderResultView : FSSearchReaultView
@property (nonatomic, strong) UIButton *m_leftButton;
@property (nonatomic, strong) UIButton *m_rightButton;

// 筛选条件展示相关
@property (nonatomic, strong) FSTableView *    m_filterList;
@property (nonatomic, strong) NSArray *        m_filterArray;
@property (nonatomic, assign) FSFilterShowList m_showList;

// 筛选条件
@property (nonatomic, strong) NSArray *m_leftFilters;
@property (nonatomic, strong) NSArray *m_rightFilters;

@property (nonatomic, strong) BMTableViewManager *manager;
@property (nonatomic, strong) BMTableViewSection *section;

@property (nonatomic, readonly) NSArray *searchKeys;


- (void)showFilterList;

@end
