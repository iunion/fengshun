//
//  FSCommunityHeaderView.m
//  fengshun
//
//  Created by best2wa on 2018/9/3.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCommunityHeaderView.h"
#import "UIView+BMPositioning.h"

@implementation FSCommunityHeaderView

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
    [_m_UserHeaderImgView bm_roundedRect:4];
    [_m_AttentionBtn bm_roundedRect:_m_AttentionBtn.bm_height/2];
}

- (void)updateHeaderViewWith:(FSCommunityDetailInfoModel *)aModel
{
    [_m_HeaderBGView sd_setImageWithURL:[aModel.m_IconUrlFirst bm_toURL]];
    [_m_UserHeaderImgView sd_setImageWithURL:[aModel.m_IconUrlSecond bm_toURL]];
    _m_CategoryTitleLab.text        = aModel.m_ForumNameSecond;
    _m_TitleLab.text                = aModel.m_Description;
    _m_AttentionNumLab.text         = [NSString stringWithFormat:@"%ld 关注", aModel.m_AttentionCount];
    _m_PostNumLab.text              = [NSString stringWithFormat:@"%ld 帖子", aModel.m_PostsCount];
    _m_AttentionBtn.selected        = !aModel.m_AttentionFlag;
    _m_AttentionBtn.backgroundColor = [UIColor bm_colorWithHexString:aModel.m_AttentionFlag ? @"F5F6F7" : @"4E7CF6"];
    [_m_AttentionBtn setTitleColor:[UIColor bm_colorWithHexString:aModel.m_AttentionFlag ? @"999999" : @"ffffff"] forState:UIControlStateNormal];
    [_m_AttentionBtn setTitle:aModel.m_AttentionFlag ? @"已关注" : @"+ 关注" forState:UIControlStateNormal];
}

- (IBAction)popBackAction:(UIButton *)sender {
    [[self bm_firstViewController].navigationController popViewControllerAnimated:YES];
}

@end
