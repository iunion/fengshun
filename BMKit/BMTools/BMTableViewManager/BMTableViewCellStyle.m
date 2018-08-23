//
//  BMTableViewCellStyle.m
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2017/4/20.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "BMTableViewCellStyle.h"

// 默认高度
#define Default_Cell_Height     TABLE_CELL_HEIGHT

@implementation BMTableViewCellStyle

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.backgroundImages = [[NSMutableDictionary alloc] init];
        self.selectedBackgroundImages = [[NSMutableDictionary alloc] init];
        self.cellHeight = Default_Cell_Height;
        self.defaultCellSelectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    BMTableViewCellStyle *style = [[self class] allocWithZone:zone];
    if (style)
    {
        style.backgroundImages = [NSMutableDictionary dictionaryWithDictionary:[self.backgroundImages copyWithZone:zone]];
        style.selectedBackgroundImages = [NSMutableDictionary dictionaryWithDictionary:[self.selectedBackgroundImages copyWithZone:zone]];
        style.cellHeight = self.cellHeight;
        style.defaultCellSelectionStyle = self.defaultCellSelectionStyle;
        style.backgroundImageMargin = self.backgroundImageMargin;
        style.contentViewMargin = self.contentViewMargin;
    }
    return style;
}

- (BOOL)hasCustomBackgroundImage
{
    return [self backgroundImageForCellPositionType:BMTableViewCell_PositionType_None] || [self backgroundImageForCellPositionType:BMTableViewCell_PositionType_First] || [self backgroundImageForCellPositionType:BMTableViewCell_PositionType_Middle] || [self backgroundImageForCellPositionType:BMTableViewCell_PositionType_Last] || [self backgroundImageForCellPositionType:BMTableViewCell_PositionType_Single];
}

- (UIImage *)backgroundImageForCellPositionType:(BMTableViewCell_PositionType)cellPositionType
{
    UIImage *image = self.backgroundImages[@(cellPositionType)];
    if (!image && cellPositionType != BMTableViewCell_PositionType_None)
    {
        image = self.backgroundImages[@(BMTableViewCell_PositionType_None)];
    }
    return image;
}

- (void)setBackgroundImage:(UIImage *)image forCellPositionType:(BMTableViewCell_PositionType)cellPositionType
{
    if (image)
    {
        [self.backgroundImages setObject:image forKey:@(cellPositionType)];
    }
    else
    {
        [self.backgroundImages removeObjectForKey:@(cellPositionType)];
    }
}

- (BOOL)hasCustomSelectedBackgroundImage
{
    return [self selectedBackgroundImageForCellPositionType:BMTableViewCell_PositionType_None] || [self selectedBackgroundImageForCellPositionType:BMTableViewCell_PositionType_First] || [self selectedBackgroundImageForCellPositionType:BMTableViewCell_PositionType_Middle] || [self selectedBackgroundImageForCellPositionType:BMTableViewCell_PositionType_Last] || [self selectedBackgroundImageForCellPositionType:BMTableViewCell_PositionType_Single];
}

- (UIImage *)selectedBackgroundImageForCellPositionType:(BMTableViewCell_PositionType)cellPositionType
{
    UIImage *image = self.selectedBackgroundImages[@(cellPositionType)];
    if (!image && cellPositionType != BMTableViewCell_PositionType_None)
    {
        image = self.selectedBackgroundImages[@(BMTableViewCell_PositionType_None)];
    }
    return image;
}

- (void)setSelectedBackgroundImage:(UIImage *)image forCellPositionType:(BMTableViewCell_PositionType)cellPositionType
{
    if (image)
    {
        [self.selectedBackgroundImages setObject:image forKey:@(cellPositionType)];
    }
    else
    {
        [self.selectedBackgroundImages removeObjectForKey:@(cellPositionType)];
    }
}

@end
