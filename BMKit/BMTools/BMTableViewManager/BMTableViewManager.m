//
//  BMTableViewManager.m
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2017/4/20.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "BMTableViewManager.h"

@interface BMTableViewManager ()

@property (strong, nonatomic) NSMutableDictionary *registeredXIBs;

@property (strong, readwrite, nonatomic) NSMutableArray *mutableSections;
@property (assign, readonly, nonatomic) CGFloat defaultTableViewSectionHeight;

/**
 For each custom item class that the manager will use, register a cell class.
 
 @param objectClass The object class to be associated with a cell class.
 @param identifier The cell class identifier.
 */
- (void)registerClass:(NSString *)objectClass forCellWithReuseIdentifier:(NSString *)identifier;

/**
 For each custom item class that the manager will use, register a cell class.
 
 @param objectClass The object class to be associated with a cell class.
 @param identifier The cell class identifier.
 @param bundle The resource gbundle.
 */
- (void)registerClass:(NSString *)objectClass forCellWithReuseIdentifier:(NSString *)identifier bundle:(nullable NSBundle *)bundle;

/**
 Returns cell class at the keyed subscript.
 
 @param key The keyed subscript.
 @return The cell class the keyed subscript.
 */
- (id)objectAtKeyedSubscript:(id <NSCopying>)key;

/**
 Sets a cell class for the keyed subscript.
 
 @param obj The cell class to set for the keyed subscript.
 @param key The keyed subscript.
 */
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

@end

@implementation BMTableViewManager

- (void)dealloc
{
    self.delegate = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"init not supported, use initWithTableView: instead." userInfo:nil];
    return nil;
}

- (instancetype)initWithTableView:(UITableView *)tableView
{
    return [self initWithTableView:tableView delegate:nil];
}

- (instancetype)initWithTableView:(UITableView *)tableView delegate:(id <BMTableViewManagerDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        tableView.delegate = self;
        tableView.dataSource = self;
        
        self.tableView = tableView;
        
        // 开始拖拽滑动时，收起键盘
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        self.registeredClasses = [[NSMutableDictionary alloc] init];
        self.registeredXIBs = [[NSMutableDictionary alloc] init];

        self.mutableSections = [[NSMutableArray alloc] init];
        self.style = [[BMTableViewCellStyle alloc] init];
        
        [self registerDefaultClasses];
    }
    
    return self;
}

- (CGFloat)defaultTableViewSectionHeight
{
    return self.tableView.style == UITableViewStyleGrouped ? TABLE_CELL_HEIGHT : 22.0f;
}

- (NSArray *)sections
{
    return self.mutableSections;
}


#pragma mark -
#pragma mark registeredClasses

- (void)registerDefaultClasses
{
#warning add your Class here
    
    self[@"__NSCFConstantString"] = @"BMTableViewCell";
    self[@"__NSCFString"] = @"BMTableViewCell";
    
    if (NSClassFromString(@"NSTaggedPointerString"))
    {
        self[@"NSTaggedPointerString"] = @"BMTableViewCell";
    }

    self[@"NSString"] = @"BMTableViewCell";
    self[@"BMTableViewItem"] = @"BMTableViewCell";
    self[@"BMTextItem"] = @"BMTableViewTextCell";
    self[@"BMMaskTextItem"] = @"BMTableViewMaskTextCell";
    self[@"BMNumberTextItem"] = @"BMTableViewNumberTextCell";
    self[@"BMStepperInputItem"] = @"BMTableViewStepperInputCell";
    self[@"BMLongTextItem"] = @"BMTableViewLongTextCell";
    self[@"BMBoolItem"] = @"BMTableViewBoolCell";
    self[@"BMPickerItem"] = @"BMTableViewPickerCell";
    self[@"BMDateTimeItem"] = @"BMTableViewDateTimeCell";
    self[@"BMSegmentItem"] = @"BMTableViewSegmentCell";
    self[@"BMCheckBoxGroupItem"] = @"BMTableViewCheckBoxGroupCell";
    self[@"BMSliderItem"] = @"BMTableViewSliderCell";
    self[@"BMImageDetailItem"] = @"BMTableViewImageDetailCell";
    self[@"BMCombineItem"] = @"BMTableViewCombineCell";


    // add your Class here
}

- (Class)classForCellAtIndexPath:(NSIndexPath *)indexPath
{
    BMTableViewSection *section = self.mutableSections[indexPath.section];
    NSObject *item = section.items[indexPath.row];
    return self.registeredClasses[item.class];
}

- (void)registerClass:(NSString *)objectClass forCellWithReuseIdentifier:(NSString *)identifier
{
    [self registerClass:objectClass forCellWithReuseIdentifier:identifier bundle:nil];
}

- (void)registerClass:(NSString *)objectClass forCellWithReuseIdentifier:(NSString *)identifier bundle:(NSBundle *)bundle
{
    NSAssert(NSClassFromString(objectClass), ([NSString stringWithFormat:@"Item class '%@' does not exist.", objectClass]));
    NSAssert(NSClassFromString(identifier), ([NSString stringWithFormat:@"Cell class '%@' does not exist.", identifier]));
    self.registeredClasses[(id <NSCopying>)NSClassFromString(objectClass)] = NSClassFromString(identifier);
    
    // Perform check if a XIB exists with the same name as the cell class
    //
    if (!bundle)
        bundle = [NSBundle mainBundle];
    
    if ([bundle pathForResource:identifier ofType:@"nib"])
    {
        self.registeredXIBs[identifier] = objectClass;
        [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:bundle] forCellReuseIdentifier:objectClass];
    }
}

- (id)objectAtKeyedSubscript:(id <NSCopying>)key
{
    return self.registeredClasses[key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key
{
    [self registerClass:(NSString *)key forCellWithReuseIdentifier:obj];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mutableSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex)
    {
        return 0;
    }
    return ((BMTableViewSection *)self.mutableSections[sectionIndex]).items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMTableViewSection *section = self.mutableSections[indexPath.section];
    BMTableViewItem *item = section.items[indexPath.row];
    
    UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
    if ([item isKindOfClass:[BMTableViewItem class]])
    {
        cellStyle = ((BMTableViewItem *)item).cellStyle;
    }
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"BMTableViewManager_%@_%@", [item class], @(cellStyle)];
    
    Class cellClass = [self classForCellAtIndexPath:indexPath];
    
    if (self.registeredXIBs[NSStringFromClass(cellClass)])
    {
        cellIdentifier = self.registeredXIBs[NSStringFromClass(cellClass)];
    }
    
    if ([item respondsToSelector:@selector(cellIdentifier)] && item.cellIdentifier)
    {
        cellIdentifier = item.cellIdentifier;
    }
    
    BMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    void (^loadCell)(BMTableViewCell *cell) = ^(BMTableViewCell *cell) {
        cell.tableViewManager = self;
        
        // BMTableViewManagerDelegate
        //
        if ([self.delegate conformsToProtocol:@protocol(BMTableViewManagerDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willLoadCell:forRowAtIndexPath:)])
            [self.delegate tableView:tableView willLoadCell:cell forRowAtIndexPath:indexPath];
        
        [cell cellDidLoad];
        
        // BMTableViewManagerDelegate
        //
        if ([self.delegate conformsToProtocol:@protocol(BMTableViewManagerDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didLoadCell:forRowAtIndexPath:)])
            [self.delegate tableView:tableView didLoadCell:cell forRowAtIndexPath:indexPath];
    };
    
    if (cell == nil)
    {
        cell = [[cellClass alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier];
        
        loadCell(cell);
    }
    
    if ([cell isKindOfClass:[BMTableViewCell class]] && [cell respondsToSelector:@selector(loaded)] && !cell.loaded)
    {
        loadCell(cell);
    }
    
    cell.rowIndex = indexPath.row;
    cell.sectionIndex = indexPath.section;
    cell.parentTableView = tableView;
    cell.section = section;
    cell.item = item;
    
    cell.detailTextLabel.text = nil;
    
    [cell cellWillAppear];
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *titles;
    for (BMTableViewSection *section in self.mutableSections)
    {
        if (section.indexTitle)
        {
            titles = [NSMutableArray array];
            break;
        }
    }
    
    if (titles)
    {
        for (BMTableViewSection *section in self.mutableSections)
        {
            [titles addObject:section.indexTitle ? section.indexTitle : @""];
        }
    }
    
    return titles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex)
    {
        return nil;
    }
    BMTableViewSection *section = self.mutableSections[sectionIndex];
    return section.headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex)
    {
        return nil;
    }
    BMTableViewSection *section = self.mutableSections[sectionIndex];
    return section.footerTitle;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    BMTableViewSection *sourceSection = self.mutableSections[sourceIndexPath.section];
    BMTableViewItem *item = sourceSection.items[sourceIndexPath.row];
    [sourceSection removeItemAtIndex:sourceIndexPath.row];
    
    BMTableViewSection *destinationSection = self.mutableSections[destinationIndexPath.section];
    [destinationSection insertItem:item atIndex:destinationIndexPath.row];
    
    if (item.moveCompletionHandler)
    {
        item.moveCompletionHandler(item, sourceIndexPath, destinationIndexPath);
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mutableSections.count <= indexPath.section)
    {
        return NO;
    }
    
    BMTableViewSection *section = self.mutableSections[indexPath.section];
    if (section.items.count >= indexPath.row)
    {
        return NO;
    }
    
    BMTableViewItem *item = section.items[indexPath.row];
    return item.moveHandler != nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [self.mutableSections count])
    {
        BMTableViewSection *section = self.mutableSections[indexPath.section];
        if (indexPath.row < [section.items count])
        {
            BMTableViewItem *item = section.items[indexPath.row];
            if ([item isKindOfClass:[BMTableViewItem class]])
            {
                return item.editingStyle != UITableViewCellEditingStyleNone || item.moveHandler;
            }
        }
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        BMTableViewSection *section = self.mutableSections[indexPath.section];
        BMTableViewItem *item = section.items[indexPath.row];
        if (item.deletionHandlerWithCompletion)
        {
            item.deletionHandlerWithCompletion(item, ^{
                [section removeItemAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                for (NSInteger i = indexPath.row; i < section.items.count; i++)
                {
                    //BMTableViewItem *afterItem = [[section items] objectAtIndex:i];
                    //BMTableViewCell *cell = (BMTableViewCell *)[tableView cellForRowAtIndexPath:afterItem.indexPath];
                    BMTableViewCell *cell = (BMTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                    cell.rowIndex--;
                }
            });
        }
        else
        {
            if (item.deletionHandler)
            {
                item.deletionHandler(item);
            }
            [section removeItemAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            for (NSInteger i = indexPath.row; i < section.items.count; i++)
            {
                //BMTableViewItem *afterItem = [[section items] objectAtIndex:i];
                //BMTableViewCell *cell = (BMTableViewCell *)[tableView cellForRowAtIndexPath:afterItem.indexPath];
                BMTableViewCell *cell = (BMTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                cell.rowIndex--;
            }
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        BMTableViewSection *section = self.mutableSections[indexPath.section];
        BMTableViewItem *item = section.items[indexPath.row];
        if (item.insertionHandler)
        {
            item.insertionHandler(item);
        }
    }
}

#pragma mark -
#pragma mark Table view delegate

// Display customization

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)])
    {
        [self.delegate tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)])
    {
        [self.delegate tableView:tableView willDisplayFooterView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([cell isKindOfClass:[BMTableViewCell class]])
    {
        [(BMTableViewCell *)cell cellDidDisappear];
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:)])
    {
        [self.delegate tableView:tableView didEndDisplayingHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)])
    {
        [self.delegate tableView:tableView didEndDisplayingFooterView:view forSection:section];
    }
}

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMTableViewSection *section = self.mutableSections[indexPath.section];
    id item = section.items[indexPath.row];
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
    {
        return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    return [[self classForCellAtIndexPath:indexPath] heightWithItem:item tableViewManager:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex)
    {
        return UITableViewAutomaticDimension;
    }
    BMTableViewSection *section = self.mutableSections[sectionIndex];
    
    if (section.headerHeight != BMTableViewSectionHeaderHeightAutomatic)
    {
        if (section.headerHeight == 0.0f)
        {
            return 0.0001f;
        }
        return section.headerHeight;
    }
    
    if (section.headerView)
    {
        return section.headerView.frame.size.height;
    }
    else if (section.headerTitle.length)
    {
        if (!UITableViewStyleGrouped)
        {
            return self.defaultTableViewSectionHeight;
        }
        else
        {
            CGFloat headerHeight = 0;
            CGFloat headerWidth = CGRectGetWidth(CGRectIntegral(tableView.bounds)) - 40.0f; // 40 = 20pt horizontal padding on each side
            
            CGSize headerRect = CGSizeMake(headerWidth, BMTableViewSectionHeaderHeightAutomatic);
            
            CGRect headerFrame = [section.headerTitle boundingRectWithSize:headerRect
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{ NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline] }
                                                                   context:nil];
            
            headerHeight = headerFrame.size.height;
            
            return headerHeight + 20.0f;
        }
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
    {
        return [self.delegate tableView:tableView heightForHeaderInSection:sectionIndex];
    }
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex)
    {
        return UITableViewAutomaticDimension;
    }
    BMTableViewSection *section = self.mutableSections[sectionIndex];
    
    if (section.footerHeight != BMTableViewSectionFooterHeightAutomatic)
    {
        if (section.footerHeight == 0.0f)
        {
            return 0.0001f;
        }
        return section.footerHeight;
    }
    
    if (section.footerView)
    {
        return section.footerView.frame.size.height;
    }
    else if (section.footerTitle.length)
    {
        if (!UITableViewStyleGrouped)
        {
            return self.defaultTableViewSectionHeight;
        }
        else
        {
            CGFloat footerHeight = 0;
            CGFloat footerWidth = CGRectGetWidth(CGRectIntegral(tableView.bounds)) - 40.0f; // 40 = 20pt horizontal padding on each side
            
            CGSize footerRect = CGSizeMake(footerWidth, BMTableViewSectionFooterHeightAutomatic);
            
            CGRect footerFrame = [section.footerTitle boundingRectWithSize:footerRect
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{ NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote] }
                                                                   context:nil];
            
            footerHeight = footerFrame.size.height;
            
            return footerHeight + 10.0f;
        }
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)])
    {
        return [self.delegate tableView:tableView heightForFooterInSection:sectionIndex];
    }
    
    return UITableViewAutomaticDimension;
}

// Estimated height support

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mutableSections.count <= indexPath.section)
    {
        return UITableViewAutomaticDimension;
    }
    BMTableViewSection *section = self.mutableSections[indexPath.section];
    
    id item = section.items[indexPath.row];
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)])
    {
        return [self.delegate tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
    }
    
    CGFloat height = [[self classForCellAtIndexPath:indexPath] heightWithItem:item tableViewManager:self];
    
    return height ? height : UITableViewAutomaticDimension;
}

// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex)
    {
        return nil;
    }
    BMTableViewSection *section = self.mutableSections[sectionIndex];
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
    {
        return [self.delegate tableView:tableView viewForHeaderInSection:sectionIndex];
    }
    
    return section.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex)
    {
        return nil;
    }
    BMTableViewSection *section = self.mutableSections[sectionIndex];
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)])
    {
        return [self.delegate tableView:tableView viewForFooterInSection:sectionIndex];
    }
    
    return section.footerView;
}

// Accessories (disclosures).

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    BMTableViewSection *section = self.mutableSections[indexPath.section];
    id item = section.items[indexPath.row];
    if ([item respondsToSelector:@selector(setAccessoryButtonTapHandler:)])
    {
        BMTableViewItem *actionItem = (BMTableViewItem *)item;
        if (actionItem.accessoryButtonTapHandler)
        {
            actionItem.accessoryButtonTapHandler(item);
        }
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
    {
        [self.delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

// Selection

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)])
    {
        return [self.delegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView didHighlightRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)])
    {
        return [self.delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    }
    
    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)])
    {
        return [self.delegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMTableViewSection *section = self.mutableSections[indexPath.section];
    id item = section.items[indexPath.row];
    if ([item respondsToSelector:@selector(setSelectionHandler:)])
    {
        BMTableViewItem *actionItem = (BMTableViewItem *)item;
        if (actionItem.selectionHandler)
        {
            actionItem.selectionHandler(item);
        }
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
}


// Editing

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMTableViewSection *section = self.mutableSections[indexPath.section];
    BMTableViewItem *item = section.items[indexPath.row];
    
    if (![item isKindOfClass:[BMTableViewItem class]])
    {
        return UITableViewCellEditingStyleNone;
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)])
    {
        return [self.delegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    
    return item.editingStyle;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)])
    {
        return [self.delegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    
    return NSLocalizedString(@"Delete", @"Delete");
}

//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"Edit", @"Edit") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//
//    }];
//    editAction.backgroundColor = [UIColor blueColor];;
//
//
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"Delete", @"Delete")  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//
//    }];
//
//    return @[deleteAction, editAction];
//}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)])
    {
        return [self.delegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    }
    
    return YES;
}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
    }
}

// Moving/reordering

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    BMTableViewSection *sourceSection = self.mutableSections[sourceIndexPath.section];
    BMTableViewItem *item = sourceSection.items[sourceIndexPath.row];
    if (item.moveHandler)
    {
        BOOL allowed = item.moveHandler(item, sourceIndexPath, proposedDestinationIndexPath);
        if (!allowed)
        {
            return sourceIndexPath;
        }
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)])
    {
        return [self.delegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    }
    
    return proposedDestinationIndexPath;
}

// Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)])
    {
        return [self.delegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
    
    return 0;
}

// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMTableViewSection *section = self.mutableSections[indexPath.section];
    id anItem = section.items[indexPath.row];
    if ([anItem respondsToSelector:@selector(setCopyHandler:)])
    {
        BMTableViewItem *item = anItem;
        if (item.copyHandler || item.pasteHandler)
        {
            return YES;
        }
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)])
    {
        return [self.delegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    }
    
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    BMTableViewSection *section = self.mutableSections[indexPath.section];
    id anItem = section.items[indexPath.row];
    if ([anItem respondsToSelector:@selector(setCopyHandler:)])
    {
        BMTableViewItem *item = anItem;
        if (item.copyHandler && action == @selector(copy:))
        {
            return YES;
        }
        
        if (item.pasteHandler && action == @selector(paste:))
        {
            return YES;
        }
        
        if (item.cutHandler && action == @selector(cut:))
        {
            return YES;
        }
    }
    
    // Forward to UITableViewDelegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)])
    {
        return [self.delegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    BMTableViewSection *section = self.mutableSections[indexPath.section];
    BMTableViewItem *item = section.items[indexPath.row];
    
    if ([item isKindOfClass:[BMTableViewItem class]])
    {
        if (action == @selector(copy:))
        {
            if (item.copyHandler)
            {
                item.copyHandler(item);
            }
        }
        
        if (action == @selector(paste:))
        {
            if (item.pasteHandler)
            {
                item.pasteHandler(item);
            }
        }
        
        if (action == @selector(cut:))
        {
            if (item.cutHandler)
            {
                item.cutHandler(item);
            }
        }
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)])
    {
        [self.delegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        [self.delegate scrollViewDidScroll:self.tableView];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidZoom:)])
    {
        [self.delegate scrollViewDidZoom:self.tableView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
    {
        [self.delegate scrollViewWillBeginDragging:self.tableView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
    {
        [self.delegate scrollViewWillEndDragging:self.tableView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
    {
        [self.delegate scrollViewDidEndDragging:self.tableView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
    {
        [self.delegate scrollViewWillBeginDecelerating:self.tableView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
    {
        [self.delegate scrollViewDidEndDecelerating:self.tableView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
    {
        [self.delegate scrollViewDidEndScrollingAnimation:self.tableView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)])
    {
        return [self.delegate viewForZoomingInScrollView:self.tableView];
    }
    
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)])
    {
        [self.delegate scrollViewWillBeginZooming:self.tableView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
    {
        [self.delegate scrollViewDidEndZooming:self.tableView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)])
    {
        return [self.delegate scrollViewShouldScrollToTop:self.tableView];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)])
    {
        [self.delegate scrollViewDidScrollToTop:self.tableView];
    }
}


#pragma mark -
#pragma mark Managing sections

- (void)addSection:(BMTableViewSection *)section
{
    section.tableViewManager = self;
    [self.mutableSections addObject:section];
}

- (void)addSectionsFromArray:(NSArray *)array
{
    for (BMTableViewSection *section in array)
    {
        section.tableViewManager = self;
    }
    [self.mutableSections addObjectsFromArray:array];
}

- (void)insertSection:(BMTableViewSection *)section atIndex:(NSUInteger)index
{
    section.tableViewManager = self;
    [self.mutableSections insertObject:section atIndex:index];
}

- (void)insertSections:(NSArray *)sections atIndexes:(NSIndexSet *)indexes
{
    for (BMTableViewSection *section in sections)
    {
        section.tableViewManager = self;
    }
    [self.mutableSections insertObjects:sections atIndexes:indexes];
}

- (void)removeSection:(BMTableViewSection *)section
{
    [self.mutableSections removeObject:section];
}

- (void)removeSection:(BMTableViewSection *)section inRange:(NSRange)range
{
    [self.mutableSections removeObject:section inRange:range];
}

- (void)removeAllSections
{
    [self.mutableSections removeAllObjects];
}

- (void)removeSectionIdenticalTo:(BMTableViewSection *)section
{
    [self.mutableSections removeObjectIdenticalTo:section];
}

- (void)removeSectionIdenticalTo:(BMTableViewSection *)section inRange:(NSRange)range
{
    [self.mutableSections removeObjectIdenticalTo:section inRange:range];
}

- (void)removeSectionsInArray:(NSArray *)otherArray
{
    [self.mutableSections removeObjectsInArray:otherArray];
}

- (void)removeSectionsInRange:(NSRange)range
{
    [self.mutableSections removeObjectsInRange:range];
}

- (void)removeLastSection
{
    [self.mutableSections removeLastObject];
}

- (void)removeSectionAtIndex:(NSUInteger)index
{
    [self.mutableSections removeObjectAtIndex:index];
}

- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes
{
    [self.mutableSections removeObjectsAtIndexes:indexes];
}

- (void)replaceSectionAtIndex:(NSUInteger)index withSection:(BMTableViewSection *)section
{
    section.tableViewManager = self;
    [self.mutableSections replaceObjectAtIndex:index withObject:section];
}

- (void)replaceSectionsAtIndexes:(NSIndexSet *)indexes withSections:(NSArray *)sections
{
    for (BMTableViewSection *section in sections)
    {
        section.tableViewManager = self;
    }
    [self.mutableSections replaceObjectsAtIndexes:indexes withObjects:sections];
}

- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray *)otherArray
{
    for (BMTableViewSection *section in otherArray)
    {
        section.tableViewManager = self;
    }
    [self.mutableSections replaceObjectsInRange:range withObjectsFromArray:otherArray];
}

- (void)exchangeSectionAtIndex:(NSUInteger)idx1 withSectionAtIndex:(NSUInteger)idx2
{
    [self.mutableSections exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)sortSectionsUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context
{
    [self.mutableSections sortUsingFunction:compare context:context];
}

- (void)sortSectionsUsingSelector:(SEL)comparator
{
    [self.mutableSections sortUsingSelector:comparator];
}


#pragma mark -
#pragma mark KeyBord

- (void)showKeyBordWithVisibleCells
{
    NSArray *cellArray = self.tableView.visibleCells;
    
    for (UITableViewCell *cell in cellArray)
    {
        if ([cell isKindOfClass:[BMTableViewCell class]])
        {
            BMTableViewCell *viewCell = (BMTableViewCell *)cell;
            BMTableViewItem *item = viewCell.item;
            if ([item isKindOfClass:[BMTableViewItem class]])
            {
                Class class = self.registeredClasses[item.class];
                if ([class canFocusWithItem:item])
                {
                    [viewCell.responder becomeFirstResponder];
                    break;
                }
            }
        }
    }
}

- (void)showKeyBordAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    BMTableViewCell *viewCell = (BMTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    BMTableViewItem *item = viewCell.item;
    
    Class class = [self classForCellAtIndexPath:indexPath];
    if ([class canFocusWithItem:item])
    {
        [viewCell.responder becomeFirstResponder];
    }
}

- (NSInteger)indexOfFirstResponder
{
    NSArray *cellArray = self.tableView.visibleCells;
    
    NSInteger index = -1;
    for (UITableViewCell *cell in cellArray)
    {
        index++;
        if ([cell isKindOfClass:[BMTableViewCell class]])
        {
            BMTableViewCell *viewCell = (BMTableViewCell *)cell;
            BMTableViewItem *item = viewCell.item;
            if ([item isKindOfClass:[BMTableViewItem class]])
            {
                Class class = self.registeredClasses[item.class];
                if ([class canFocusWithItem:item])
                {
                    if ([viewCell.responder isFirstResponder])
                    {
                        return index;
                    }
                }
            }
        }
    }
    
    return NSNotFound;
}

@end
