//
//  BMTableViewCombineCell.m
//  DJTableViewManagerSample
//
//  Created by jiang deng on 2018/5/26.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import "BMTableViewCombineCell.h"
#import "BMTableViewManager.h"
#import "BMCombineItem.h"


@interface BMTableViewCombineCell ()

@property (nonatomic, assign) BOOL enabled;

@property (nonatomic, strong) BMCombineItem *item;
@property (nonatomic, strong) NSMutableArray<UIButton *> *itemArray;

@property (nonatomic, strong) BMImageTextView *imageTextView;

@end

@implementation BMTableViewCombineCell
@synthesize item = _item;

- (void)dealloc
{
    if (_item != nil)
    {
        [_item removeObserver:self forKeyPath:@"enabled"];
    }
}

- (void)cellDidLoad
{
    [super cellDidLoad];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.itemArray = [NSMutableArray arrayWithCapacity:0];

    self.imageTextView = [[BMImageTextView alloc] initWithImage:@"BMCombine_down" text:@"" type:BMImageTextViewType_ImageRight textColor:[UIColor grayColor] textFont:[UIFont systemFontOfSize:14.0f] height:20.0f gap:4.0f clicked:nil];
    
    [self.contentView addSubview:self.imageTextView];
    
    CGFloat margin = (self.section.style.contentViewMargin <= 0) ? 15.0f : 10.0f;
    CGFloat width = 30.0f;//self.imageTextView.width;
    self.imageTextView.bm_left = self.contentView.bm_width-width-margin;
    self.imageTextView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
}



- (void)cellWillAppear
{
    [super cellWillAppear];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    
    __typeof (&*self) __weak weakSelf = self;
    self.imageTextView.imageTextViewClicked = ^(BMImageTextView *imageTextView) {
        
        weakSelf.item.isShowAllItem = !weakSelf.item.isShowAllItem;
        if (weakSelf.item.isShowAllItem)
        {
            weakSelf.imageTextView.imageName = @"BMCombine_up";
        }
        else
        {
            weakSelf.imageTextView.imageName = @"BMCombine_down";
        }

        if (weakSelf.item.showAllHandler)
        {
            weakSelf.item.showAllHandler(weakSelf.item);
        }
    };

    if (self.item.isShowAllItem)
    {
        self.imageTextView.imageName = @"BMCombine_up";
    }
    else
    {
        self.imageTextView.imageName = @"BMCombine_down";
    }

    self.enabled = self.item.enabled;
}

- (void)cellLayoutSubviews
{
    [super cellLayoutSubviews];

    self.textLabel.bm_left = BMCombine_TitleLeft;
    self.textLabel.bm_top = BMCombine_TitleTop;
    self.textLabel.bm_width = self.item.titleWidth;
    self.textLabel.bm_height = self.item.titleHeight;
    self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.imageTextView.bm_top = BMCombine_TitleTop;
    
    CGFloat x = self.textLabel.bm_left + BMCombine_LeftGap;
    CGFloat y = self.textLabel.bm_bottom + BMCombine_TopGap;
    for (NSUInteger index = 0; index < self.itemArray.count; index++)
    {
        x = self.textLabel.bm_left + BMCombine_LeftGap +(self.item.itemWidth+BMCombine_ItemHGap)*(index%BMCombine_CountPerLine);
        y = self.textLabel.bm_bottom + BMCombine_TopGap +((NSUInteger)(index/BMCombine_CountPerLine))*(BMCombine_ItemHeight+BMCombine_LineGap);
        CGRect frame = CGRectMake(x, y, self.item.itemWidth, BMCombine_ItemHeight);
        UIButton *btn = self.itemArray[index];
        btn.frame = frame;
        if (self.item.isShowAllItem)
        {
            btn.hidden = NO;
        }
        else
        {
            btn.hidden = YES;
        }
    }
}

- (void)setItem:(BMCombineItem *)item
{
    if (_item != nil)
    {
        [_item removeObserver:self forKeyPath:@"enabled"];
    }
    
    _item = item;
    
    for (UIButton *btn in self.itemArray)
    {
        [btn removeFromSuperview];
    }
    
    [self.itemArray removeAllObjects];
    
    for (NSUInteger index = 0; index<_item.itemArray.count; index++)
    {
        NSString *itemString = _item.itemArray[index];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [button setTitle:itemString forState:UIControlStateNormal];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        button.exclusiveTouch = YES;
        if ([self checkSelectedWithIndex:index] != NSNotFound)
        {
            [button setTitleColor:[UIColor bm_colorWithHex:0x577EEE] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor bm_colorWithHex:0xDDE6FF];
        }
        else
        {
            [button setTitleColor:[UIColor bm_colorWithHex:0x333333] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor bm_colorWithHex:0xF4F4F4];
        }
        //[button bm_roundedRect:6.0f borderWidth:1.0f borderColor:[UIColor bm_colorWithHex:0xD6DBDF]];
        [button bm_roundedRect:4.0f];
        [button addTarget:self action:@selector(seletedItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.itemArray addObject:button];
        [self.contentView addSubview:button];
    }
    
    [_item addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:NULL];
}

- (NSInteger)checkSelectedWithIndex:(NSUInteger)index
{
    for (NSInteger i = 0; i<self.item.selectedIndexArray.count; i++)
    {
        NSNumber *indexNum = self.item.selectedIndexArray[i];
        if (indexNum.unsignedIntegerValue == index)
        {
            return i;
        }
    }
    
    return NSNotFound;
}

- (void)changeSelectedWithIndex:(NSUInteger)index
{
    if (self.item.isMutableSelect)
    {
        NSInteger selectedIndex = [self checkSelectedWithIndex:index];
        if (selectedIndex == NSNotFound)
        {
            [self.item.selectedIndexArray addObject:@(index)];
        }
        else
        {
            [self.item.selectedIndexArray removeObjectAtIndex:selectedIndex];
        }
    }
    else
    {
        [self.item.selectedIndexArray removeAllObjects];
        [self.item.selectedIndexArray addObject:@(index)];
    }
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    self.userInteractionEnabled = _enabled;
    
    self.textLabel.enabled = _enabled;
    for (UIButton *btn in self.itemArray)
    {
        btn.enabled = _enabled;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[BMCombineItem class]] && [keyPath isEqualToString:@"enabled"])
    {
        BOOL newValue = [[change objectForKey: NSKeyValueChangeNewKey] boolValue];
        
        self.enabled = newValue;
    }
}

- (void)seletedItem:(UIButton *)btn
{
    NSInteger seletecIndex = [self.itemArray indexOfObject:btn];
    
    if (seletecIndex != NSNotFound)
    {
        NSUInteger selectedIndex = [self.itemArray indexOfObject:btn];
        
        [self changeSelectedWithIndex:selectedIndex];
        
        for (NSUInteger index = 0; index<self.itemArray.count; index++)
        {
            UIButton *button = self.itemArray[index];
            if ([self checkSelectedWithIndex:index] != NSNotFound)
            {
                [button setTitleColor:[UIColor bm_colorWithHex:0x577EEE] forState:UIControlStateNormal];
                button.backgroundColor = [UIColor bm_colorWithHex:0xDDE6FF];
            }
            else
            {
                [button setTitleColor:[UIColor bm_colorWithHex:0x333333] forState:UIControlStateNormal];
                button.backgroundColor = [UIColor bm_colorWithHex:0xF4F4F4];
            }
        }
    }
    
    if (self.item.selectedHandler)
    {
        self.item.selectedHandler(self.item);
    }
}

@end
