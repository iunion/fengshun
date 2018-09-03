//
//  FSCommunityListTableViewCell.h
//  fengshun
//
//  Created by best2wa on 2018/8/31.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSCommunityListTableViewCell : UITableViewCell
// 头像&&分类标题父视图
@property (weak, nonatomic) IBOutlet UIView *m_categoryView;
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *m_headerImgView;
// 分类标题
@property (weak, nonatomic) IBOutlet UILabel *m_categoryLab;
// 内容标题
@property (weak, nonatomic) IBOutlet UILabel *m_titleLab;
// 帖子发布时间
@property (weak, nonatomic) IBOutlet UILabel *m_timeLab;
// 用户名
@property (weak, nonatomic) IBOutlet UILabel *m_userNameLab;
// 评论按钮
@property (weak, nonatomic) IBOutlet UIButton *m_commentBtn;

@end
