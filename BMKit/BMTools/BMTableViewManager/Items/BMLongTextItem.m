//
//  BMLongTextItem.m
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2018/4/20.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "BMLongTextItem.h"

@implementation BMLongTextItem

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder
{
    self = [super initWithTitle:title value:value placeholder:placeholder];
    
    if (self)
    {
        self.textViewTextContainerInset = UIEdgeInsetsZero;
        self.textViewPlaceholderLineBreakMode = NSLineBreakByTruncatingTail;
        self.textViewTextAlignment = NSTextAlignmentLeft;
        self.textViewSelectable = YES;
        
        self.textLabelTopGap = 8.0f;
        self.textViewTopGap = 8.0f;
        self.textViewLeftGap = 4.0f;
        
        self.showTextViewBorder = YES;
    }
    
    return self;
}

- (void)caleCellHeightWithTableView:(UITableView *)tableView
{
    CGFloat height = self.textLabelTopGap;
    
    CGFloat titleWidth = UI_SCREEN_WIDTH-(tableView.contentInset.left+tableView.contentInset.right)-30.0f;
    
    CGFloat titleHeight;
    if (self.titleAttrStr)
    {
        CGSize maxSize = CGSizeMake(titleWidth, CGFLOAT_MAX);
        titleHeight = ceil([self.titleAttrStr bm_sizeToFit:maxSize lineBreakMode:NSLineBreakByCharWrapping].height);
    }
    else
    {
        titleHeight = ceil([self.title bm_heightToFitWidth:titleWidth withFont:self.textFont]);
    }
    
    height += titleHeight;
    
    height += self.textViewTopGap;
    
    CGFloat itemWidth = titleWidth-self.textViewLeftGap*2.0f-16.0f;
    CGFloat itemHeight;
    if (self.attributedValue)
    {
        CGSize maxSize = CGSizeMake(itemWidth, CGFLOAT_MAX);
        itemHeight = ceil([self.attributedValue bm_sizeToFit:maxSize lineBreakMode:NSLineBreakByCharWrapping].height);
    }
    else
    {
        itemHeight = ceil([self.value bm_heightToFitWidth:itemWidth withFont:self.textViewFont]);
    }
    
    height += itemHeight;

    height += self.textLabelTopGap + 16.0f;

    self.cellHeight = height;
}

@end
