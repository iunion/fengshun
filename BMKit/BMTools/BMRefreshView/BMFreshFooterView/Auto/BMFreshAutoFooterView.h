//
//  DJFreshAutoFooterView.h
//  DJTableFreshViewSample
//
//  Created by jiang deng on 2018/8/6.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import "BMFreshFooterView.h"

@interface BMFreshAutoFooterView : BMFreshFooterView

// 是否自动刷新(默认为YES)
@property (nonatomic, assign, getter=isAutomaticallyRefresh) BOOL automaticallyRefresh;

// 当满一屏后拖动时底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新)
@property (nonatomic, assign) CGFloat triggerAutomaticallyRefreshPercent;

@end
