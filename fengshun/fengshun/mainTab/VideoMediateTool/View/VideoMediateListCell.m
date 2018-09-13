//
//  VideoMediateListCell.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "VideoMediateListCell.h"

@implementation VideoMediateListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor bm_colorWithHex:0xF4F4F4];
    
    self.m_BGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bm_width, 126)];
    _m_BGView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_m_BGView];
    
}


@end
