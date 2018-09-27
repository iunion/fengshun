//
//  FSTextTypeCell.m
//  fengshun
//
//  Created by Aiwei on 2018/9/12.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSTextTypeCell.h"

@implementation FSTextTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _m_tagView.hidden = !selected;
    if (selected) {
        _m_typeNameLabel.textColor = UI_COLOR_BL1;
        _m_typeNameLabel.font=[UIFont boldSystemFontOfSize:15];
        self.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        _m_typeNameLabel.textColor = UI_COLOR_B1;
        _m_typeNameLabel.font=[UIFont systemFontOfSize:14];
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
