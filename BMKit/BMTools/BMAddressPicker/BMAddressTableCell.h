//
//  BMAddressTableCell.h
//  fengshun
//
//  Created by jiang deng on 2019/4/3.
//  Copyright © 2019 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BMAddressModel;

@interface BMAddressTableCell : UITableViewCell

@property (nonatomic, strong, readonly) BMAddressModel *addressModel;

- (void)drawCellWithModel:(BMAddressModel *)model;

@end

NS_ASSUME_NONNULL_END
