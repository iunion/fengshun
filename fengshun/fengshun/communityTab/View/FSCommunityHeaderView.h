//
//  FSCommunityHeaderView.h
//  fengshun
//
//  Created by best2wa on 2018/9/3.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCommunityModel.h"

@class FSCommunityHeaderView;

@protocol FSCommunityHeaderViewDelegate <NSObject>

@optional

- (void)followForumAction:(FSCommunityHeaderView *)aView;

@end

@interface FSCommunityHeaderView : UIView
// 背景图
@property (weak, nonatomic) IBOutlet UIImageView *m_HeaderBGView;
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *m_UserHeaderImgView;
// 分类标题
@property (weak, nonatomic) IBOutlet UILabel *m_CategoryTitleLab;
// 标题
@property (weak, nonatomic) IBOutlet UILabel *m_TitleLab;
// 关注数
@property (weak, nonatomic) IBOutlet UILabel *m_AttentionNumLab;
// 帖子数
@property (weak, nonatomic) IBOutlet UILabel *m_PostNumLab;
// 关注按钮
@property (weak, nonatomic) IBOutlet UIButton *m_AttentionBtn;

@property(nonatomic, weak) id <FSCommunityHeaderViewDelegate> delegate;

- (void)updateHeaderViewWith:(FSForumModel *)aModel;


@end

