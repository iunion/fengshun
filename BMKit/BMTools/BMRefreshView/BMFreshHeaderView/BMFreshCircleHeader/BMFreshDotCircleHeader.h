//
//  BMFreshDotCircleHeader.h
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshContainerHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMFreshDotCircleHeader : BMFreshContainerHeaderView

// 动画时间
@property (nonatomic, assign) CGFloat animationDuration;

// 前景颜色
@property (nonatomic, strong) UIColor *coverStartColor;
@property (nonatomic, strong) UIColor *coverEndColor;

// 不要修改containerSize 使用circleRadius设置
// 请注意未做冲突判断
// 圆环半径
@property (nonatomic, assign) CGFloat circleRadius;

@end

NS_ASSUME_NONNULL_END
