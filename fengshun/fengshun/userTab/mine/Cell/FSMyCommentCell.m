//
//  FSMyCommentCell.m
//  fengshun
//
//  Created by best2wa on 2018/9/25.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMyCommentCell.h"
#import "NSDate+BMCategory.h"


@interface FSMyCommentCell()
@property (weak, nonatomic) IBOutlet UILabel *m_TimeLab;

@property (weak, nonatomic) IBOutlet UIButton *m_CommentBtn;
@property (weak, nonatomic) IBOutlet UILabel *m_ContentLab;
@property (weak, nonatomic) IBOutlet UILabel *m_TitleLab;


@end

@implementation FSMyCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showWithCommentModel:(FSCommentListModel *)model
{
    self.m_TimeLab.text = [NSDate bm_stringFromTs:model.m_CreateTime formatter:@"MM-dd"];
//    self.m_CommentBtn setTitle:model. forState:<#(UIControlState)#>
    self.m_ContentLab.text = model.m_CommentContent;
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
    [atrString bm_setFont:[UIFont systemFontOfSize:10.0f]];
    self.m_TitleLab.attributedText = atrString;
}

@end
