//
//  FSCaseCell.m
//  fengshun
//
//  Created by Aiwei on 2018/9/7.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSCaseCell.h"

@interface FSCaseCell()
@property (weak, nonatomic) IBOutlet UILabel *m_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_tabLabel;
@property (weak, nonatomic) IBOutlet UIView *m_tagView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

@end

@implementation FSCaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    [_m_tagView bm_roundedRect:11];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCaseResultModel:(FSCaseResultModel *)model attributed:(BOOL)attributed
{
    _m_caseModel = model;
    [FSSearchResultModel setTextLabel:_m_titleLabel withText:model.m_title fontSize:18 textColor:UI_COLOR_B1 attributed:attributed];
    NSString * detail = @"";
    if (model.m_isGuidingCase) {

        detail = [NSString stringWithFormat:@" | %@",model.m_basicInfo];
    }
    else
    {
        if ([model.m_court bm_isNotEmpty]) {
            detail = [detail stringByAppendingString:[NSString stringWithFormat:@" | %@",model.m_court]];
        }
        if ([model.m_caseNo bm_isNotEmpty]) {
            detail =  [detail stringByAppendingString:[NSString stringWithFormat:@" | %@",model.m_caseNo]];
        }
    }
    
    [FSSearchResultModel setTextLabel:_m_detailLabel withText:detail fontSize:12 textColor:UI_COLOR_B4 attributed:attributed];
    [FSSearchResultModel setTextLabel:_m_contentLabel withText:model.m_simpleContent fontSize:14 textColor:UI_COLOR_B1 attributed:attributed];
    _m_contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _m_tabLabel.hidden = !model.m_isGuidingCase;
    _m_tagView.hidden = !model.m_isGuidingCase;
}

@end
