//
//  FSCommunityListTableViewCell.m
//  fengshun
//
//  Created by best2wa on 2018/8/31.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCommunityListTableViewCell.h"
#import "UIButton+BMContentRect.h"

@implementation FSCommunityListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_m_categoryView bm_roundedRect:_m_categoryView.bm_height/2];
    [_m_headerImgView bm_roundedRect:_m_headerImgView.bm_height/2];
    [_m_commentBtn bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
