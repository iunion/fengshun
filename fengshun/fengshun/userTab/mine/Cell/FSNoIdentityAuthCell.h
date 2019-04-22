//
//  FSNoIdentityAuthCell.h
//  fengshun
//
//  Created by 龚旭杰 on 2019/4/22.
//  Copyright © 2019年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSNoIdentityAuthModel.h"



NS_ASSUME_NONNULL_BEGIN


@interface FSNoIdentityAuthCell : UITableViewCell

- (void)showWithModel:(FSNoIdentityAuthModel *)model;

@end

NS_ASSUME_NONNULL_END
