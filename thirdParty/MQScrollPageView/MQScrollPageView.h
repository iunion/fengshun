//
//  MQScrollPageView.h
//  miaoqian
//
//  Created by dengjiang on 16/5/10.
//  Copyright © 2016年 MiaoQian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MQScrollPageSegment.h"

@protocol MQScrollPageViewDataSource;
@protocol MQScrollPageViewDelegate;

@interface MQScrollPageView : UIView

@property (nonatomic, weak) id <MQScrollPageViewDataSource> datasource;
@property (nonatomic, weak) id <MQScrollPageViewDelegate> delegate;

// 未选中时的Title颜色
@property (nonatomic, strong) UIColor *m_TitleColor;
// 选中时的Title颜色
@property (nonatomic, strong) UIColor *m_TitleSelectColor;


//@property (assign, nonatomic) UIColor *m_UnderlineColor;
//@property (assign, nonatomic) UIColor *m_TabBgColor;


- (instancetype)initWithFrame:(CGRect)frame titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor;
- (instancetype)initWithFrame:(CGRect)frame titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor isEqualDivideSegment:(BOOL)isEqualDivideSegment;

// 该方法只限2.0版定期,活期首页使用
- (instancetype)initWithFrame:(CGRect)frame titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor scrollPageSegment:(MQScrollPageSegment *)scrollPageSegment isSubViewPageSegment:(BOOL)isSubViewPageSegment;

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


@protocol MQScrollPageViewDataSource <NSObject>

- (NSUInteger)scrollPageViewNumberOfPages:(MQScrollPageView *)scrollPageView;
- (NSString *)scrollPageView:(MQScrollPageView *)scrollPageView titleAtIndex:(NSUInteger)index;
- (id)scrollPageView:(MQScrollPageView *)scrollPageView pageAtIndex:(NSUInteger)index;

@end


@protocol MQScrollPageViewDelegate <NSObject>

@optional

- (void)scrollPageViewChangeToIndex:(NSUInteger)index;

@end
