//
//  VideoMediateListCell.h
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVideoMediateModel.h"

@protocol FSVideoMediateListCellDelegate;

@interface FSVideoMediateListCell : UITableViewCell

@property (nonatomic, strong) UIView *m_BGView;

@property (nonatomic, strong) FSMeetingDetailModel *model;

@property (weak, nonatomic) id<FSVideoMediateListCellDelegate> delegate;

@end


@protocol FSVideoMediateListCellDelegate <NSObject>
- (void)didDeleteVideoMediate:(FSVideoMediateListCell *)cell;
@end
