//
//  FSHeaderCommonSelector.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSHeaderCommonSelector.h"
#import "BMTableViewManager.h"

#define FSSelectorDefaultHeaderHeight 42
#define FSSelectorDefaultCellHeight 44


@interface FSHeaderCommonSelectorView ()
@property (nonatomic, assign) CGFloat       m_HeaderHeight;
@property (nonatomic, assign) NSInteger     m_SelectedTag;
@property (nonatomic, strong) NSArray       *m_TitleBtnArray;
@property (nonatomic, strong) UITableView   *m_TableView;
@property (nonatomic, strong) BMTableViewManager *m_manager;
@property (nonatomic, strong) BMTableViewSection *m_section;

@end

@implementation FSHeaderCommonSelectorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        if (self.bm_height == 0) {
            self.bm_height = FSSelectorDefaultHeaderHeight;
        }
        self.m_HeaderHeight = self.bm_height;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)dataArray
{
    self = [self initWithFrame:frame];
    
    if (self) {
        self.m_DataArray = dataArray;
    }
    
    return self;
}

-(void)setM_DataArray:(NSArray<FSHeaderCommonSelectorModel *> *)m_DataArray
{
    _m_DataArray = m_DataArray;
    [self buildUI];
}

- (void)buildUI
{
    if (![_m_DataArray bm_isNotEmpty]) {
        return;
    }
    
    [self bm_removeAllSubviews];
    
    NSInteger index = 0;
    NSInteger count = _m_DataArray.count;
    CGFloat width = self.bm_width/count;
    for (FSHeaderCommonSelectorModel *model in _m_DataArray) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width*index, 0, width, self.bm_height)];
        [self addSubview:btn];
        [btn setImage:[UIImage imageNamed:@"search_openFilters"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:model.title forState:UIControlStateNormal];
        [btn setTitleColor:UI_COLOR_B1 forState:UIControlStateNormal];
        btn.tag = index+1;
        [btn bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageRight imageTitleGap:7];
        [btn addTarget:self action:@selector(btnClickActions:) forControlEvents:UIControlEventTouchUpInside];

        index ++;
        if (index < count) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(width*index, (self.bm_height - 24)/2, 1, 24)];
            line.backgroundColor = UI_COLOR_B6;
            [self addSubview:line];
        }
    }
    
    self.m_TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.bm_height, self.bm_width, 0) style:UITableViewStylePlain];
    self.m_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.m_TableView.rowHeight = FSSelectorDefaultCellHeight;
    self.m_TableView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.m_TableView];
    
    self.m_manager = [[BMTableViewManager alloc] initWithTableView:_m_TableView];
    _m_section = [BMTableViewSection section];
    _m_section.headerHeight = 0;
    _m_section.footerHeight = 0;
    [_m_manager addSection:_m_section];
}

- (void)btnClickActions:(UIButton *)btn
{
    if (_m_SelectedTag == btn.tag)
    {
        [self hideTableView];
    }
    else
    {
        _m_SelectedTag = btn.tag;
        [self showTableView];
    }
}

- (void)showTableView
{
    if (_m_SelectedTag > 0)
    {
        [_m_section removeAllItems];
        
        FSHeaderCommonSelectorModel *tagModel = self.m_DataArray[_m_SelectedTag-1];
        NSInteger count = tagModel.list.count;
        for (int index = 0; index < count; index++)
        {
            FSSelectorListModel *rowModel = tagModel.list[index];
            
            BMWeakSelf
            BMTableViewItem *item = [BMTableViewItem itemWithTitle:rowModel.showName
                                                          subTitle:nil
                                                         imageName:nil
                                                 underLineDrawType:BMTableViewCell_UnderLineDrawType_SeparatorLeftInset
                                                     accessoryView:nil
                                                  selectionHandler:^(BMTableViewItem *item) {
                                                      BMStrongSelf
                                                      if (self.selectorBlock) {
                                                          self.selectorBlock(tagModel, rowModel);
                                                      }
                                                      [self hideTableView];
                                                  }];
            item.cellStyle  = UITableViewCellStyleDefault;
            item.textFont   = [UIFont systemFontOfSize:14.0f];
            item.textColor  = UI_COLOR_B1;
            item.underLineColor = UI_COLOR_B6;
            item.cellHeight = FSSelectorDefaultCellHeight;
            [self.m_section addItem:item];
        }

        BMTableViewItem *item = self.m_section.items.lastObject;
        item.underLineDrawType = BMTableViewCell_UnderLineDrawType_None;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.m_TableView.bm_height = FSSelectorDefaultCellHeight * count;
            self.bm_height = _m_HeaderHeight + self.m_TableView.bm_height;
            [_m_TableView reloadData];
        }];
    }
}

- (void)hideTableView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.m_TableView.bm_height = 0;
        self.bm_height = _m_HeaderHeight;
    } completion:^(BOOL finished) {
        [_m_section removeAllItems];
        [_m_TableView reloadData];
        _m_SelectedTag = 0;
    }];
}

@end

@implementation FSHeaderCommonSelectorModel

+ (instancetype)modelWithTitle:(NSString *)title hiddenkey:(NSString *)key list:(NSArray *)array
{
    return [[FSHeaderCommonSelectorModel alloc] initWithTitle:title hiddenkey:key list:array];
}

- (instancetype)initWithTitle:(NSString *)title hiddenkey:(NSString *)key list:(NSArray *)array
{
    self = [super init];
    
    if (self) {
        _title = title;
        _hiddenkey = key;
        _list = array;
    }
    
    return self;
}

@end


@implementation FSSelectorListModel

+ (instancetype)modelWithName:(NSString *)name key:(NSString *)key
{
    return [[FSSelectorListModel alloc] initWithName:name key:key];
}

- (instancetype)initWithName:(NSString *)name key:(NSString *)key
{
    self = [super init];
    
    if (self) {
        _showName = name;
        _hiddenkey = key;
    }
    
    return self;
}

@end
