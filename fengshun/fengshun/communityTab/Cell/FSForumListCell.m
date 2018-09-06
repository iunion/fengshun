//
//  FSPlateListTableViewCell.m
//  fengshun
//
//  Created by best2wa on 2018/8/31.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSForumListCell.h"
#import "UIImageView+WebCache.h"

@implementation FSForumListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    [_m_ImgView bm_roundedRect:4];
    [_m_DoBtn bm_roundedRect:_m_DoBtn.bm_height / 2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showWithFSCommunityForumListModel:(FSCommunityForumListModel *)aModel
{
    //    [_m_ImgView sd_setImageWithURL:[aModel.m_IconUrl bm_toURL] placeholderImage:[UIImage imageNamed:@""]];
    [_m_ImgView sd_setImageWithURL:[aModel.m_IconUrl bm_toURL]];
    _m_TitleLab.text        = aModel.m_ForumNameSecond;
    _m_ContentLab.text      = aModel.m_Description;
    _m_AttentionNumLab.text = [NSString stringWithFormat:@"%ld", aModel.m_AttentionCount];
    _m_NoteNumLab.text      = [NSString stringWithFormat:@"%ld", aModel.m_PostsCount];
    _m_DoBtn.selected       = aModel.m_AttentionFlag;
    _m_DoBtn.enabled        = !aModel.m_AttentionFlag;
    _m_DoBtn.backgroundColor = [UIColor bm_colorWithHexString:aModel.m_AttentionFlag?@"F5F6F7":@"4E7CF6"];
    [_m_DoBtn setTitleColor:[UIColor bm_colorWithHexString:aModel.m_AttentionFlag?@"999999":@"ffffff"] forState:UIControlStateNormal];
    [_m_DoBtn setTitle:aModel.m_AttentionFlag?@"已关注":@"+ 关注" forState:UIControlStateNormal];
}


@end
