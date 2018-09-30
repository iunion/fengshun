//
//  FSMyTopicCell.h
//  fengshun
//
//  Created by jiang deng on 2018/9/26.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSMyCollectionModel.h"

@interface FSMyTopicCell : UITableViewCell

@property (nonatomic, strong, readonly) FSMyTopicModel *m_Model;

+ (CGFloat)cellHeightWithDescription:(NSString *)description;

- (void)drawCellWithModel:(FSMyTopicModel *)model;

@end
