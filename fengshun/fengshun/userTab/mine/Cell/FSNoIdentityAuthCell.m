//
//  FSNoIdentityAuthCell.m
//  fengshun
//
//  Created by 龚旭杰 on 2019/4/22.
//  Copyright © 2019年 FS. All rights reserved.
//

#import "FSNoIdentityAuthCell.h"
#import "NSAttributedString+BMCategory.h"


@interface FSNoIdentityAuthCell ()

@property (weak, nonatomic) IBOutlet UIImageView *m_StepImgView;
@property (weak, nonatomic) IBOutlet UILabel *m_TitleLab;
@property (weak, nonatomic) IBOutlet UILabel *m_ContentLab;
@property (weak, nonatomic) IBOutlet UIView *m_BigView;
@end

@implementation FSNoIdentityAuthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.m_BigView bm_roundedRect:3.f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showWithModel:(FSNoIdentityAuthModel *)model
{
    self.m_StepImgView.image = [UIImage imageNamed:model.m_ImageName];
    self.m_TitleLab.text = model.m_Title;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:model.m_Content];
    for (NSString *keywords in model.m_keyWords) {
        NSRange keyWordsRange = [model.m_Content rangeOfString:keywords];
         [attributeString bm_setTextColor:[UIColor bm_colorWithHex:0x4E7CF6] range:keyWordsRange];
    }
    [attributeString bm_setAttributeAlignmentStyle:NSTextAlignmentLeft lineSpaceStyle:15.f paragraphSpaceStyle:15.f lineBreakStyle:0];
    self.m_ContentLab.attributedText = attributeString;
}

@end
