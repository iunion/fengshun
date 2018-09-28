//
//  FSTextCell.m
//  fengshun
//
//  Created by Aiwei on 2018/9/12.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSTextCell.h"
#import "FSSearchResultModel.h"

@implementation FSTextCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 15);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTextModel:(FSListTextModel *)textModel colors:(NSString *)colors
{
    _m_textModel = textModel;
    if ([colors bm_isNotEmpty]) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:textModel.m_title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:UI_COLOR_B1}];
        
        NSMutableString *tmpString = [NSMutableString stringWithString:attrStr.string];
        NSRange range = [attrStr.string rangeOfString:colors];
        NSInteger location = 0;
        while (range.length>0)
        {
            [attrStr bm_setTextColor:UI_COLOR_R1 range:NSMakeRange(location+range.location, range.length)];
            location += (range.location+range.length);
            NSString *tmp = [tmpString substringWithRange:NSMakeRange(range.location+range.length, attrStr.string.length-location)];
            tmpString = [NSMutableString stringWithString:tmp];
            range=[tmp rangeOfString:colors];
        }
       
//        [attrStr addAttribute:NSForegroundColorAttributeName value:UI_COLOR_R1 range:[textModel.m_title rangeOfString:colors]];
        
        _m_titleLabel.attributedText = attrStr;
    }
    else
    {
        _m_titleLabel.text = textModel.m_title;
    }
}

@end
