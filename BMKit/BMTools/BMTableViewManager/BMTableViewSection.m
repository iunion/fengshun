//
//  BMTableViewSection.m
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2017/4/20.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "BMTableViewSection.h"
#import "BMTableViewManager.h"
#import "BMTableViewItem.h"

CGFloat const BMTableViewSectionHeaderHeightAutomatic = DBL_MAX;
CGFloat const BMTableViewSectionFooterHeightAutomatic = DBL_MAX;

CGFloat const BMTableViewCellTitlePadding = 5.0f;

@interface BMTableViewSection ()

@property (nonatomic, strong) NSMutableArray *mutableItems;

@end


@implementation BMTableViewSection

+ (instancetype)section
{
    return [[self alloc] init];
}

+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle
{
    return [[self alloc ] initWithHeaderTitle:headerTitle footerTitle:nil];
}

+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle
{
    return [[self alloc] initWithHeaderTitle:headerTitle footerTitle:footerTitle];
}

+ (instancetype)sectionWithHeaderView:(UIView *)headerView
{
    return [[self alloc] initWithHeaderView:headerView footerView:nil];
}

+ (instancetype)sectionWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView
{
    return [[self alloc] initWithHeaderView:headerView footerView:footerView];
}

- (instancetype)init
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    self.mutableItems = [[NSMutableArray alloc] init];
    self.headerHeight = BMTableViewSectionHeaderHeightAutomatic;
    self.footerHeight = BMTableViewSectionFooterHeightAutomatic;
    self.cellTitlePadding = BMTableViewCellTitlePadding;
    
    return self;
}

- (instancetype)initWithHeaderTitle:(NSString *)headerTitle
{
    return [self initWithHeaderTitle:headerTitle footerTitle:nil];
}

- (instancetype)initWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle
{
    self = [self init];
    if (!self)
    {
        return nil;
    }
    
    self.headerTitle = headerTitle;
    self.footerTitle = footerTitle;
    
    return self;
}

- (instancetype)initWithHeaderView:(UIView *)headerView
{
    return [self initWithHeaderView:headerView footerView:nil];
}

- (instancetype)initWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView
{
    self = [self init];
    if (!self)
    {
        return nil;
    }
    
    self.headerView = headerView;
    self.footerView = footerView;
    
    return self;
}

- (CGFloat)maximumTitleWidthWithFont:(UIFont *)font
{
    CGFloat width = 0;
    for (BMTableViewItem *item in self.mutableItems)
    {
#warning maximumTitleWidthWithFont
        if ([item isKindOfClass:[BMTableViewItem class]])
        {
            CGSize size = CGSizeZero;
            if (item.titleAttrStr)
            {
                size = [item.titleAttrStr bm_sizeToFitWidth:CGFLOAT_MAX];
            }
            else if (item.title)
            {
                if (item.textFont)
                {
                    font = item.textFont;
                }
                
                size = [item.title bm_sizeToFitWidth:CGFLOAT_MAX withFont:font];
            }
            
            width = MAX(width, size.width);
        }
    }
    return width + self.cellTitlePadding;
}

- (BMTableViewCellStyle *)style
{
    return _style ? _style : self.tableViewManager.style;
}

- (NSUInteger)index
{
    BMTableViewManager *tableViewManager = self.tableViewManager;
    return [tableViewManager.sections indexOfObject:self];
}


#pragma mark -
#pragma mark Managing items

- (NSArray *)items
{
    return self.mutableItems;
}

- (void)addItem:(id)item
{
    if ([item isKindOfClass:[BMTableViewItem class]])
    {
        ((BMTableViewItem *)item).section = self;
    }
    
    [self.mutableItems addObject:item];
}

- (void)addItemsFromArray:(NSArray *)array
{
    for (BMTableViewItem *item in array)
    {
        if ([item isKindOfClass:[BMTableViewItem class]])
        {
            item.section = self;
        }
    }
    
    [self.mutableItems addObjectsFromArray:array];
}

- (void)insertItem:(id)item atIndex:(NSUInteger)index
{
    if ([item isKindOfClass:[BMTableViewItem class]])
        ((BMTableViewItem *)item).section = self;
    
    [self.mutableItems insertObject:item atIndex:index];
}

- (void)insertItems:(NSArray *)items atIndexes:(NSIndexSet *)indexes
{
    for (BMTableViewItem *item in items)
    {
        if ([item isKindOfClass:[BMTableViewItem class]])
        {
            item.section = self;
        }
    }

    [self.mutableItems insertObjects:items atIndexes:indexes];
}

- (void)removeItem:(id)item
{
    [self.mutableItems removeObject:item];
}

- (void)removeItem:(id)item inRange:(NSRange)range
{
    [self.mutableItems removeObject:item inRange:range];
}

- (void)removeAllItems
{
    [self.mutableItems removeAllObjects];
}

- (void)removeItemIdenticalTo:(id)item
{
    [self.mutableItems removeObjectIdenticalTo:item];
}

- (void)removeItemIdenticalTo:(id)item inRange:(NSRange)range
{
    [self.mutableItems removeObjectIdenticalTo:item inRange:range];
}

- (void)removeItemsInArray:(NSArray *)otherArray
{
    [self.mutableItems removeObjectsInArray:otherArray];
}

- (void)removeItemsInRange:(NSRange)range
{
    [self.mutableItems removeObjectsInRange:range];
}

- (void)removeLastItem
{
    [self.mutableItems removeLastObject];
}

- (void)removeItemAtIndex:(NSUInteger)index
{
    [self.mutableItems removeObjectAtIndex:index];
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes
{
    [self.mutableItems removeObjectsAtIndexes:indexes];
}

- (void)replaceItemAtIndex:(NSUInteger)index withItem:(id)item
{
    if ([item isKindOfClass:[BMTableViewItem class]])
    {
        ((BMTableViewItem *)item).section = self;
    }
    
    [self.mutableItems replaceObjectAtIndex:index withObject:item];
}

- (void)replaceItemsWithItemsFromArray:(NSArray *)otherArray
{
    [self removeAllItems];
    [self addItemsFromArray:otherArray];
}

- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)items
{
    for (BMTableViewItem *item in items)
    {
        if ([item isKindOfClass:[BMTableViewItem class]])
        {
            item.section = self;
        }
    }
    
    [self.mutableItems replaceObjectsAtIndexes:indexes withObjects:items];
}

- (void)exchangeItemAtIndex:(NSUInteger)idx1 withItemAtIndex:(NSUInteger)idx2
{
    [self.mutableItems exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)sortItemsUsingFunction:(NSInteger (NS_NOESCAPE *)(id, id, void *))compare context:(void *)context
{
    [self.mutableItems sortUsingFunction:compare context:context];
}

- (void)sortItemsUsingSelector:(SEL)comparator
{
    [self.mutableItems sortUsingSelector:comparator];
}

- (void)reloadSectionWithAnimation:(UITableViewRowAnimation)animation
{
    [self.tableViewManager.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.index] withRowAnimation:animation];
}

@end
