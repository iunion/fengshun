//
//  BMTableViewTextCell.h
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2017/8/22.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "BMTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMInsetTextField : UITextField

@property (nonatomic, assign) UIEdgeInsets separatorInset;

- (instancetype)initWithFrame:(CGRect)frame separatorInset:(UIEdgeInsets)separatorInset;

@end

@interface BMTableViewTextCell : BMTableViewCell
<
    UITextFieldDelegate,
    RETextCellProtocol
>

@property (nonatomic, strong, readonly) BMInsetTextField *textField;

@end

NS_ASSUME_NONNULL_END

