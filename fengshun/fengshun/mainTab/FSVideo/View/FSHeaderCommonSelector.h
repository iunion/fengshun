//
//  FSHeaderCommonSelector.h
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSHeaderCommonSelectorModel;

typedef void (^FSHeaderCommonSelectorBlock)(NSInteger index, NSString *selectedItem);

@interface FSHeaderCommonSelectorView : UIView
@property (nonatomic, strong) NSArray<FSHeaderCommonSelectorModel *> *m_SelectorArray;
@property (nonatomic, copy) FSHeaderCommonSelectorBlock selectorBlock;
- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)dataArray;
@end



@interface FSHeaderCommonSelectorModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray<NSString *> *list;
+ (instancetype)modelWithTitle:(NSString *)title list:(NSArray *)list;
- (instancetype)initWithTitle:(NSString *)title list:(NSArray *)list;
@end
