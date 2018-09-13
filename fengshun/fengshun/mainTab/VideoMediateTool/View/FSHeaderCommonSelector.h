//
//  FSHeaderCommonSelector.h
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSHeaderCommonSelectorModel;
@class FSSelectorListModel;

typedef void (^FSHeaderCommonSelectorBlock)(FSHeaderCommonSelectorModel *hModel, FSSelectorListModel *lmodel);


@interface FSHeaderCommonSelectorView : UIView
@property (nonatomic, copy) FSHeaderCommonSelectorBlock selectorBlock;
@property (nonatomic, strong) NSArray<FSHeaderCommonSelectorModel *> *m_DataArray;
- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)dataArray;
@end


@interface FSHeaderCommonSelectorModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *hiddenkey;  // 隐形key
@property (nonatomic, strong) NSArray<FSSelectorListModel *> *list;

+ (instancetype)modelWithTitle:(NSString *)title hiddenkey:(NSString *)key list:(NSArray *)array;
- (instancetype)initWithTitle:(NSString *)title hiddenkey:(NSString *)key list:(NSArray *)array;

@end


@interface FSSelectorListModel : NSObject
@property (nonatomic, strong) NSString *showName;   // 表现出来的名称
@property (nonatomic, strong) NSString *hiddenkey;  // 隐形key

+ (instancetype)modelWithName:(NSString *)name key:(NSString *)key;
- (instancetype)initWithName:(NSString *)name key:(NSString *)key;

@end

