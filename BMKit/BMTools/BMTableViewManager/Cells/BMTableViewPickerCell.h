//
//  BMTableViewPickerCell.h
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2018/1/15.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "BMTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMTableViewPickerCell : BMTableViewCell

@property (nonatomic, strong, readonly) UITextField *hidenTextField;

@property (nonatomic, strong, readonly) UILabel *pickerTextLabel;
@property (nonatomic, strong, readonly) UILabel *placeholderLabel;

@property (nonatomic, strong, readonly) UIPickerView *pickerView;

@end

NS_ASSUME_NONNULL_END

