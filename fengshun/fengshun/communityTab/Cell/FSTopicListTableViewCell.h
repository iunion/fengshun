//
//  FSCommunityListTableViewCell.h
//  fengshun
//
//  Created by best2wa on 2018/8/31.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSTopicListTableViewCell : UITableViewCell
// 头像&&分类标题父视图
@property (weak, nonatomic) IBOutlet UIView *m_CategoryView;
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *m_HeaderImgView;
// 分类标题
@property (weak, nonatomic) IBOutlet UILabel *m_CategoryLab;
// 标题
@property (weak, nonatomic) IBOutlet UILabel *m_TitleLab;
// 帖子发布时间
@property (weak, nonatomic) IBOutlet UILabel *m_TimeLab;
// 用户名
@property (weak, nonatomic) IBOutlet UILabel *m_UserNameLab;
// 评论按钮
@property (weak, nonatomic) IBOutlet UIButton *m_CommentBtn;
// 置顶标识view
@property (weak, nonatomic) IBOutlet UIView *m_StickView;

@end
