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

+ (CGFloat)cellHeight{
    return 107;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self makeCellStyle];
}

- (void)makeCellStyle
{
    [_m_StickView bm_roundedRect:_m_StickView.bm_height / 2];
    [_m_CommentBtn bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:5];
}


- (void)showWithTopicModel:(FSTopicModel *)model{
    self.m_TitleLab.text    = model.m_Title;
    self.m_TimeLab.text     = [NSDate hmStringDateFromTs:model.m_LastReplyTime];
    self.m_UsernameLab.text = model.m_NickName;
    [self.m_CommentBtn setTitle:[NSString stringWithFormat:@"%@", @(model.m_CommentCount)] forState:UIControlStateNormal];
    self.m_StickView.hidden = !model.m_TopFlag;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
