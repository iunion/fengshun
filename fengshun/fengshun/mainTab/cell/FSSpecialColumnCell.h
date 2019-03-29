//
//  FSSpecialColumnCell.h
//  fengshun
//
//  Created by 龚旭杰 on 2019/3/29.
//  Copyright © 2019年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 专题cell  有/无image
 */
@interface FSSpecialColumnCell : UITableViewCell


+ (CGFloat)cellHeight;

/**
 绘制cell

 @param isHasImg 是否包含封面图片
 */
- (void)drawCellWithIsHasImg:(BOOL)isHasImg;

@end

NS_ASSUME_NONNULL_END
