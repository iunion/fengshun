//
//  FSCommentMessageCell.h
//  fengshun
//
//  Created by jiang deng on 2018/9/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSMessage.h"

@interface FSCommentMessageCell : UITableViewCell

@property (nonatomic, strong, readonly) FSCommentMessageModle *m_Modle;

- (void)drawCellWithModle:(FSCommentMessageModle *)model;

+ (CGFloat)cellHeight;

@end
