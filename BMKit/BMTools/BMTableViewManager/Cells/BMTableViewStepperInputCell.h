//
//  BMTableViewStepperInputCell.h
//  BMTableViewManagerSample
//
//  Created by jiang deng on 2018/8/16.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import "BMTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class BMStepperInputView;

@interface BMTableViewStepperInputCell : BMTableViewCell

@property (nonatomic, strong, readonly) BMStepperInputView *stepperInputView;

@end

NS_ASSUME_NONNULL_END
