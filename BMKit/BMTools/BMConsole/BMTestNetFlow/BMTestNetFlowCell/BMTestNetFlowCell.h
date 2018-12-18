//
//  BMTestNetFlowCell.h
//  fengshun
//
//  Created by jiang deng on 2018/12/13.
//  Copyright © 2018 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMTestNetFlowHttpModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMTestNetFlowCell : UITableViewCell

@property (nonatomic, strong, readonly) BMTestNetFlowHttpModel *httpModel;

- (void)drawCellWithModel:(BMTestNetFlowHttpModel *)model;

+ (CGFloat)cellHeightWithModel:(BMTestNetFlowHttpModel *)model;

@end

NS_ASSUME_NONNULL_END
