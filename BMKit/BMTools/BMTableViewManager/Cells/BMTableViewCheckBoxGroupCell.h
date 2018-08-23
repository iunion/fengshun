//
//  BMTableViewCheckBoxGroupCell.h
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2018/2/8.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "BMTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class BMCheckBoxGroup;

@interface BMTableViewCheckBoxGroupCell : BMTableViewCell

@property (nonatomic, strong, readonly) BMCheckBoxGroup *checkBoxGroup;

@end

NS_ASSUME_NONNULL_END

