//
//  BMFreshFiveStarHeader.h
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshContainerHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMFreshFiveStarHeader : BMFreshContainerHeaderView

// 前景颜色
@property (nonatomic, strong) UIColor *coverColor;

// 不要修改containerSize 使用sideLength设置
// 请注意未做冲突判断
// 五角星区域正方形边长
@property (nonatomic, assign) CGFloat starWidth;

@end

NS_ASSUME_NONNULL_END
