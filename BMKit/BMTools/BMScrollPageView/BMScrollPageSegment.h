//
//  BMScrollPageSegment.h
//  BMBaseKit
//
//  Created by jiang deng on 2019/1/31.
//  Copyright © 2019 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BMScrollPageSegmentDelegate;

@interface BMScrollPageSegment : UIView

// Segment点击代理
@property (nonatomic, weak) id <BMScrollPageSegmentDelegate> delegate;

// 未选中时的Title颜色
@property (nonatomic, strong) UIColor *titleColor;
// 选中时的Title颜色
@property (nonatomic, strong) UIColor *titleSelectedColor;
// Title字体
@property (nonatomic, strong) UIFont *titleFont;

// 标记线颜色
@property (nonatomic, strong) UIColor *moveLineColor;
// 是否显示标记线
@property (nonatomic, assign) BOOL showMoveLine;

// 上边线颜色
@property (nonatomic, strong) UIColor *topLineColor;
// 是否显示上边线
@property (nonatomic, assign) BOOL showTopLine;
// 下边线颜色
@property (nonatomic, strong) UIColor *bottomLineColor;
// 是否显示下边线
@property (nonatomic, assign) BOOL showBottomLine;

// 编辑按钮
@property (nonatomic, strong) NSString *moreImage;
@property (nonatomic, assign) BOOL showMore;
@property (nonatomic, strong, readonly) UIButton *moreBtn;

// 分割线颜色
@property (nonatomic, strong) UIColor *gapLineColor;
// 是否显示分割线
@property (nonatomic, assign) BOOL showGapLine;

// 是否平分segment
@property (nonatomic, assign) BOOL equalDivide;

// 标题数据
@property (nonatomic, strong, readonly) NSMutableArray *titleArray;
// 当前位置index
@property (nonatomic, assign, readonly) NSUInteger currentIndex;

- (void)freshItemsWithTitles:(NSArray *)titleArray;
- (void)freshItemsWithTitles:(NSArray *)titleArray titleColor:(UIColor *)titleColor titleSelectedColor:(UIColor *)titleSelectedColor titleFont:(UIFont *)titleFont;

// 只调整定位，不联动
- (void)selectItemAtIndex:(NSUInteger)index;

@end

@protocol BMScrollPageSegmentDelegate <NSObject>

- (void)scrollSegment:(BMScrollPageSegment *)scrollSegment selectedItemAtIndex:(NSUInteger)index;

@optional
- (void)scrollSegmentSetSegments:(BMScrollPageSegment *)scrollSegment;

@end


NS_ASSUME_NONNULL_END
