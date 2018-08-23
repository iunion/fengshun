//
//  BMTableViewSegmentCell.h
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2018/1/17.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "BMTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMTableViewSegmentCell : BMTableViewCell

@property (nonatomic, strong, readonly) UISegmentedControl *segmentView;

@end

NS_ASSUME_NONNULL_END

