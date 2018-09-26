//
//  FSMyCollectionCell.m
//  fengshun
//
//  Created by jiang deng on 2018/9/26.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMyCollectionCell.h"

@interface FSMyCollectionCell ()

@property (weak, nonatomic) IBOutlet UIView *m_BgView;

@property (weak, nonatomic) IBOutlet UILabel *m_TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_TimeLabel;

@end

@implementation FSMyCollectionCell

+ (CGFloat)cellHeight
{
    return 100.0f;
}

- (void)dealloc
{
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    [self makeCellStyle];
}

- (void)makeCellStyle
{
    self.m_TitleLabel.textColor = [UIColor bm_colorWithHex:0x333333];
    self.m_TitleLabel.font = UI_FONT_18;
    
    self.m_TimeLabel.textColor = [UIColor bm_colorWithHex:0x999999];
    self.m_TimeLabel.font = UI_FONT_10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
