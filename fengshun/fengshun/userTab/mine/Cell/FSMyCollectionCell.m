//
//  FSMyCollectionCell.m
//  fengshun
//
//  Created by jiang deng on 2018/9/26.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMyCollectionCell.h"

@interface FSMyCollectionCell ()

@property (nonatomic, strong) FSCollectionModel *m_Model;

@property (weak, nonatomic) IBOutlet UIView *m_BgView;

@property (weak, nonatomic) IBOutlet UILabel *m_TitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *m_TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_SourceLabel;

@property (weak, nonatomic) IBOutlet UIButton *m_CommentCountBtn;


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

    self.m_SourceLabel.textColor = UI_COLOR_BL1;
    self.m_SourceLabel.font = UI_FONT_10;
    self.m_SourceLabel.backgroundColor = [UIColor bm_colorWithHex:0xF0F5FC];
    [self.m_SourceLabel bm_roundedRect:self.m_SourceLabel.bm_height*0.5];
    
    [self.m_CommentCountBtn setTitleColor:[UIColor bm_colorWithHex:0x999999] forState:UIControlStateNormal];
    self.m_CommentCountBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showWithCollectionModel:(FSCollectionModel *)model;
{
    self.m_Model = model;
    
    self.m_TitleLabel.text = model.m_Title;
    
    self.m_TimeLabel.text = [NSDate fsStringDateFromTs:model.m_CreateTime];
    
    CGSize size = [self.m_TimeLabel sizeThatFits:CGSizeMake(1000, self.m_TimeLabel.bm_height)];
    self.m_SourceLabel.bm_left = size.width + 6.0f;

    self.m_SourceLabel.text = model.m_Source;
    size = [self.m_SourceLabel sizeThatFits:CGSizeMake(1000, self.m_SourceLabel.bm_height)];
    self.m_SourceLabel.bm_width = size.width+12.0f;
    
    [self.m_CommentCountBtn setTitle:[NSString stringWithFormat:@"%@", @(model.m_CommentCount)] forState:UIControlStateNormal];
}

@end
