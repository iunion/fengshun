//
//  FSCharacterCell.h
//  fengshun
//
//  Created by 龚旭杰 on 2019/4/1.
//  Copyright © 2019年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSColumModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 专栏人物cell
 */
@interface FSCharacterCell : UITableViewCell

+ (CGFloat )cellHeight;

- (void)showWithModel:(FSColumModel *)model;

@end

NS_ASSUME_NONNULL_END
