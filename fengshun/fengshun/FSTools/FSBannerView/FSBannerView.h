//
//  DJBannerView.h
//  DJBannerViewSample
//
//  Created by dengjiang on 16/6/2.
//  Copyright © 2016年 DJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSBannerViewDefine.h"


@interface FSBannerView : UIView

@property (nullable, nonatomic, weak) id <FSBannerViewDelegate> delegate;

// scrollView滚动的方向
@property (nonatomic, assign) FSBannerViewScrollDirection scrollDirection;

// 滚动间隔
@property (nonatomic, assign) NSTimeInterval rollingDelayTime;

@property (nullable, nonatomic, strong) UIImage *placeholderImage;


- (nonnull instancetype)initWithFrame:(CGRect)frame scrollDirection:(FSBannerViewScrollDirection)direction images:(nullable NSArray *)images;

// 刷新数据
- (void)reloadBannerWithData:(nonnull NSArray *)images;
// 设置圆角
- (void)setCorner:(NSInteger)cornerRadius;
// 设置PageControl类型
- (void)setPageControlStyle:(FSBannerViewPageStyle)pageStyle;

// 解决切换View滚动停止问题，会导致重新开始pageIndex
- (void)refreshRolling;

// 开始滚动
- (void)startRolling;
// 停止滚动
- (void)stopRolling;

// 是否显示关闭按钮
- (void)setShowClose:(BOOL)show;

@end

