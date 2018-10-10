//
//  FSMyCourseCollectionCell.h
//  fengshun
//
//  Created by jiang deng on 2018/10/10.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSMyCollectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSMyCourseCollectionCell : UITableViewCell

@property (nonatomic, strong, readonly) FSMyCollectionModel *m_Model;

- (void)drawCellWithModel:(FSMyCollectionModel *)model;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
