//
//  VideoMediateListCell.h
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVideoMediateModel.h"

@interface VideoMediateListCell : UITableViewCell

@property (nonatomic, strong) UIView *m_BGView;

@property (nonatomic, strong) VideoMediateListModel *model;

@end