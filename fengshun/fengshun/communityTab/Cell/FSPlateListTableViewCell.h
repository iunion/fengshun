//
//  FSPlateListTableViewCell.h
//  fengshun
//
//  Created by best2wa on 2018/8/31.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSPlateListTableViewCell : UITableViewCell
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
