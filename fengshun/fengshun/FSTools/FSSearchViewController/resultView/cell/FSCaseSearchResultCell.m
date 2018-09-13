//
//  FSCaseSearchResultCell.m
//  fengshun
//
//  Created by Aiwei on 2018/9/7.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSCaseSearchResultCell.h"

@implementation FSCaseSearchResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    [_m_tagView bm_roundedRect:11];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setAttributedCaseResultModel:(FSCaseReultModel *)model
{
    _m_caseResultModel = model;
    _m_titleLabel.attributedText = [NSMutableAttributedString bm_attributedStringReplaceHTMLString:model.m_title fontSize:18 contentColor:UI_COLOR_B1.hexStringFromColor tagColor:UI_COLOR_R1.hexStringFromColor starTag:@"<em>" endTag:@"</em>"];
    NSString * detail = @"";
    if ([model.m_court bm_isNotEmpty]) {
        detail = [detail stringByAppendingString:[NSString stringWithFormat:@" | %@",model.m_court]];
    }
    if ([model.m_caseNo bm_isNotEmpty]) {
        detail =  [detail stringByAppendingString:[NSString stringWithFormat:@" | %@",model.m_caseNo]];
    }
    if ([model.m_date bm_isNotEmpty]) {
        detail =  [detail stringByAppendingString:[NSString stringWithFormat:@" | %@",model.m_date]];
    }
    _m_detailLabel.attributedText = [NSMutableAttributedString bm_attributedStringReplaceHTMLString:detail fontSize:12 contentColor:UI_COLOR_B4.hexStringFromColor tagColor:UI_COLOR_R1.hexStringFromColor starTag:@"<em>" endTag:@"</em>"];
    _m_contentLabel.attributedText = [NSMutableAttributedString bm_attributedStringReplaceHTMLString:model.m_simpleContent fontSize:14 contentColor:UI_COLOR_B1.hexStringFromColor tagColor:UI_COLOR_R1.hexStringFromColor starTag:@"<em>" endTag:@"</em>"];
    _m_tabLabel.text = model.m_caseTag;
}

@end
