//
//  BMTableViewManager.h
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2017/4/20.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "BMTableViewManagerDefine.h"

#import "BMTableViewCellStyle.h"
#import "BMTableViewSection.h"

#import "BMTableViewItem.h"
#import "BMTextItem.h"
#import "BMMaskTextItem.h"
#import "BMNumberTextItem.h"
#import "BMStepperInputItem.h"
#import "BMLongTextItem.h"
#import "BMBoolItem.h"
#import "BMPickerItem.h"
#import "BMDateTimeItem.h"
#import "BMSegmentItem.h"
#import "BMCheckBoxGroupItem.h"
#import "BMSliderItem.h"
#import "BMImageDetailItem.h"
#import "BMCombineItem.h"

#import "BMTableViewTextCell.h"
#import "BMTableViewMaskTextCell.h"
#import "BMTableViewNumberTextCell.h"
#import "BMTableViewStepperInputCell.h"
#import "BMTableViewLongTextCell.h"
#import "BMTableViewBoolCell.h"
#import "BMTableViewPickerCell.h"
#import "BMTableViewDateTimeCell.h"
#import "BMTableViewSegmentCell.h"
#import "BMTableViewCheckBoxGroupCell.h"
#import "BMTableViewSliderCell.h"
#import "BMTableViewImageDetailCell.h"
#import "BMTableViewCombineCell.h"

@protocol BMTableViewManagerDelegate;


NS_ASSUME_NONNULL_BEGIN

@interface BMTableViewManager : NSObject <UITableViewDelegate, UITableViewDataSource>

// The object that acts as the delegate of the receiving table view.
@property (nullable, nonatomic, weak) id <BMTableViewManagerDelegate> delegate;

@property (nullable, nonatomic, weak) UITableView *tableView;

// The array of sections. See BMTableViewSection reference for details.
@property (nullable, nonatomic, strong, readonly) NSArray *sections;
// The object that provides styling for `UITableView`. See BMTableViewCellStyle reference for details.
@property (nullable, nonatomic, strong) BMTableViewCellStyle *style;

///-----------------------------
/// @name Managing Custom Cells
///-----------------------------

/**
 The array of pairs of items / cell classes.
 */
@property (nullable, nonatomic, strong) NSMutableDictionary *registeredClasses;

/**
 For each custom item class that the manager will use, register a cell class.
 
 @param objectClass The object class to be associated with a cell class.
 @param identifier The cell class identifier.
 #param bundle The resource gbundle.
 */
- (void)registerClass:(NSString *)objectClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(NSString *)objectClass forCellWithReuseIdentifier:(NSString *)identifier bundle:(nullable NSBundle *)bundle;

/**
 Returns cell class at specified index path.
 
 @param indexPath The index path of cell.
 */
- (nullable Class)classForCellAtIndexPath:(NSIndexPath *)indexPath;

///-----------------------------
/// @name Creating and Initializing a BMTableViewManager
///-----------------------------

- (instancetype)initWithTableView:(UITableView *)tableView;

- (instancetype)initWithTableView:(UITableView *)tableView delegate:(nullable id <BMTableViewManagerDelegate>)delegate;

- (void)addSection:(BMTableViewSection *)section;
- (void)addSectionsFromArray:(NSArray *)array;

- (void)insertSection:(BMTableViewSection *)section atIndex:(NSUInteger)index;
- (void)insertSections:(NSArray *)sections atIndexes:(NSIndexSet *)indexes;

- (void)removeSection:(BMTableViewSection *)section;
- (void)removeSection:(BMTableViewSection *)section inRange:(NSRange)range;
- (void)removeAllSections;

- (void)removeSectionIdenticalTo:(BMTableViewSection *)section;
- (void)removeSectionIdenticalTo:(BMTableViewSection *)section inRange:(NSRange)range;
- (void)removeSectionsInArray:(NSArray *)otherArray;
- (void)removeSectionsInRange:(NSRange)range;

- (void)removeLastSection;
- (void)removeSectionAtIndex:(NSUInteger)index;
- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes;

- (void)replaceSectionAtIndex:(NSUInteger)index withSection:(BMTableViewSection *)section;
- (void)replaceSectionsAtIndexes:(NSIndexSet *)indexes withSections:(NSArray *)sections;
- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray *)otherArray;

- (void)exchangeSectionAtIndex:(NSUInteger)idx1 withSectionAtIndex:(NSUInteger)idx2;

- (void)sortSectionsUsingFunction:(NSInteger (NS_NOESCAPE *)(id, id, void * _Nullable))compare context:(nullable void *)context;
- (void)sortSectionsUsingSelector:(SEL)comparator;

// 弹出键盘
- (void)showKeyBordWithVisibleCells;
- (void)showKeyBordAtIndexPath:(NSIndexPath *)indexPath;

//- (NSInteger)indexOfFirstResponder;

@end


@protocol BMTableViewManagerDelegate <UITableViewDelegate>

@optional

- (void)tableView:(UITableView *)tableView willLayoutCellSubviews:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView willLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
