//
//  FSCourseTableCell.m
//  fengshun
//
//  Created by Aiwei on 2018/8/31.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSCourseTableCell.h"


@implementation FSCourseTableCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 19);
    [_m_imageView bm_roundedRect:5];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setM_course:(FSCourseModel *)m_course
{
    _m_course = m_course;
    [_m_imageView sd_setImageWithURL:[NSURL URLWithString:_m_course.m_coverThumbUrl] placeholderImage:[UIImage imageNamed:@"placeholder_hp_hot"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    
    BOOL haveThumb = [m_course.m_coverThumbUrl bm_isNotEmpty];
    _m_imageView.hidden = !haveThumb;
    _m_textLeading.constant = haveThumb?146:20;
    
    _m_title.text     = _m_course.m_tilte;
    _m_subTitle.text  = _m_course.m_sourceInfo;
    _m_readCount.text = [NSString stringWithFormat:@"%ld人阅读", (long)_m_course.m_readCount];
}
@end
