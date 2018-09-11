//
//  FSFilterHeaderResultView.h
//  fengshun
//
//  Created by Aiwei on 2018/9/4.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSearchResultView.h"
#import "BMTableViewManager.h"

#define FILTER_HEADER_HEIGHT 85.0f
#define FILTER_BUTTON_HEIGHT 40.0f
#define FILTER_ROW_HEIGHT 42.0f
#define FILTER_ANIM_DUR 0.5f


typedef NS_ENUM(NSUInteger, FSFilterShowList) {
    FSFilterShowList_None,
    FSFilterShowList_Left,
    FSFilterShowList_Right
};

@interface FSFilterHeaderResultView : FSSearchResultView
@property (nonatomic, strong) UIButton *m_leftButton;
@property (nonatomic, strong) UIButton *m_rightButton;

// 筛选条件展示相关
@property (nonatomic, strong) FSTableView *        m_filterList;
@property (nonatomic, strong) NSArray<NSString *> *m_filterArray;
@property (nonatomic, assign) FSFilterShowList     m_showList;

// 筛选条件
@property (nonatomic, strong) NSArray<NSString *> *m_leftFilters;
@property (nonatomic, strong) NSArray<NSString *> *m_rightFilters;

@property (nonatomic, strong) BMTableViewManager *m_manager;
@property (nonatomic, strong) BMTableViewSection *m_section;


- (void)showFilterList;

- (void)selectedRowAtIndex:(NSInteger)index isLeftfilter:(BOOL)isLeft;

@end
