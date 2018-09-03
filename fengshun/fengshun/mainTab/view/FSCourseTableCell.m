//
//  FSCourseTableCell.m
//  fengshun
//
//  Created by Aiwei on 2018/8/31.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSCourseTableCell.h"


@implementation FSCourseTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 19);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
