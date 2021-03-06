//
//  FSPlateDetailListTableViewCell.h
//  fengshun
//
//  Created by best2wa on 2018/9/3.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCommunityModel.h"

@interface FSForumDetailListCell : UITableViewCell

+ (CGFloat)cellHeight;

- (void)showWithTopicModel:(FSTopicModel *)model;
- (void)hiddenTopTag:(BOOL)hidden;
@end
