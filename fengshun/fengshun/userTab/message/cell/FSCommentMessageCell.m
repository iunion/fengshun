//
//  FSCommentMessageCell.m
//  fengshun
//
//  Created by jiang deng on 2018/9/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCommentMessageCell.h"

#import "UIImageView+WebCache.h"


@interface FSCommentMessageCell ()

@property (weak, nonatomic) IBOutlet UIView *m_BgView;

@property (weak, nonatomic) IBOutlet UIImageView *m_AvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *m_NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_ContentLabel;

@property (weak, nonatomic) IBOutlet UILabel *m_SourceLabel;

@property (nonatomic, strong) FSCommentMessageModle *m_Modle;

@end

@implementation FSCommentMessageCell

+ (CGFloat)cellHeight
{
    return 168.0f;
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
    self.m_NameLabel.textColor = [UIColor bm_colorWithHex:0x333333];
    self.m_NameLabel.font = UI_FONT_15;
    
    self.m_TimeLabel.textColor = [UIColor bm_colorWithHex:0x999999];
    self.m_TimeLabel.font = UI_FONT_12;
    
    self.m_ContentLabel.textColor = [UIColor bm_colorWithHex:0x999999];
    self.m_ContentLabel.font = UI_FONT_14;
    
    self.m_SourceLabel.textColor = [UIColor bm_colorWithHex:0x999999];
    self.m_SourceLabel.font = UI_FONT_12;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawCellWithModle:(FSCommentMessageModle *)model
{
    self.m_Modle = model;
    
    [self.m_AvatarImageView sd_setImageWithURL:[NSURL URLWithString:model.m_RelationUserAvatarUrl] placeholderImage:[UIImage imageNamed:@"default_avataricon"] options:SDWebImageRetryFailed|SDWebImageLowPriority];

    self.m_NameLabel.text = model.m_RelationUserName;
    self.m_TimeLabel.text = [NSDate hmStringDateFromTs:model.m_CreateTime];
    
    self.m_ContentLabel.text = model.m_Content;
    
    CGSize size = [self.m_ContentLabel sizeThatFits:CGSizeMake(self.m_ContentLabel.bm_width, 1000)];
    CGFloat height = size.height;
    if (height > 56.0f)
    {
        height = 56;
    }
    self.m_ContentLabel.bm_height = height;
    
    NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithString:@"评论了"];
    if ([model.m_Source bm_isNotEmpty])
    {
        atrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"评论了%@", model.m_Source]];
        [atrString bm_setTextColor:[UIColor bm_colorWithHex:0x999999] range:NSMakeRange(0, 3)];
        [atrString bm_setTextColor:UI_COLOR_BL1 range:NSMakeRange(3, model.m_Source.length)];
    }
    else
    {
        [atrString bm_setTextColor:[UIColor bm_colorWithHex:0x999999]];
    }
    [atrString bm_setFont:[UIFont systemFontOfSize:12.0f]];
    self.m_SourceLabel.attributedText = atrString;
}

@end
