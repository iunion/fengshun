//
//  FSCollectionCourseCell.m
//  fengshun
//
//  Created by Aiwei on 2018/9/20.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSCollectionCourseCell.h"

@implementation FSCollectionCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 19);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setM_course:(FSCourseModel *)m_course
{
    _m_course = m_course;
    [_m_imageView sd_setImageWithURL:[NSURL URLWithString:_m_course.m_coverThumbUrl] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _m_title.text     = _m_course.m_tilte;
    _m_subTitle.text  = _m_course.m_sourceInfo;
    _m_readCount.text = [NSString stringWithFormat:@"%ld人阅读", (long)_m_course.m_readCount];
}
@end
