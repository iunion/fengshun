//
//  FSMyCollectionCell.h
//  fengshun
//
//  Created by jiang deng on 2018/9/26.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSMyCollectionModel.h"

@interface FSMyCollectionCell : UITableViewCell

@property (nonatomic, strong, readonly) FSMyCollectionModel *m_Model;

- (void)drawCellWithModel:(FSMyCollectionModel *)model;

+ (CGFloat)cellHeight;

@end
