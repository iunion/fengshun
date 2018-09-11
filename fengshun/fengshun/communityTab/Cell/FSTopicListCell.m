//
//  FSCommunityListTableViewCell.m
//  fengshun
//
//  Created by best2wa on 2018/8/31.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSTopicListCell.h"
#import "UIButton+BMContentRect.h"
#import "UIImageView+WebCache.h"
#import "NSDate+BMCategory.h"

@implementation FSTopicListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    [_m_CategoryView bm_roundedRect:_m_CategoryView.bm_height / 2];
    [_m_HeaderImgView bm_roundedRect:_m_HeaderImgView.bm_height / 2];
    [_m_StickView bm_roundedRect:_m_StickView.bm_height / 2];
    [_m_CommentBtn bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showWithTopicModel:(FSCommunityTopicListModel *)aModel
{
    //    [_m_HeaderImgView sd_setImageWithURL:[aModel.m_IconUrl bm_toURL] placeholderImage:[UIImage imageNamed:@""]];
    [_m_HeaderImgView sd_setImageWithURL:[aModel.m_IconUrl bm_toURL]];
    _m_CategoryLab.text = aModel.m_ForumName;
    _m_TitleLab.text    = aModel.m_PostsTitle;
    _m_TimeLab.text     = [NSDate hmStringDateFromTs:aModel.m_PostsLastReplyTime];
    _m_UserNameLab.text = aModel.m_NickName;
    [_m_CommentBtn setTitle:[NSString stringWithFormat:@"%ld", (long)aModel.m_CommentCount] forState:UIControlStateNormal];
    _m_StickView.hidden = !aModel.m_TopFlag;
}

@end
