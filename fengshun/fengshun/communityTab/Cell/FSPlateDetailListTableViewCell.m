//
//  FSPlateDetailListTableViewCell.m
//  fengshun
//
//  Created by best2wa on 2018/9/3.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSPlateDetailListTableViewCell.h"

@implementation FSPlateDetailListTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    [_m_StickView bm_roundedRect:_m_StickView.bm_height/2];
    [_m_CommentBtn bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end