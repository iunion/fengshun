//
//  BMTableViewCell.h
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2017/8/7.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMTableViewManagerDefine.h"

#import "BMTableViewSection.h"
#import "BMTableViewActionBar.h"

@class BMTableViewManager;
@class BMTableViewItem;

NS_ASSUME_NONNULL_BEGIN

@interface BMTableViewCell : UITableViewCell <BMTableViewActionBarDelegate>

@property (nullable, nonatomic, weak) UITableView *parentTableView;
@property (nullable, nonatomic, weak) BMTableViewManager *tableViewManager;

///-----------------------------
/// @name Working With Keyboard
///-----------------------------
@property (nullable, nonatomic, strong) BMTableViewActionBar *actionBar;

@property (nullable, nonatomic, strong, readonly) UIResponder *responder;
@property (nullable, nonatomic, strong, readonly) NSIndexPath *indexPathForPreviousResponder;
@property (nullable, nonatomic, strong, readonly) NSIndexPath *indexPathForNextResponder;

///-----------------------------
/// @name Managing Cell Appearance
///-----------------------------
@property (nullable, nonatomic, strong, readonly) UIImageView *backgroundImageView;
@property (nullable, nonatomic, strong, readonly) UIImageView *selectedBackgroundImageView;

///-----------------------------
/// @name Accessing Row and Section
///-----------------------------
@property (nonatomic, assign) NSInteger rowIndex;
@property (nonatomic, assign) NSInteger sectionIndex;

@property (nullable, nonatomic, weak) BMTableViewSection *section;
@property (nullable, nonatomic, strong) BMTableViewItem *item;

@property (nonatomic, assign, readonly) BMTableViewCell_PositionType positionType;

@property (nonatomic, assign, readonly) BOOL loaded;

// cell高度
+ (CGFloat)heightWithItem:(BMTableViewItem *)item tableViewManager:(BMTableViewManager *)tableViewManager;

// 是否可以设置Focus
+ (BOOL)canFocusWithItem:(BMTableViewItem *)item;

// 刷新导航工具条
- (void)updateActionBarNavigationControl;

// 布局detailView
- (void)layoutDetailView:(UIView *)view minimumWidth:(CGFloat)minimumWidth;

// 底部连线
- (void)drawSingleLineView;
// 高亮动画
- (void)showHighlightedAnimation;

- (void)cellDidLoad;
- (void)cellWillAppear;
- (void)cellDidDisappear;

- (void)cellLayoutSubviews;

@end

NS_ASSUME_NONNULL_END
