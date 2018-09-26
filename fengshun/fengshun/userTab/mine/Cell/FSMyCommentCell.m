//
//  FSMyCommentCell.m
//  fengshun
//
//  Created by best2wa on 2018/9/25.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMyCommentCell.h"
#import "NSDate+BMCategory.h"


@interface FSMyCommentCell ()

@property (nonatomic, strong) FSMyCommentModel *m_Model;

@property (weak, nonatomic) IBOutlet UIView *m_BgView;


@property (weak, nonatomic) IBOutlet UILabel *m_TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_ContentLabel;

@property (weak, nonatomic) IBOutlet UILabel *m_SourceLabel;

@property (weak, nonatomic) IBOutlet UIButton *m_CommentBtn;

@end

@implementation FSMyCommentCell

+ (CGFloat)cellHeight
{
    return 145.0f;
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
    self.m_TimeLabel.textColor = [UIColor bm_colorWithHex:0x666666];
    self.m_TimeLabel.font = UI_FONT_14;
    
    self.m_ContentLabel.textColor = [UIColor bm_colorWithHex:0x666666];
    self.m_ContentLabel.font = UI_FONT_14;
    
    self.m_SourceLabel.textColor = UI_COLOR_BL1;
    self.m_SourceLabel.font = UI_FONT_14;
    //self.m_SourceLabel.backgroundColor = [UIColor bm_colorWithHex:0xF0F5FC];
    //[self.m_SourceLabel bm_roundedRect:self.m_SourceLabel.bm_height*0.5];
    
    [self.m_CommentBtn setTitleColor:[UIColor bm_colorWithHex:0x999999] forState:UIControlStateNormal];
    self.m_CommentBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawCellWithModel:(FSMyCommentModel *)model
{
    self.m_TimeLabel.text = [NSDate fsStringDateFromTs:model.m_CreateTime];
    
    self.m_ContentLabel.text = model.m_Content;
    
    NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithString:@"来自："];
    if ([model.m_Source bm_isNotEmpty])
    {
        atrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"来自：%@", model.m_Source]];
        [atrString bm_setTextColor:[UIColor bm_colorWithHex:0x999999] range:NSMakeRange(0, 3)];
        [atrString bm_setTextColor:UI_COLOR_BL1 range:NSMakeRange(3, model.m_Source.length)];
    }
    else
    {
        [atrString bm_setTextColor:[UIColor bm_colorWithHex:0x999999]];
    }
    [atrString bm_setFont:[UIFont systemFontOfSize:12.0f]];
    self.m_SourceLabel.attributedText = atrString;
    
    [self.m_CommentBtn setTitle:@"0" forState:UIControlStateNormal];
}

@end
