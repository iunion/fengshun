//
//  FSMyTopicCell.m
//  fengshun
//
//  Created by jiang deng on 2018/9/26.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMyTopicCell.h"
#import "BMSingleLineView.h"

@interface FSMyTopicCell ()

@property (nonatomic, strong) FSMyTopicModel *m_Model;

@property (weak, nonatomic) IBOutlet UIView *m_BgView;

@property (weak, nonatomic) IBOutlet UILabel *m_SourceLabel;

@property (weak, nonatomic) IBOutlet UILabel *m_TitleLabel;

@property (nonatomic, strong) BMSingleLineView *m_UnderLineView;

@property (weak, nonatomic) IBOutlet UILabel *m_ContentLabel;

@property (weak, nonatomic) IBOutlet UIView *m_BottomView;
@property (weak, nonatomic) IBOutlet UILabel *m_TimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *m_CommentCountBtn;

@end

@implementation FSMyTopicCell

+ (CGFloat)cellHeightWithDescription:(NSString *)description;
{
    CGSize dSize = [description bm_sizeToFitWidth:UI_SCREEN_WIDTH - 15*2 withFont:UI_FONT_14];
    if (dSize.height > 54) { dSize.height = 54; }// 最多支持三行
    return 68 + dSize.height + 15  + 20 + 15 + 8;

//    return 188.0f;
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
    self.m_SourceLabel.textColor = UI_COLOR_BL1;
    self.m_SourceLabel.font = UI_FONT_12;
    self.m_SourceLabel.backgroundColor = [UIColor bm_colorWithHex:0xE5ECFD];
    [self.m_SourceLabel bm_roundedRect:self.m_SourceLabel.bm_height*0.5];

    self.m_TitleLabel.textColor = [UIColor bm_colorWithHex:0x333333];
    self.m_TitleLabel.font = UI_FONT_18;
    
    self.m_ContentLabel.textColor = [UIColor bm_colorWithHex:0x999999];
    self.m_ContentLabel.numberOfLines = 0;
    self.m_ContentLabel.font = UI_FONT_14;

    self.m_TimeLabel.textColor = [UIColor bm_colorWithHex:0x999999];
    self.m_TimeLabel.font = UI_FONT_14;
    
    [self.m_CommentCountBtn setTitleColor:[UIColor bm_colorWithHex:0x999999] forState:UIControlStateNormal];
    self.m_CommentCountBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    
    CGRect underLineFrame = CGRectMake(15.0f, 50, UI_SCREEN_WIDTH-15.0f, 1);
    self.m_UnderLineView = [[BMSingleLineView alloc] initWithFrame:underLineFrame];
    self.m_UnderLineView.lineColor = UI_DEFAULT_LINECOLOR;
    [self.m_BgView addSubview:self.m_UnderLineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawCellWithModel:(FSMyTopicModel *)model
{
    self.m_Model = model;
    
    self.m_SourceLabel.text = model.m_ForumName;
    CGSize size = [self.m_SourceLabel sizeThatFits:CGSizeMake(1000, self.m_SourceLabel.bm_height)];
    self.m_SourceLabel.bm_width = size.width + 20.0f;

    self.m_TitleLabel.bm_left = self.m_SourceLabel.bm_right + 15.0f;
    self.m_TitleLabel.bm_width = UI_SCREEN_WIDTH - 15.0f*2 - self.m_TitleLabel.frame.origin.x;
    self.m_TitleLabel.text = model.m_Title;
    
    CGSize dSize = [model.m_Description bm_sizeToFitWidth:UI_SCREEN_WIDTH - 15*2 withFont:UI_FONT_14];
    if (dSize.height > 54) { dSize.height = 54; }// 最多支持三行

    self.m_ContentLabel.text = model.m_Description;
    self.m_ContentLabel.bm_height = dSize.height;
    self.m_BottomView.bm_top = 15 + self.m_ContentLabel.bm_bottom;
    
    self.m_TimeLabel.text = [NSDate fsStringDateFromTs:model.m_CreateTime];

    [self.m_CommentCountBtn setTitle:[NSString stringWithFormat:@"%@", @(model.m_CommentCount)] forState:UIControlStateNormal];
}

@end
