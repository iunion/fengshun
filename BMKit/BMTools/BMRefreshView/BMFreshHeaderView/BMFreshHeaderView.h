//
//  BMFreshHeaderView.h
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMFreshHeaderView : BMFreshBaseView

// 上一次下拉刷新成功的时间
@property (nullable, nonatomic, strong, readonly) NSDate *lastUpdatedTime;

// 向上偏移距离
@property (nonatomic, assign) CGFloat topOffset;

@end

NS_ASSUME_NONNULL_END
