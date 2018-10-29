//
//  FSScrollPageView.h
//  miaoqian
//
//  Created by dengjiang on 16/5/10.
//  Copyright © 2016年 MiaoQian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FSScrollPageSegment.h"

@protocol FSScrollPageViewDataSource;
@protocol FSScrollPageViewDelegate;

@interface FSScrollPageView : UIView

@property (nonatomic, weak) id <FSScrollPageViewDataSource> datasource;
@property (nonatomic, weak) id <FSScrollPageViewDelegate> delegate;

@property (nonatomic, strong, readonly) FSScrollPageSegment *m_SegmentBar;
@property (nonatomic, strong, readonly) UIScrollView *m_ScrollView;

// 未选中时的Title颜色
@property (nonatomic, strong) UIColor *m_TitleColor;
// 选中时的Title颜色
@property (nonatomic, strong) UIColor *m_TitleSelectColor;


//@property (assign, nonatomic) UIColor *m_UnderlineColor;
//@property (assign, nonatomic) UIColor *m_TabBgColor;


- (instancetype)initWithFrame:(CGRect)frame titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor;
- (instancetype)initWithFrame:(CGRect)frame titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor isEqualDivideSegment:(BOOL)isEqualDivideSegment;

// 该方法只限2.0版定期,活期首页使用
- (instancetype)initWithFrame:(CGRect)frame titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor scrollPageSegment:(FSScrollPageSegment *)scrollPageSegment isSubViewPageSegment:(BOOL)isSubViewPageSegment;

- (void)setM_TitleColor:(UIColor *)titleColor;
- (void)setM_TitleSelectColor:(UIColor *)titleSelectColor;

// 下划线的颜色
- (void)setM_MoveLineColor:(UIColor *)movelineColor;
// 顶部菜单栏的背景颜色
- (void)setM_TabBgColor:(UIColor *)tabBgColor;

// 加载数据
- (void)reloadPage;

- (void)scrollPageWithIndex:(NSUInteger)index;

@end


@protocol FSScrollPageViewDataSource <NSObject>

- (NSUInteger)scrollPageViewNumberOfPages:(FSScrollPageView *)scrollPageView;
- (NSString *)scrollPageView:(FSScrollPageView *)scrollPageView titleAtIndex:(NSUInteger)index;
- (id)scrollPageView:(FSScrollPageView *)scrollPageView pageAtIndex:(NSUInteger)index;

@end


@protocol FSScrollPageViewDelegate <NSObject>

@optional

- (void)scrollPageViewChangeToIndex:(NSUInteger)index;

@end
