//
//  FSForumSectionHeaderView.m
//  fengshun
//
//  Created by best2wa on 2018/9/6.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSForumSectionHeaderView.h"
#import "UIImageView+WebCache.h"

@implementation FSForumSectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)showWithFSCommunityForumModel:(FSCommunityForumModel *)aModel
{
    if ([aModel.m_IconUrl bm_isNotEmpty]) {
        [self.m_IconImgView sd_setImageWithURL:[aModel.m_IconUrl bm_toURL]];
    }else{
        if ([aModel.m_List bm_isNotEmpty]) {
            FSForumModel *model = aModel.m_List[0];
            [self.m_IconImgView sd_setImageWithURL:[model.m_IconUrlFirst bm_toURL]];
        }
    }
    self.m_SectionTitleLab.text = aModel.m_Name;
}

@end
