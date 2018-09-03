//
//  FSCommunityHeaderView.m
//  fengshun
//
//  Created by best2wa on 2018/9/3.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCommunityHeaderView.h"

@implementation FSCommunityHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    [_m_UserHeaderImgView bm_roundedRect:4];
    [_m_AttentionBtn bm_roundedRect:_m_AttentionBtn.bm_height/2];
}

@end
