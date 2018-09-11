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
- (void)setM_caseResultModel:(FSCaseReultModel *)model
{
    _m_caseResultModel = model;
    _m_titleLabel.text = model.m_title;
    NSString *htmlStr = [model.m_simpleContent stringByReplacingOccurrencesOfString:@"<em>" withString:@"<font color=\"red\">"];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"</em>" withString:@"</font>"];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
    _m_contentLabel.attributedText = attrStr;
    _m_tabLabel.text = model.m_caseTag;
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
    _m_detailLabel.text = [detail bm_isNotEmpty]?detail:nil;
}
@end
