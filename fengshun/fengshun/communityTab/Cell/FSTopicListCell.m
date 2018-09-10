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

- (void)dealloc
{
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code

    [self makeCellStyle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)makeCellStyle
{
    [self.m_CategoryView bm_roundedRect:self.m_CategoryView.bm_height * 0.5f];
    [self.m_HeaderImgView bm_roundedRect:self.m_HeaderImgView.bm_height * 0.5f];
    [self.m_StickView bm_roundedRect:self.m_StickView.bm_height * 0.5f];
    [self.m_CommentBtn bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:5.0f];
}


- (void)showWithTopicModel:(FSTopicModel *)aModel
{
    //    [_m_HeaderImgView sd_setImageWithURL:[aModel.m_IconUrl bm_toURL] placeholderImage:[UIImage imageNamed:@""]];
    [_m_HeaderImgView sd_setImageWithURL:[aModel.m_IconUrl bm_toURL]];
    _m_CategoryLab.text = aModel.m_ForumName;
    _m_TitleLab.text    = aModel.m_Title;
    _m_TimeLab.text     = [NSDate hmStringDateFromTs:aModel.m_LastReplyTime];
    _m_UserNameLab.text = aModel.m_NickName;
    [_m_CommentBtn setTitle:[NSString stringWithFormat:@"%@", @(aModel.m_CommentCount)] forState:UIControlStateNormal];
    _m_StickView.hidden = !aModel.m_TopFlag;
}

- (void)drawCellWithModle:(FSTopicModel *)model
{
    [self.m_HeaderImgView sd_setImageWithURL:[model.m_IconUrl bm_toURL] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageLowPriority];
    self.m_CategoryLab.text = model.m_ForumName;
    self.m_TitleLab.text    = model.m_Title;
    self.m_TimeLab.text     = [NSDate hmStringDateFromTs:model.m_LastReplyTime];
    self.m_UserNameLab.text = model.m_NickName;
    [self.m_CommentBtn setTitle:[NSString stringWithFormat:@"%@", @(model.m_CommentCount)] forState:UIControlStateNormal];
    self.m_StickView.hidden = !model.m_TopFlag;
}

@end
