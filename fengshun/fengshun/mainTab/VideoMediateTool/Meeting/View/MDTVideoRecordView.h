//
//  MDTVideoRecordView.h
//  ODR
//
//  Created by DH on 2018/9/12.
//  Copyright © 2018年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCallModel.h"

@protocol MDTVideoRecordCellDelegate;
@interface MDTVideoRecordCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, weak) id <MDTVideoRecordCellDelegate> delegate;
- (void)setModel:(MDTVideoRecordModel *)model;
@end


@protocol MDTVideoRecordCellDelegate <NSObject>
- (void)videoRecordCell:(MDTVideoRecordCell *)cell playBtnDidClick:(UIButton *)btn;
@end
