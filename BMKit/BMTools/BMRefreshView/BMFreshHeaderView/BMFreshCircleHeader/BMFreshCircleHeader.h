//
//  BMFreshCircleHeader.h
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshContainerHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMFreshCircleHeader : BMFreshContainerHeaderView

// 是否缺口
@property (nonatomic, assign) BOOL isSemiCircle;

// 动画时间
@property (nonatomic, assign) CGFloat animationDuration;

// 背景颜色
@property (nonatomic, strong) UIColor *shadowColor;
// 前景颜色
@property (nonatomic, strong) UIColor *coverColor;

// 不要修改containerSize 使用circleRadius设置
// 请注意未做冲突判断
// 圆环半径
@property (nonatomic, assign) CGFloat circleRadius;

// 是否显示背景
@property (nonatomic, assign) BOOL isShowShadow;

@end

NS_ASSUME_NONNULL_END
