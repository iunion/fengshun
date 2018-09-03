//
//  FSPlateListTableViewCell.m
//  fengshun
//
//  Created by best2wa on 2018/8/31.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSPlateListTableViewCell.h"

@implementation FSPlateListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_m_ImgView bm_roundedRect:4];
    [_m_DoBtn bm_roundedRect:_m_DoBtn.bm_height/2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
