//
//  FSLawCell.m
//  fengshun
//
//  Created by Aiwei on 2018/9/10.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSLawCell.h"

@implementation FSLawCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setLawResultModel:(FSLawResultModel *)model attributed:(BOOL)attributed
{
    _m_lawModel = model;
    [FSSearchResultModel setTextLabel:_m_titleLabel withText:model.m_title fontSize:18 textColor:UI_COLOR_B1 attributed:attributed];
    NSString * detail = @"";
    if ([model.m_Organ bm_isNotEmpty]) {
        detail = [detail stringByAppendingString:[NSString stringWithFormat:@" | %@\n",model.m_Organ]];
    }
    if ([model.m_publishDate bm_isNotEmpty]) {
        detail =  [detail stringByAppendingString:[NSString stringWithFormat:@" | %@ 颁布",model.m_publishDate]];
    }
    if ([model.m_executeDate bm_isNotEmpty]) {
        detail =  [detail stringByAppendingString:[NSString stringWithFormat:@" | %@ 实施",model.m_executeDate]];
    }
    [FSSearchResultModel setTextLabel:_m_detailLabel withText:detail fontSize:12 textColor:UI_COLOR_B4 attributed:attributed];
    [FSSearchResultModel setTextLabel:_m_contentLabel withText:model.m_simpleContent fontSize:14 textColor:UI_COLOR_B1 attributed:attributed];
    _m_contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _m_matchLabel.text  = [NSString stringWithFormat:@"命中法条 %@", @(model.m_matchCount)];
}

@end
