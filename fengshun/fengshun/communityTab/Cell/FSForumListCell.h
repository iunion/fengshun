//
//  FSPlateListTableViewCell.h
//  fengshun
//
//  Created by best2wa on 2018/8/31.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCommunityModel.h"

@interface FSForumListCell : UITableViewCell

+ (CGFloat)cellHeight;

- (void)showWithFSCommunityForumListModel:(FSForumModel *)aModel;

@end
