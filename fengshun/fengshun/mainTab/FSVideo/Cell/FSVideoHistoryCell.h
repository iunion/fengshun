//
//  FSVideoHistoryCell.h
//  fengshun
//
//  Created by ILLA on 2018/9/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVideoMediateModel.h"

@interface FSVideoHistoryCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) FSVideoRecordModel *model;
@end
