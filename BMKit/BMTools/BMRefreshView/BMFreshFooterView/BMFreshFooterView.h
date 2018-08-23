//
//  BMFreshFooterView.h
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMFreshFooterView : BMFreshBaseView

// 向下偏移距离
@property (nonatomic, assign) CGFloat bottomOffset;

- (void)endReFreshingWithNoMoreData;

@end

NS_ASSUME_NONNULL_END
