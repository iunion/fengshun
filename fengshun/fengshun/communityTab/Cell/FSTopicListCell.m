//
//  FSCommunityListTableViewCell.m
//  fengshun
//
//  Created by best2wa on 2018/8/31.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSTopicListCell.h"

#import "BMSingleLineView.h"
#import "UIImageView+WebCache.h"

@interface FSTopicListCell ()

// 头像&&分类标题父视图
@property (weak, nonatomic) IBOutlet UIView *m_ForumBgView;
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *m_HeaderImageView;
// 分类标题
@property (weak, nonatomic) IBOutlet UILabel *m_ForumLabel;

// 置顶标识view
@property (weak, nonatomic) IBOutlet UIView *m_StickBgView;
// 置顶
@property (weak, nonatomic) IBOutlet UILabel *m_StickLabel;

// 标题
@property (weak, nonatomic) IBOutlet UILabel *m_TitleLabel;

// 帖子发布时间
@property (weak, nonatomic) IBOutlet UILabel *m_TimeLabel;
// 用户名
@property (weak, nonatomic) IBOutlet UILabel *m_UserNameLabel;
// 评论按钮
@property (weak, nonatomic) IBOutlet UIButton *m_CommentBtn;

@property (nonatomic, strong) BMSingleLineView *m_UnderLineView;

@property (nonatomic, strong) FSTopicModel *m_TopicModel;

@end

@implementation FSTopicListCell

+ (CGFloat)cellHeight
{
    return 154.0f;
}

- (void)dealloc
{
    [self.m_TopicModel removeObserver:self forKeyPath:@"m_NickName"];
    [self.m_TopicModel removeObserver:self forKeyPath:@"m_LastReplyTime"];
    [self.m_TopicModel removeObserver:self forKeyPath:@"m_CommentCount"];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code

    [self makeCellStyle];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)makeCellStyle
{
    [self.m_ForumBgView bm_roundedRect:self.m_ForumBgView.bm_height * 0.5f];
    self.m_ForumBgView.backgroundColor = [UIColor bm_colorWithHex:0xE5ECFD];
    
    [self.m_HeaderImageView bm_roundedRect:self.m_HeaderImageView.bm_height * 0.5f];
    
    self.m_ForumLabel.textColor = [UIColor bm_colorWithHex:0x333333];
    self.m_ForumLabel.font = UI_FONT_15;
    
    [self.m_StickBgView bm_roundedRect:self.m_StickBgView.bm_height * 0.5f];
    self.m_StickBgView.backgroundColor = [UIColor bm_colorWithHex:0xE14D4D alpha:0.1];

    self.m_StickLabel.textColor = [UIColor bm_colorWithHex:0xE56767];
    self.m_StickLabel.font = UI_FONT_15;

    self.m_TitleLabel.textColor = [UIColor bm_colorWithHex:0x333333];
    self.m_TitleLabel.font = UI_FONT_16;

    self.m_TimeLabel.textColor = [UIColor bm_colorWithHex:0x999999];
    self.m_TimeLabel.font = UI_FONT_14;

    self.m_UserNameLabel.textColor = [UIColor bm_colorWithHex:0x999999];
    self.m_UserNameLabel.font = UI_FONT_14;

    self.m_CommentBtn.titleLabel.font = UI_FONT_12;
    [self.m_CommentBtn setTitleColor:[UIColor bm_colorWithHex:0x999999] forState:UIControlStateNormal];
    //[self.m_CommentBtn bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageLeft imageTitleGap:5.0f];
    
    CGRect underLineFrame = CGRectMake(15.0f, self.contentView.bm_height-1, UI_SCREEN_WIDTH-30.0f, 1);
    self.m_UnderLineView = [[BMSingleLineView alloc] initWithFrame:underLineFrame];
    self.m_UnderLineView.lineColor = UI_DEFAULT_LINECOLOR;
    [self.contentView addSubview:self.m_UnderLineView];
}

- (void)setM_TopicModel:(FSTopicModel *)topicModel
{
    [self.m_TopicModel removeObserver:self forKeyPath:@"m_NickName"];
    [self.m_TopicModel removeObserver:self forKeyPath:@"m_LastReplyTime"];
    [self.m_TopicModel removeObserver:self forKeyPath:@"m_CommentCount"];

    _m_TopicModel = topicModel;
    
    [self.m_TopicModel addObserver:self forKeyPath:@"m_NickName" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.m_TopicModel addObserver:self forKeyPath:@"m_LastReplyTime" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.m_TopicModel addObserver:self forKeyPath:@"m_CommentCount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 最后回复人
    if ([keyPath isEqualToString:@"m_NickName"])
    {
        NSDecimalNumber *oldValue = [change objectForKey:NSKeyValueChangeOldKey];
        NSDecimalNumber *newValue = [change objectForKey:NSKeyValueChangeNewKey];
        
        if (![oldValue bm_isValided] || [oldValue compare:newValue] != NSOrderedSame)
        {
            self.m_UserNameLabel.text = self.m_TopicModel.m_NickName;
        }
    }
    // 最后回复时间
    else if ([keyPath isEqualToString:@"m_LastReplyTime"])
    {
        NSUInteger oldValue = [change bm_doubleForKey:NSKeyValueChangeOldKey];
        NSUInteger newValue = [change bm_doubleForKey:NSKeyValueChangeNewKey];
        
        if (oldValue != newValue)
        {
            self.m_TimeLabel.text = [NSDate fsStringDateFromTs:self.m_TopicModel.m_LastReplyTime];
            CGSize size = [self.m_TimeLabel sizeThatFits:CGSizeMake(1000, self.m_TimeLabel.bm_height)];
            self.m_UserNameLabel.bm_left = size.width + 6.0f;
        }
    }
    // 评论数
    else if ([keyPath isEqualToString:@"m_CommentCount"])
    {
        NSUInteger oldValue = [change bm_uintForKey:NSKeyValueChangeOldKey];
        NSUInteger newValue = [change bm_uintForKey:NSKeyValueChangeNewKey];
        
        if (oldValue != newValue)
        {
            [self.m_CommentBtn setTitle:[NSString stringWithFormat:@"%@", @(self.m_TopicModel.m_CommentCount)] forState:UIControlStateNormal];
        }
    }
}

- (void)drawCellWithModel:(FSTopicModel *)model
{
    self.m_TopicModel = model;
    
    [self.m_HeaderImageView sd_setImageWithURL:[model.m_IconUrl bm_toURL] placeholderImage:[UIImage imageNamed:@"default_avataricon"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    
    self.m_ForumLabel.text = model.m_ForumName;
    CGSize size = [self.m_ForumLabel sizeThatFits:CGSizeMake(1000, self.m_ForumLabel.bm_height)];
    self.m_ForumLabel.bm_width = size.width;
    self.m_ForumBgView.bm_width = self.m_ForumLabel.bm_right + 12.0f;
    
    self.m_TitleLabel.text = model.m_Title;
//    size = [self.m_TitleLabel sizeThatFits:CGSizeMake(self.m_TitleLabel.bm_width, 1000)];
//    self.m_TitleLabel.bm_height = size.height;
    
    self.m_TimeLabel.text = [NSDate fsStringDateFromTs:model.m_CreateTime];
    // 最后回复时间不为空，显示
    if (model.m_LastReplyTime != 0)
    {
        self.m_TimeLabel.text = [NSDate fsStringDateFromTs:model.m_LastReplyTime];
    }
    size = [self.m_TimeLabel sizeThatFits:CGSizeMake(1000, self.m_TimeLabel.bm_height)];
    self.m_UserNameLabel.bm_left = size.width + 6.0f;

    self.m_UserNameLabel.text = model.m_NickName;
    [self.m_CommentBtn setTitle:[NSString stringWithFormat:@"%@", @(model.m_CommentCount)] forState:UIControlStateNormal];
    self.m_StickBgView.hidden = !model.m_TopFlag;
    
    self.m_UnderLineView.hidden = self.m_TopicModel.m_PositionType & BMTableViewCell_PositionType_Last;
}

@end
