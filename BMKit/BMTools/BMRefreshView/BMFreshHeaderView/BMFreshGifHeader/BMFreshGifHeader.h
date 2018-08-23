//
//  BMFreshGifHeader.h
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshContainerHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMFreshGifHeader : BMFreshContainerHeaderView

@property (nonatomic, weak, readonly) UIImageView *gifImageView;
@property (nonatomic, assign) BOOL stretchableWillRefresh;

// 设置state状态下的动画图片images
- (void)setImages:(NSArray *)images forState:(BMFreshState)state;
// 动画持续总时间duration
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(BMFreshState)state;

@end

NS_ASSUME_NONNULL_END
