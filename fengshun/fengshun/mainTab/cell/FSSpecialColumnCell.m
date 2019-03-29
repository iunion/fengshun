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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_imgViewConstraintWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_TitleLabConstraintLeft;

@end

@implementation FSSpecialColumnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight
{
    return 115.f;
}

- (void)drawCellWithIsHasImg:(BOOL)isHasImg
{
    if (isHasImg)
    {
        
    }
    else
    {
        
    }
}

@end
