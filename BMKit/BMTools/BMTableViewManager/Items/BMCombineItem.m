//
//  BMCombineItem.m
//  DJTableViewManagerSample
//
//  Created by jiang deng on 2018/5/26.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import "BMCombineItem.h"

@interface BMCombineItem ()

// for UI
@property (nonatomic, assign) CGFloat titleWidth;
@property (nonatomic, assign) CGFloat titleHeight;

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *itemFrameArray;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *selectedIndexArray;

@end

@implementation BMCombineItem

+ (instancetype)itemWithTitle:(NSString *)title itemArray:(NSArray<NSString *> *)itemArray
{
    return [[self alloc] initWithTitle:title itemArray:itemArray];
}

+ (instancetype)itemWithTitle:(NSString *)title itemArray:(NSArray<NSString *> *)itemArray selectedIndexArray:(NSArray<NSNumber *> *)selectedIndexArray
{
    return [[self alloc] initWithTitle:title itemArray:itemArray selectedIndexArray:selectedIndexArray];
}

+ (instancetype)itemWithTitle:(NSString *)title itemArray:(NSArray<NSString *> *)itemArray selectedIndexArray:(NSArray<NSNumber *> *)selectedIndexArray combineSelectedHandler:(combineSelectedHandler)selectedHandler
{
    return [[self alloc] initWithTitle:title itemArray:itemArray selectedIndexArray:selectedIndexArray combineSelectedHandler:selectedHandler];
}

- (instancetype)initWithTitle:(NSString *)title itemArray:(NSArray<NSString *> *)itemArray
{
    return [self initWithTitle:title itemArray:itemArray selectedIndexArray:nil];
}

- (instancetype)initWithTitle:(NSString *)title itemArray:(NSArray<NSString *> *)itemArray selectedIndexArray:(NSArray<NSNumber *> *)selectedIndexArray
{
    return [self initWithTitle:title itemArray:itemArray selectedIndexArray:selectedIndexArray combineSelectedHandler:nil];
}

- (instancetype)initWithTitle:(NSString *)title itemArray:(NSArray<NSString *> *)itemArray selectedIndexArray:(NSArray<NSNumber *> *)selectedIndexArray combineSelectedHandler:(combineSelectedHandler)selectedHandler
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    //self.isShowSelectBg = NO;
    self.isShowHighlightBg = NO;
    
    self.title = title;
    self.itemArray = itemArray;
    self.selectedIndexArray = [NSMutableArray arrayWithArray:selectedIndexArray];
    
    self.selectedHandler = selectedHandler;
    
    return self;
}

- (void)caleCellHeightWithTableView:(UITableView *)tableView
{
    CGFloat height = BMCombine_TitleTop;
    self.titleWidth = UI_SCREEN_WIDTH-(tableView.contentInset.left+tableView.contentInset.right)-BMCombine_TitleLeft*2;
    if (self.titleAttrStr)
    {
        CGSize maxSize = CGSizeMake(self.titleWidth, CGFLOAT_MAX);
        self.titleHeight = ceil([self.titleAttrStr bm_sizeToFit:maxSize lineBreakMode:NSLineBreakByCharWrapping].height);
    }
    else
    {
        self.titleHeight = ceil([self.title bm_heightToFitWidth:self.titleWidth withFont:self.textFont]);
    }
    
    height += self.titleHeight;
    
    height += BMCombine_TopGap;
    
    CGFloat itemWidth = (self.titleWidth - BMCombine_LeftGap*2 - BMCombine_ItemHGap*(BMCombine_CountPerLine-1))/BMCombine_CountPerLine;
    self.itemWidth = itemWidth;
    
    NSUInteger lines = (self.itemArray.count + BMCombine_CountPerLine - 1) / BMCombine_CountPerLine;
    if (!self.isShowAllItem)
    {
        lines = 0;
    }
    
    height += (BMCombine_LineGap + BMCombine_ItemHeight)*lines;
    
    height += BMCombine_TopGap;
    
    self.cellHeight = height;
}

@end
