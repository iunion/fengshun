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
- (NSMutableAttributedString *)attributedStringWithString:(NSString *)string font:(CGFloat)font color:(UIColor *)color andKey:(NSString *)keyword
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font],NSForegroundColorAttributeName:color}];
    
    NSMutableString *tmpString = [NSMutableString stringWithString:attrStr.string];
    NSRange range = [attrStr.string rangeOfString:keyword];
    NSInteger location = 0;
    while (range.length>0)
    {
        [attrStr bm_setTextColor:UI_COLOR_R1 range:NSMakeRange(location+range.location, range.length)];
        location += (range.location+range.length);
        NSString *tmp = [tmpString substringWithRange:NSMakeRange(range.location+range.length, attrStr.string.length-location)];
        tmpString = [NSMutableString stringWithString:tmp];
        range=[tmp rangeOfString:keyword];
    }
    return attrStr;
}
- (void)setTextModel:(FSListTextModel *)textModel colors:(NSString *)colors
{
    _m_textModel = textModel;
    NSString *title = textModel.m_title;
    NSString *subTitle = textModel.m_subTitle;
    _m_titlesGap.constant = [subTitle bm_isNotEmpty] ? 9 :0;
    if ([colors bm_isNotEmpty])
    {
        
        if ([title bm_isNotEmpty]) {
            _m_titleLabel.attributedText = [self attributedStringWithString:title font:16 color:UI_COLOR_B1 andKey:colors];
        }
        else
        {
            _m_titleLabel.text = nil;
        }
        if ([subTitle bm_isNotEmpty]) {
            _m_subTitleLabel.attributedText = [self attributedStringWithString:subTitle font:12 color:UI_COLOR_B4 andKey:colors];
        }
        else
        {
            _m_subTitleLabel.text = nil;
        }
    }
    else
    {
        _m_titleLabel.text = title;
        _m_subTitleLabel.text = subTitle;
    }
}

@end
