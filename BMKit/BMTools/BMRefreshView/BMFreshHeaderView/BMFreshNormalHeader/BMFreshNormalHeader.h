//
//  BMFreshNormalHeader.h
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshContainerHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMFreshNormalHeader : BMFreshContainerHeaderView

@property (nonatomic, weak, readonly) UIImageView *arrowImageView;

// 菊花的样式
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@end

NS_ASSUME_NONNULL_END
