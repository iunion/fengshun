//
//  FSCommunityHeaderView.m
//  fengshun
//
//  Created by best2wa on 2018/9/3.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCommunityHeaderView.h"
#import "UIView+BMPositioning.h"
#import "UIImage+BMCategory.h"

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
    [self makeCellStyle];
}

- (void)makeCellStyle
{
    [_m_UserHeaderImgView bm_roundedRect:4];
    _m_HeaderBGView.contentMode = UIViewContentModeScaleAspectFill;
    
    [_m_AttentionBtn bm_roundedRect:_m_AttentionBtn.bm_height * 0.5];
    self.m_AttentionBtn.userInteractionEnabled = YES;
    [self.m_AttentionBtn addTarget:self action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)followAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(followForumAction:)])
    {
        [self.delegate followForumAction:self];
    }
}

- (void)updateHeaderViewWith:(FSForumModel *)aModel
{
    //https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=738208534,2753903060&fm=27&gp=0.jpg
    [_m_HeaderBGView sd_setImageWithURL:[aModel.m_BackUrl bm_toURL] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageLowPriority | SDWebImageRetryFailed];
    [_m_UserHeaderImgView sd_setImageWithURL:[aModel.m_IconUrl bm_toURL] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageLowPriority | SDWebImageRetryFailed];
    _m_CategoryTitleLab.text        = aModel.m_ForumNameSecond;
    _m_TitleLab.text                = aModel.m_Description;
    _m_AttentionNumLab.text         = [NSString stringWithFormat:@"%@ 关注", @(aModel.m_AttentionCount)];
    _m_PostNumLab.text              = [NSString stringWithFormat:@"%@ 帖子", @(aModel.m_PostsCount)];
    _m_AttentionBtn.selected        = aModel.m_AttentionFlag;
    _m_AttentionBtn.backgroundColor = [UIColor bm_colorWithHex:aModel.m_AttentionFlag ? 0xF5F6F7 : 0x4E7CF6];
    [_m_AttentionBtn setTitleColor:[UIColor bm_colorWithHex:aModel.m_AttentionFlag ? 0x999999 : 0xFFFFFF] forState:UIControlStateNormal];
    [_m_AttentionBtn setTitle:aModel.m_AttentionFlag ? @"已关注" : @"+ 关注" forState:UIControlStateNormal];
}




@end
