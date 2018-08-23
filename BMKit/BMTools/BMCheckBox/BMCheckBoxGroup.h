//
//  BMCheckBoxGroup.h
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2018/2/8.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BMCheckBox;

@interface BMCheckBoxGroup : NSObject

@property (nullable, nonatomic, strong, readonly) NSMutableArray<BMCheckBox *> *checkBoxes;

@property (nonatomic, assign) NSUInteger maxSelectedCount;
@property (nullable, nonatomic, strong, readonly) NSMutableArray<BMCheckBox *> *selectedCheckBoxes;

+ (instancetype)groupWithCheckBoxes:(nullable NSArray<BMCheckBox *> *)checkBoxes maxSelectedCount:(NSUInteger)maxSelectedCount;
- (instancetype)initWithCheckBoxes:(nullable NSArray<BMCheckBox *> *)checkBoxes maxSelectedCount:(NSUInteger)maxSelectedCount;

- (void)addCheckBoxToGroup:(nonnull BMCheckBox *)checkBox;
- (void)removeCheckBoxFromGroup:(nonnull BMCheckBox *)checkBox;

- (void)groupSelectionChangedWithCheckBox:(nonnull BMCheckBox *)checkBox;

@end

NS_ASSUME_NONNULL_END
