//
//  BMFreshDotHeader.h
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshContainerHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMFreshDotHeader : BMFreshContainerHeaderView

// 不要修改containerSize 使用dotDiameter，dotGap设置
// 请注意未做冲突判断
// 圆点直径
@property (nonatomic, assign) CGFloat dotDiameter;
// 圆点间距
@property (nonatomic, assign) CGFloat dotGap;

// 拖动时颜色
@property (nonatomic, strong) UIColor *dotNormalColor;
// 刷新颜色
@property (nonatomic, strong) UIColor *dotRefreshColor;

@end

NS_ASSUME_NONNULL_END
