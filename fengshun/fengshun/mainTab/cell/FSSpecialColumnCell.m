//
//  FSSpecialColumnCell.m
//  fengshun
//
//  Created by 龚旭杰 on 2019/3/29.
//  Copyright © 2019年 FS. All rights reserved.
//

#import "FSSpecialColumnCell.h"

@interface FSSpecialColumnCell ()

/**
 封面
 */
@property (weak, nonatomic) IBOutlet UIImageView *m_imgView;

/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *m_TitleLab;

/**
 阅读数
 */
@property (weak, nonatomic) IBOutlet UILabel *m_ReadCountLab;

/**
 评论数
 */
@property (weak, nonatomic) IBOutlet UILabel *m_CommentCountLab;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_imgViewConstraintWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_TitleLabConstraintLeft;

@end

@implementation FSSpecialColumnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_m_imgView bm_roundedRect:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight
{
    return 115.f;
}

- (void)drawCellWithIsHasImg:(BOOL)isHasImg model:(nonnull FSColumCellModel *)model
{
    if (isHasImg)
    {
        self.m_imgViewConstraintWidth.constant = 67.f;
        self.m_TitleLabConstraintLeft.constant = 12.f;
        [self.m_imgView sd_setImageWithURL:[NSURL URLWithString:model.m_ThumbUrl]placeholderImage:[UIImage imageNamed:@"default_avatariconlarge"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    }
    else
    {
        self.m_imgViewConstraintWidth.constant = 0;
        self.m_TitleLabConstraintLeft.constant = 0;
    }
//    [self layoutIfNeeded];
    self.m_TitleLab.text = model.m_Title;
    self.m_ReadCountLab.text = [NSString stringWithFormat:@"%@人阅读",@(model.m_ReadCount)];
    self.m_CommentCountLab.text = [NSString stringWithFormat:@"%@",@(model.m_CommentCount)];
    self.bottomLine.hidden = model.m_IsLast;
}

- (void)showCollectionCellModel:(FSMyCollectionModel *)model
{
    if ([model.m_CoverThumbUrl bm_isNotEmpty])
    {
        self.m_imgViewConstraintWidth.constant = 67.f;
        self.m_TitleLabConstraintLeft.constant = 12.f;
        [self.m_imgView sd_setImageWithURL:[NSURL URLWithString:model.m_CoverThumbUrl]placeholderImage:[UIImage imageNamed:@"placeholder_hp_hot"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    }
    else
    {
        self.m_imgViewConstraintWidth.constant = 0;
        self.m_TitleLabConstraintLeft.constant = 0;
    }
    self.m_TitleLab.text = model.m_Title;
    self.m_ReadCountLab.text = [NSString stringWithFormat:@"%@人阅读",model.m_ReadCount];
    self.m_CommentCountLab.text = [NSString stringWithFormat:@"%@",model.m_CommentCount];
}

@end
