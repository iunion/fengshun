//
//  FSImageFileCell.m
//  fengshun
//
//  Created by Aiwei on 2018/9/14.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSImageFileCell.h"

@implementation FSImageFileCell

+(CGSize)cellSize
{
    return CGSizeMake(107, 183);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [_m_selectTag bm_roundedRect:10];
    [_m_selectIndexLabel bm_roundedRect:10];
}
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (_m_editing) {
        _m_selectTag.hidden = NO;
        _m_selectIndexLabel.hidden = !selected;
    }
    else
    {
        _m_selectIndexLabel.hidden = YES;
        _m_selectTag.hidden = YES;
    }
    
}
- (void)setM_imageFile:(FSImageFileModel *)model
{
    _m_imageFile           = model;
    _m_imageView.image     = model.m_image;
    _m_fileNameLabel.text  = model.m_fileName;
    _m_creatTimeLabel.text = model.m_creatTime;
}
@end
