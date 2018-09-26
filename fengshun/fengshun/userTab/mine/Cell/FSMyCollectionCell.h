//
//  FSMyCollectionCell.h
//  fengshun
//
//  Created by jiang deng on 2018/9/26.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCollectionModel.h"

@interface FSMyCollectionCell : UITableViewCell

@property (nonatomic, strong, readonly) FSCollectionModel *m_Model;

- (void)showWithCollectionModel:(FSCollectionModel *)model;

+ (CGFloat)cellHeight;

@end
