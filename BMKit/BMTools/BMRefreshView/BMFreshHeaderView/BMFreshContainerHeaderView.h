//
//  BMFreshContainerHeaderView.h
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMFreshContainerHeaderView : BMFreshHeaderView


@property (nonatomic, weak, readonly) UIView *containerView;
@property (nonatomic, weak, readonly) UILabel *messageLabel;

// 方形size
@property (nonatomic, assign) CGSize containerSize;

// 文字与图片间距
@property (nonatomic, assign) CGFloat containerLabelGap;
// 整体左边偏移间距
@property (nonatomic, assign) CGFloat containerXOffset;
// 整体上边偏移间距
@property (nonatomic, assign) CGFloat containerYOffset;


@end

NS_ASSUME_NONNULL_END
