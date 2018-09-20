//
//  FSCollectionCourseCell.h
//  fengshun
//
//  Created by Aiwei on 2018/9/20.
//  Copyright © 2018 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCourseModel.h"

@interface FSCollectionCourseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *m_imageView;
@property (weak, nonatomic) IBOutlet UILabel *m_title;
@property (weak, nonatomic) IBOutlet UILabel *m_subTitle;
@property (weak, nonatomic) IBOutlet UILabel *m_readCount;

@property (nonatomic, strong) FSCourseModel *m_course;
@end
