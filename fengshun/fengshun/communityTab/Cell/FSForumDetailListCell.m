//
//  FSPlateDetailListTableViewCell.m
//  fengshun
//
//  Created by best2wa on 2018/9/3.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSForumDetailListCell.h"

@interface FSForumDetailListCell()

// 帖子标题
@property (weak, nonatomic) IBOutlet UILabel *m_TitleLab;
// 发帖时间
@property (weak, nonatomic) IBOutlet UILabel *m_TimeLab;
// 发帖人
@property (weak, nonatomic) IBOutlet UILabel *m_UsernameLab;
// 置顶View
@property (weak, nonatomic) IBOutlet UIView *m_StickView;
// 评论按钮
@property (weak, nonatomic) IBOutlet UIButton *m_CommentBtn;

@end

@implementation FSForumDetailListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)makeCellStyle
{
    [_m_StickView bm_roundedRect:_m_StickView.bm_height / 2];
    [_m_CommentBtn bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
