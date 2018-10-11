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

@property (nonatomic, strong)FSForumModel *m_ForumModel;

// 关注状态变化
@property (nonatomic, copy)void (^attentionBtnClickBlock)(FSForumModel *);

- (void)showWithFSCommunityForumListModel:(FSForumModel *)aModel;

@end
