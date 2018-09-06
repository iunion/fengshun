//
//  FSForumSectionHeaderView.h
//  fengshun
//
//  Created by best2wa on 2018/9/6.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCommunityModel.h"

@interface FSForumSectionHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIImageView *m_IconImgView;
@property (weak, nonatomic) IBOutlet UILabel *m_SectionTitleLab;

- (void)showWithFSCommunityForumModel:(FSCommunityForumModel *)aModel;
@end
