//
//  FSNoticeMessageCell.m
//  fengshun
//
//  Created by jiang deng on 2018/9/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSNoticeMessageCell.h"

@interface FSNoticeMessageCell ()

@property (weak, nonatomic) IBOutlet UIView *m_BgView;

@property (weak, nonatomic) IBOutlet UILabel *m_TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_ContentLabel;

@property (nonatomic, strong) FSNoticeMessageModle *m_Modle;

@end

@implementation FSNoticeMessageCell

+ (CGFloat)cellHeight
{
    return 118.0f;
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
    self.m_TitleLabel.font = UI_FONT_16;
    
    self.m_TimeLabel.textColor = [UIColor bm_colorWithHex:0x999999];
    self.m_TimeLabel.font = UI_FONT_12;
    
    self.m_ContentLabel.textColor = [UIColor bm_colorWithHex:0x999999];
    self.m_ContentLabel.font = UI_FONT_14;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawCellWithModle:(FSNoticeMessageModle *)model
{
    self.m_Modle = model;
    
    self.m_TitleLabel.text = model.m_Title;
    self.m_TimeLabel.text = [NSDate fsStringDateFromTs:model.m_CreateTime];
    
    self.m_ContentLabel.text = model.m_Content;
    
    CGSize size = [self.m_ContentLabel sizeThatFits:CGSizeMake(self.m_ContentLabel.bm_width, 1000)];
    CGFloat height = size.height;
    if (height > 40.0f)
    {
        height = 40;
    }
    self.m_ContentLabel.bm_height = height;
}

@end
