//
//  FSPlateListTableViewCell.m
//  fengshun
//
//  Created by best2wa on 2018/8/31.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSForumListCell.h"
#import "UIImageView+WebCache.h"
#import "FSApiRequest.h"

@interface FSForumListCell ()
// 图片
@property (weak, nonatomic) IBOutlet UIImageView *m_ImgView;
// 帖子标题
@property (weak, nonatomic) IBOutlet UILabel *m_TitleLab;
// 帖子内容
@property (weak, nonatomic) IBOutlet UILabel *m_ContentLab;
// 关注人数
@property (weak, nonatomic) IBOutlet UILabel *m_AttentionNumLab;
// 帖子数
@property (weak, nonatomic) IBOutlet UILabel *m_NoteNumLab;
// 操作按钮
@property (weak, nonatomic) IBOutlet UIButton *m_DoBtn;
@end

@implementation FSForumListCell

+ (CGFloat)cellHeight{
    return 102;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    [self makeCellStyle];
}

- (void)makeCellStyle
{
    [_m_ImgView bm_roundedRect:4];
    [_m_DoBtn bm_roundedRect:_m_DoBtn.bm_height * 0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showWithFSCommunityForumListModel:(FSForumModel *)aModel
{
    self.m_ForumModel = aModel;
    [self.m_ImgView sd_setImageWithURL:[aModel.m_IconUrlSecond bm_toURL]placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
    self.m_TitleLab.text        = aModel.m_ForumNameSecond;
    self.m_ContentLab.text      = aModel.m_Description;
    self.m_AttentionNumLab.text = [NSString stringWithFormat:@"%ld", aModel.m_AttentionCount];
    self.m_NoteNumLab.text      = [NSString stringWithFormat:@"%ld", aModel.m_PostsCount];
    self.m_DoBtn.selected       = aModel.m_AttentionFlag;
    self.m_DoBtn.backgroundColor = [UIColor bm_colorWithHexString:aModel.m_AttentionFlag?@"F5F6F7":@"4E7CF6"];
    [self.m_DoBtn setTitleColor:[UIColor bm_colorWithHexString:aModel.m_AttentionFlag?@"999999":@"ffffff"] forState:UIControlStateNormal];
    [self.m_DoBtn setTitle:aModel.m_AttentionFlag?@"已关注":@"+ 关注" forState:UIControlStateNormal];
}
- (IBAction)doFollowAction:(UIButton *)sender {
    FSForumFollowState state = self.m_ForumModel.m_AttentionFlag;
    [FSApiRequest updateFourmAttentionStateWithFourmId:self.m_ForumModel.m_Id followStatus:!state success:^(id  _Nullable responseObject) {
        self.m_ForumModel.m_AttentionFlag = !self.m_ForumModel.m_AttentionFlag;
        [self showWithFSCommunityForumListModel:self.m_ForumModel];
    } failure:^(NSError * _Nullable error) {
        
    }];
}



@end
