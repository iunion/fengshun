//
//  FSMyCollectionCell.m
//  fengshun
//
//  Created by jiang deng on 2018/9/26.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMyCollectionCell.h"
#import "BMSingleLineView.h"

@interface FSMyCollectionCell ()

@property (nonatomic, strong) FSMyCollectionModel *m_Model;

@property (weak, nonatomic) IBOutlet UIView *m_BgView;

@property (weak, nonatomic) IBOutlet UILabel *m_TitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *m_TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_SourceLabel;

@property (weak, nonatomic) IBOutlet UIButton *m_CommentCountBtn;

@property (nonatomic, strong) BMSingleLineView *m_UnderLineView;

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
    self.m_SourceLabel.backgroundColor = [UIColor bm_colorWithHex:0xE5ECFD];
    [self.m_SourceLabel bm_roundedRect:self.m_SourceLabel.bm_height*0.5];
    
    [self.m_CommentCountBtn setTitleColor:[UIColor bm_colorWithHex:0x999999] forState:UIControlStateNormal];
    self.m_CommentCountBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    
    CGRect underLineFrame = CGRectMake(15.0f, self.contentView.bm_bottom, UI_SCREEN_WIDTH-30.0f, 1);
    self.m_UnderLineView = [[BMSingleLineView alloc] initWithFrame:underLineFrame];
    self.m_UnderLineView.lineColor = UI_DEFAULT_LINECOLOR;
    [self addSubview:self.m_UnderLineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawCellWithModel:(FSMyCollectionModel *)model;
{
    self.m_Model = model;
    
    self.m_TitleLabel.text = model.m_Title;
    
    self.m_TimeLabel.text = [NSDate fsStringDateFromTs:model.m_CreateTime];
    
    CGSize size = [self.m_TimeLabel sizeThatFits:CGSizeMake(1000, self.m_TimeLabel.bm_height)];
    self.m_SourceLabel.bm_left = size.width + 6.0f;

    if ([model.m_Source bm_isNotEmpty])
    {
        self.m_SourceLabel.hidden = NO;
        self.m_SourceLabel.text = model.m_Source;
        size = [self.m_SourceLabel sizeThatFits:CGSizeMake(1000, self.m_SourceLabel.bm_height)];
        self.m_SourceLabel.bm_width = size.width+12.0f;
    }
    else
    {
        self.m_SourceLabel.hidden = YES;
    }
    
    [self.m_CommentCountBtn setTitle:[NSString stringWithFormat:@"%@", @(model.m_CommentCount)] forState:UIControlStateNormal];
    
    self.m_UnderLineView.hidden = model.m_PositionType & BMTableViewCell_PositionType_Last;
}

@end
