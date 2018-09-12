//
//  FSMainToolCell.m
//  fengshun
//
//  Created by Aiwei on 2018/9/5.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSMainToolCell.h"

@implementation FSMainToolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)prepareForReuse
{
    [super prepareForReuse];
    _m_iconImageView.image = nil;
    _m_titleLabel.text = nil;
}
- (void)setM_tool:(FSHomePageToolModel *)m_tool
{
    _m_tool = m_tool;
    [_m_iconImageView sd_setImageWithURL:[NSURL URLWithString:_m_tool.m_imageUrl] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _m_titleLabel.text = _m_tool.m_tilte;
}
@end
