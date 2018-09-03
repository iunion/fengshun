//
//  FSCourseTableCell.h
//  fengshun
//
//  Created by Aiwei on 2018/8/31.
//  Copyright © 2018 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COURSE_CELL_HEGHT 142.0f

@interface FSCourseTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *m_imageView;
@property (weak, nonatomic) IBOutlet UILabel *m_title;
@property (weak, nonatomic) IBOutlet UILabel *m_subTitle;
@property (weak, nonatomic) IBOutlet UILabel *m_readCount;

@end
