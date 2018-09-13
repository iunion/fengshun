//
//  BMCombineItem.h
//  DJTableViewManagerSample
//
//  Created by jiang deng on 2018/5/26.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import "BMTableViewItem.h"

#define BMCombine_TitleTop          8.0f
#define BMCombine_TitleLeft         15.0f

#define BMCombine_CountPerLine      3
//#define BMCombine_ShortLineCount    4

#define BMCombine_TopGap            12.0f
#define BMCombine_LineGap           4.0f
#define BMCombine_LeftGap           6.0f
#define BMCombine_ItemHeight        30.0f

#define BMCombine_ItemHGap          20.0f

NS_ASSUME_NONNULL_BEGIN

@class BMCombineItem;
typedef void (^combineSelectedHandler)(BMCombineItem *item);
typedef void (^combineShowAllHandler)(BMCombineItem *item);

@interface BMCombineItem : BMTableViewItem

@property (nonatomic, strong) NSArray<NSString *> *itemArray;

@property (nonatomic, strong, readonly) NSMutableArray<NSNumber *> *selectedIndexArray;

@property (nonatomic, assign) BOOL isMutableSelect;

@property (nullable, nonatomic, copy) combineSelectedHandler selectedHandler;
@property (nullable, nonatomic, copy) combineShowAllHandler showAllHandler;

// UI
@property (nonatomic, assign) BOOL isShowAllItem;

@property (nonatomic, assign, readonly) CGFloat titleWidth;
@property (nonatomic, assign, readonly) CGFloat titleHeight;

@property (nonatomic, assign, readonly) CGFloat itemWidth;
@property (nullable, nonatomic, strong, readonly) NSMutableArray<NSMutableDictionary *> *itemFrameArray;


+ (instancetype)itemWithTitle:(nullable NSString *)title itemArray:(NSArray<NSString *> *)itemArray;
+ (instancetype)itemWithTitle:(nullable NSString *)title itemArray:(NSArray<NSString *> *)itemArray selectedIndexArray:(nullable NSArray<NSNumber *> *)selectedIndexArray;
+ (instancetype)itemWithTitle:(nullable NSString *)title itemArray:(NSArray<NSString *> *)itemArray selectedIndexArray:(nullable NSArray<NSNumber *> *)selectedIndexArray combineSelectedHandler:(nullable combineSelectedHandler)selectedHandler;

- (instancetype)initWithTitle:(nullable NSString *)title itemArray:(NSArray<NSString *> *)itemArray;
- (instancetype)initWithTitle:(nullable NSString *)title itemArray:(NSArray<NSString *> *)itemArray selectedIndexArray:(nullable NSArray<NSNumber *> *)selectedIndexArray;
- (instancetype)initWithTitle:(nullable NSString *)title itemArray:(NSArray<NSString *> *)itemArray selectedIndexArray:(nullable NSArray<NSNumber *> *)selectedIndexArray combineSelectedHandler:(nullable combineSelectedHandler)selectedHandler;

- (void)caleCellHeightWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
