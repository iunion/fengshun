//
//  BMCheckBoxGroup.m
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2018/2/8.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "BMCheckBoxGroup.h"
#import "BMCheckBox.h"

//@interface BMCheckBox ()
//
//@property (nonatomic, weak) BMCheckBoxGroup *group;
//
//@end

@interface BMCheckBoxGroup ()

@property (nonatomic, strong) NSMutableArray<BMCheckBox *> *checkBoxes;
@property (nonatomic, strong) NSMutableArray<BMCheckBox *> *selectedCheckBoxes;

@end

@implementation BMCheckBoxGroup

+ (instancetype)groupWithCheckBoxes:(NSArray<BMCheckBox *> *)checkBoxes maxSelectedCount:(NSUInteger)maxSelectedCount
{
    BMCheckBoxGroup *checkBoxGroup = [[BMCheckBoxGroup alloc] initWithCheckBoxes:checkBoxes maxSelectedCount:maxSelectedCount];
    
    return checkBoxGroup;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.maxSelectedCount = 1;
        self.checkBoxes = [NSMutableArray array];
        self.selectedCheckBoxes = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithCheckBoxes:(NSArray<BMCheckBox *> *)checkBoxes maxSelectedCount:(NSUInteger)maxSelectedCount
{
    self = [self init];
    if (self)
    {
        self.maxSelectedCount = maxSelectedCount;
        
        for (BMCheckBox *checkBox in checkBoxes)
        {
            [self addCheckBoxToGroup:checkBox];
        }
    }
    return self;
}

- (void)setMaxSelectedCount:(NSUInteger)maxSelectedCount
{
    if (maxSelectedCount < 1)
    {
        maxSelectedCount = 1;
    }

    if (_maxSelectedCount != maxSelectedCount)
    {
        _maxSelectedCount = maxSelectedCount;
    }
}


- (void)addCheckBoxToGroup:(BMCheckBox *)checkBox
{
    if (checkBox.group)
    {
        [checkBox.group removeCheckBoxFromGroup:checkBox];
    }

    [self.checkBoxes addObject:checkBox];
    [checkBox setCheckBoxGroup:self];
    if (checkBox.checkState == BMCheckBoxState_Checked)
    {
        if (self.selectedCheckBoxes.count < self.maxSelectedCount)
        {
            [self.selectedCheckBoxes addObject:checkBox];
        }
    }
    else
    {
        checkBox.checkState = BMCheckBoxState_UnChecked;
    }
}

- (void)removeCheckBoxFromGroup:(BMCheckBox *)checkBox
{
    if (![self.checkBoxes containsObject:checkBox])
    {
        return;
    }
    [checkBox setCheckBoxGroup:nil];
    [self.checkBoxes removeObject:checkBox];
    
    if (![self.selectedCheckBoxes containsObject:checkBox])
    {
        return;
    }
    [self.selectedCheckBoxes removeObject:checkBox];
}

- (void)groupSelectionChangedWithCheckBox:(BMCheckBox *)checkBox
{
    if (checkBox.checkState != BMCheckBoxState_Checked)
    {
        if (![self.selectedCheckBoxes containsObject:checkBox])
        {
            return;
        }
        [self.selectedCheckBoxes removeObject:checkBox];
        
        return;
    }
    
    if ([self.selectedCheckBoxes containsObject:checkBox])
    {
        return;
    }
    
    if (self.maxSelectedCount == 1)
    {
        BMCheckBox *oldCheckBox = [self.selectedCheckBoxes firstObject];
        oldCheckBox.checkState = BMCheckBoxState_UnChecked;
        
        [self.selectedCheckBoxes removeAllObjects];
        [self.selectedCheckBoxes addObject:checkBox];
    }
    else
    {
        if (self.selectedCheckBoxes.count < self.maxSelectedCount)
        {
            [self.selectedCheckBoxes addObject:checkBox];
        }
        else
        {
            checkBox.checkState = BMCheckBoxState_UnChecked;
        }
    }
}

@end
