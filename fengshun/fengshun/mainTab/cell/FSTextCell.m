//
//  FSTextCell.m
//  fengshun
//
//  Created by Aiwei on 2018/9/12.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSTextCell.h"
#import "FSSearchResultModel.h"

@implementation FSTextCell

- (void)awakeFromNib
{
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
    [FSSearchResultModel setTextLabel:_m_titleLabel withText:textModel.m_title fontSize:16 textColor:UI_COLOR_B1 attributed:colors];
}

@end
