//
//  FSTextListCell.m
//  fengshun
//
//  Created by Aiwei on 2018/9/12.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSTextListCell.h"

@implementation FSTextListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 15);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setTextModel:(FSListTextModel *)textModel colors:(BOOL)colors
{
    _m_textModel = textModel;
    _m_titleLabel.text = textModel.m_title;
    if ([textModel.m_subtitle bm_isNotEmpty]) {
        _m_subTitleLabel.text = [NSString stringWithFormat:@"\n%@",textModel.m_subtitle];
    }
    else
    {
        _m_subTitleLabel.text = nil;
    }
}
@end
