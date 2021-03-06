//
//  FSMyCommentCell.h
//  fengshun
//
//  Created by best2wa on 2018/9/25.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSMyCollectionModel.h"

@interface FSMyCommentCell : UITableViewCell

@property (nonatomic, strong, readonly) FSMyCommentModel *m_Model;

+ (CGFloat)cellHeightWithContent:(NSString *)content;

- (void)drawCellWithModel:(FSMyCommentModel *)model;

@end
