//
//  DJFreshBackNormalFooter.h
//  DJTableFreshViewSample
//
//  Created by jiang deng on 2018/7/26.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import "BMFreshBackContainerFooterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMFreshBackNormalFooter : BMFreshBackContainerFooterView

@property (nonatomic, weak, readonly) UIImageView *arrowImageView;

// 菊花的样式
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@end

NS_ASSUME_NONNULL_END
