//
//  FSNoticeMessageCell.h
//  fengshun
//
//  Created by jiang deng on 2018/9/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSMessage.h"

@interface FSNoticeMessageCell : UITableViewCell

@property (nonatomic, strong, readonly) FSNoticeMessageModel *m_Model;

- (void)drawCellWithModel:(FSNoticeMessageModel *)model;

+ (CGFloat)cellHeight;

@end
