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

@property (weak, nonatomic) IBOutlet UIView *m_BottomBgView;
@property (weak, nonatomic) IBOutlet UILabel *m_TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_SourceLabel;

@property (weak, nonatomic) IBOutlet UIButton *m_CommentCountBtn;

//@property (nonatomic, strong) BMSingleLineView *m_UnderLineView;

@end

@implementation FSMyCollectionCell

+ (CGFloat)cellHeight
{
    return 108.0f;
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
    //self.m_SourceLabel.backgroundColor = [UIColor bm_colorWithHex:0xE5ECFD];
    //[self.m_SourceLabel bm_roundedRect:self.m_SourceLabel.bm_height*0.5];
    
    [self.m_CommentCountBtn setTitleColor:[UIColor bm_colorWithHex:0x999999] forState:UIControlStateNormal];
    self.m_CommentCountBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    
//    CGRect underLineFrame = CGRectMake(15.0f, self.m_BgView.bm_bottom, UI_SCREEN_WIDTH-30.0f, 1);
//    self.m_UnderLineView = [[BMSingleLineView alloc] initWithFrame:underLineFrame];
//    self.m_UnderLineView.lineColor = UI_DEFAULT_LINECOLOR;
//    [self addSubview:self.m_UnderLineView];
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
    self.m_TitleLabel.bm_height = model.m_TitleHeight;
    
    self.m_BottomBgView.bm_top = model.m_TitleHeight + 36.0f;
    
    if (model.m_CollectionType == FSCollectionType_POSTS)
    {
        self.m_TimeLabel.hidden = NO;
        self.m_TimeLabel.text = [NSDate fsStringDateFromTs:model.m_CreateTime];
        
        CGSize size = [self.m_TimeLabel sizeThatFits:CGSizeMake(1000, self.m_TimeLabel.bm_height)];
        self.m_SourceLabel.bm_left = size.width + 6.0f;
    }
    else
    {
        self.m_TimeLabel.hidden = YES;
    }

    if ([model.m_Source bm_isNotEmpty])
    {
        self.m_SourceLabel.hidden = NO;
        self.m_SourceLabel.text = model.m_Source;
        CGSize size = [self.m_SourceLabel sizeThatFits:CGSizeMake(1000, self.m_SourceLabel.bm_height)];
        if (model.m_CollectionType == FSCollectionType_POSTS)
        {
            self.m_SourceLabel.textAlignment = NSTextAlignmentCenter;
            self.m_SourceLabel.textColor = UI_COLOR_BL1;
            self.m_SourceLabel.backgroundColor = [UIColor bm_colorWithHex:0xE5ECFD];
            self.m_SourceLabel.bm_width = size.width+12.0f;
            [self.m_SourceLabel bm_roundedRect:self.m_SourceLabel.bm_height*0.5];
        }
        else
        {
            self.m_SourceLabel.textAlignment = NSTextAlignmentLeft;
            self.m_SourceLabel.textColor = [UIColor bm_colorWithHex:0x999999];
            self.m_SourceLabel.backgroundColor = [UIColor clearColor];
            self.m_SourceLabel.bm_left = 0;
            self.m_SourceLabel.bm_width = size.width;
            [self.m_SourceLabel bm_removeBorders];
        }
    }
    else
    {
        self.m_SourceLabel.hidden = YES;
    }
    
    [self.m_CommentCountBtn setTitle:[NSString stringWithFormat:@"%@", model.m_CommentCount] forState:UIControlStateNormal];
    self.m_CommentCountBtn.hidden = !(model.m_CollectionType == FSCollectionType_POSTS || model.m_CollectionType == FSCollectionType_COURSE);
    
    if ([model.m_CommentCount bm_isNotEmpty])
    {
        [self.m_CommentCountBtn setTitle:model.m_CommentCount forState:UIControlStateNormal];
        [self.m_CommentCountBtn setImage:[UIImage imageNamed:@"community_comment_white"] forState:UIControlStateNormal];
    }
    else if ([model.m_ReadCount bm_isNotEmpty])
    {
        [self.m_CommentCountBtn setTitle:[NSString stringWithFormat:@"%@人阅读", model.m_ReadCount] forState:UIControlStateNormal];
        [self.m_CommentCountBtn setImage:nil forState:UIControlStateNormal];
    }
    else
    {
        [self.m_CommentCountBtn setHidden:YES];
    }

    //self.m_UnderLineView.hidden = model.m_PositionType & BMTableViewCell_PositionType_Last;
}

@end
