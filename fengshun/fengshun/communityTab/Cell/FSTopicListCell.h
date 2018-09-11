//
//  FSCommunityListTableViewCell.h
//  fengshun
//
//  Created by best2wa on 2018/8/31.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCommunityModel.h"

@interface FSTopicListCell : UITableViewCell

@property (nonatomic, strong, readonly) FSTopicModel *m_TopicModel;

/**
 展示model
 
 @param model FSCommunityTopicListModel
 */
- (void)drawCellWithModle:(FSTopicModel *)model;

@end
