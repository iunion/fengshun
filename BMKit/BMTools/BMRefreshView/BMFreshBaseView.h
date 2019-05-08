//
//  BMFreshBaseView.h
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMFreshView.h"

@class BMFreshBaseView;
@protocol BMFreshViewDelegate;

// 刷新状态回调
typedef void (^BMFreshViewFreshStateBlock)(BMFreshBaseView * _Nonnull freshView, BMFreshState state);
// 开始刷新后的回调(进入刷新状态后的回调)
typedef void (^BMFreshViewBeginFreshingBlock)(BMFreshBaseView * _Nonnull freshView);
// 结束刷新后的回调
typedef void (^BMFreshViewEndFreshingBlock)(BMFreshBaseView * _Nonnull freshView);

@interface BMFreshBaseView : UIView
{
    // 备份scrollView刚开始的inset
    UIEdgeInsets _scrollViewOriginalInset;
}

// 优先级高于freshStateBlock
@property (nullable, nonatomic, weak) id<BMFreshViewDelegate> delegate;

// 父窗口控件 scrollView
@property (nullable, nonatomic, weak, readonly) UIScrollView *scrollView;
// 备份scrollView刚开始的inset
@property (nonatomic, assign, readonly) UIEdgeInsets scrollViewOriginalInset;

// 拖动最大高度，触发刷新状态改变临界点
@property (nonatomic, assign) CGFloat pullMaxHeight;

// 刷新状态
@property (nonatomic, assign) BMFreshState freshState;
// 是否正在刷新
@property (nonatomic, assign, readonly, getter=isReFreshing) BOOL reFreshing;

// 刷新状态回调
@property (nullable, nonatomic, copy) BMFreshViewFreshStateBlock freshStateBlock;
// 以下和 freshStateBlock 会有重合，会先调用 freshStateBlock
// 开始刷新后的回调(进入刷新状态后的回调)
@property (nullable, nonatomic, copy) BMFreshViewBeginFreshingBlock beginFreshingBlock;
// 结束刷新后的回调
@property (nullable, nonatomic, copy) BMFreshViewEndFreshingBlock endFreshingBlock;

// 拉拽的百分比
@property (assign, nonatomic) CGFloat pullingPercent;
// 根据拖拽比例自动切换透明度
@property (nonatomic, assign, getter=isAutomaticallyChangeAlpha) BOOL automaticallyChangeAlpha;

#pragma mark - UI setting

// 所有状态对应的文字
@property (nullable, nonatomic, strong, readonly) NSMutableDictionary *stateTitles;


- (void)prepare;

// 需要子类自行创建
- (void)makeSubviews;
// 刷新UI
- (void)freshSubviews;

// 当scrollView的contentOffset发生改变的时候调用
- (void)scrollViewContentOffsetDidChange:(nullable NSDictionary *)change;

// 当scrollView的contentSize发生改变的时候调用
- (void)scrollViewContentSizeDidChange:(nullable NSDictionary *)change;

// 当scrollView的contentInset发生改变的时候调用
//- (void)scrollViewContentInsetDidChange:(NSDictionary *)change;

// 当scrollView的拖拽状态发生改变的时候调用
- (void)scrollViewPanStateDidChange:(nullable NSDictionary *)change;


#pragma mark - 刷新状态控制

- (void)freshStateError;
- (void)freshStateIdle;
- (void)freshStateWillRefresh;
- (void)freshStateRefreshing;
- (void)freshStateNoMoreData;

// 进入刷新状态
- (void)beginReFreshing;
// 结束刷新状态
// 需外部调用恢复所有初始状态
- (void)endReFreshing;

- (void)setFreshTitle:(nullable id)title forState:(BMFreshState)state;
- (void)setFreshTitles:(nullable NSDictionary *)titles;

+ (CGFloat)zoomFloatData:(CGFloat)data fromMin:(CGFloat)fromMin fromMax:(CGFloat)fromMax toMin:(CGFloat)toMin toMax:(CGFloat)toMax;

@end

@protocol BMFreshViewDelegate <NSObject>

@optional
- (void)freshView:(nonnull BMFreshBaseView *)freshView changeState:(BMFreshState)state;

@end
