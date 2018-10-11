//
//  FSMyCourseCollectionCell.m
//  fengshun
//
//  Created by jiang deng on 2018/10/10.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMyCourseCollectionCell.h"
#import "UIImageView+WebCache.h"

@interface FSMyCourseCollectionCell ()

@property (nonatomic, strong) FSMyCollectionModel *m_Model;

@property (weak, nonatomic) IBOutlet UIView *m_BgView;

@property (weak, nonatomic) IBOutlet UIView *m_ContentBgView;

@property (weak, nonatomic) IBOutlet UIImageView *m_IconImageView;

@property (weak, nonatomic) IBOutlet UILabel *m_TitleLabel;

@property (weak, nonatomic) IBOutlet UIView *m_BottomBgView;
@property (weak, nonatomic) IBOutlet UILabel *m_SourceLabel;

@property (weak, nonatomic) IBOutlet UIButton *m_CommentCountBtn;

@end

@implementation FSMyCourseCollectionCell

+ (CGFloat)cellHeight
{
    return 128.0f;
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
    
    self.m_SourceLabel.textColor = [UIColor bm_colorWithHex:0x999999];
    self.m_SourceLabel.font = UI_FONT_10;
    
    [self.m_CommentCountBtn setTitleColor:[UIColor bm_colorWithHex:0x999999] forState:UIControlStateNormal];
    self.m_CommentCountBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)drawCellWithModel:(FSMyCollectionModel *)model;
{
    self.m_Model = model;
    
    [self.m_IconImageView sd_setImageWithURL:[model.m_CoverThumbUrl bm_toURL] placeholderImage:[UIImage imageNamed:@"fsdefault_image100x80"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    
    self.m_TitleLabel.text = model.m_Title;
    
    CGSize size = [self.m_TitleLabel sizeThatFits:CGSizeMake(self.m_TitleLabel.bm_width, 1000)];
    CGFloat height = size.height;
    if (height>50.0f)
    {
        height = 50.0f;
    }
    
    self.m_TitleLabel.bm_height = height;
    
    if ([model.m_Source bm_isNotEmpty])
    {
        self.m_SourceLabel.hidden = NO;
        self.m_SourceLabel.text = model.m_Source;
    }
    else
    {
        self.m_SourceLabel.hidden = YES;
    }
    
    [self.m_CommentCountBtn setTitle:[NSString stringWithFormat:@"%@人阅读", model.m_ReadCount] forState:UIControlStateNormal];
}

@end
