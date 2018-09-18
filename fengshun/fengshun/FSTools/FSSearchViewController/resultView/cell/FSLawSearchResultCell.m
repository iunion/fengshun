//
//  FSLawSearchResultCell.m
//  fengshun
//
//  Created by Aiwei on 2018/9/10.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSLawSearchResultCell.h"

@implementation FSLawSearchResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setM_lawResultModel:(FSLawResultModel *)model
{
    _m_lawResultModel = model;
    _m_titleLabel.text = model.m_title;
    NSString *htmlStr = [model.m_simpleContent stringByReplacingOccurrencesOfString:@"<em>" withString:@"<font color=\"red\">"];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"</em>" withString:@"</font>"];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    _m_contentLabel.attributedText = attrStr;
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
    _m_detailLabel.text = [detail bm_isNotEmpty]?detail:nil;
    _m_matchLabel.text  = [NSString stringWithFormat:@"命中法条 %ld",model.m_matchCount];
}

@end
