//
//  FSPlateDetailListTableViewCell.h
//  fengshun
//
//  Created by best2wa on 2018/9/3.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSForumDetailListTableViewCell : UITableViewCell
// 帖子标题
@property (weak, nonatomic) IBOutlet UILabel *m_TitleLab;
// 发帖时间
@property (weak, nonatomic) IBOutlet UILabel *m_TimeLab;
// 发帖人
@property (weak, nonatomic) IBOutlet UILabel *m_UsernameLab;
// 置顶View
@property (weak, nonatomic) IBOutlet UIView *m_StickView;
// 评论按钮
@property (weak, nonatomic) IBOutlet UIButton *m_CommentBtn;


@end
