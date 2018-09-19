//
//  FSHeaderCommonSelector.h
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVideoMediateModel.h"

typedef void (^FSHeaderCommonSelectorBlock)(FSHeaderCommonSelectorModel *hModel, FSSelectorListModel *lmodel);


@interface FSHeaderCommonSelectorView : UIView
@property (nonatomic, copy) FSHeaderCommonSelectorBlock selectorBlock;
@property (nonatomic, strong) NSArray<FSHeaderCommonSelectorModel *> *m_DataArray;
- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)dataArray;
@end

