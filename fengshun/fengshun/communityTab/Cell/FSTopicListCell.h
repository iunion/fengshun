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

/**
 展示model

 @param aModel FSCommunityTopicListModel
 */
- (void)showWithTopicModel:(FSTopicModel *)aModel;

- (void)drawCellWithModle:(FSTopicModel *)model;

@end
