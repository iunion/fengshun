//
//  FSScrollPageSegment.h
//  match
//
//  Created by dengjiang on 15/9/22.
//  Copyright (c) 2015年 SCD. All rights reserved.
//

#import <UIKit/UIKit.h>


#define FSScrollPageSegment_Height 44


@protocol FSScrollPageSegmentDelegate;

@interface FSScrollPageSegment : UIView

// 点击Button代理
@property (nonatomic, weak) id <FSScrollPageSegmentDelegate> delegate;

// 未选中时的Title颜色
@property (nonatomic, strong) UIColor *m_TextColor;
// 选中时的Title颜色
@property (nonatomic, strong) UIColor *m_SelectTextColor;

@property (nonatomic, assign) CGFloat m_TextFontSize;

// 初始化方法
- (instancetype)initWithTitles:(NSArray *)titles titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor isEqualDivide:(BOOL)isEqualDivide;

- (instancetype)initWithTitles:(NSArray *)titles titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor titleFontSize:(CGFloat)fontSize isEqualDivide:(BOOL)isEqualDivide;

// 适用于分割线配置的初始化方法
+ (instancetype)attachedSegmentWithFrame:(CGRect)frame showUnderLine:(BOOL)showUnderLine showTopline:(BOOL)showTopline moveLineFrame:(CGRect)moveLineFrame isEqualDivide:(BOOL)isEqualDivide showGapline:(BOOL)showGapline;

// 该方法只限2.0版定期,活期首页使用
- (instancetype)initWithFrame:(CGRect)frame moveLineFrame:(CGRect)moveLineFrame isEqualDivide:(BOOL)isEqualDivide;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor showUnderLine:(BOOL)showUnderLine moveLineFrame:(CGRect)moveLineFrame isEqualDivide:(BOOL)isEqualDivide fresh:(BOOL)fresh;


// 刷新方法
- (void)freshButtonWithTitles:(NSArray *)titleArray titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor;

// 下划线的颜色
- (void)setMoveLineColor:(UIColor *)movelineColor;
// 是否隐藏下划线
- (void)setM_IsHiddenUnderLine:(BOOL)isHiddenUnderLine;

// 滚动完成之后调用：调整Btn显示
- (void)selectBtnAtIndex:(NSUInteger)index;

// 滚动之中调用：调整line位置和大小
//- (void)scrollLineFromIndex:(NSInteger)fromIndex relativeOffsetX:(CGFloat)relativeOffsetX;
//- (void)scrollLineFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

// 判断是否通过点击btn出发的滚动
- (BOOL)isClickBtnWithScroll:(NSUInteger)index;

@end


@protocol FSScrollPageSegmentDelegate <NSObject>


- (void)scrollSegment:(FSScrollPageSegment *)scrollSegment selectedButtonAtIndex:(NSUInteger)index;

@end
