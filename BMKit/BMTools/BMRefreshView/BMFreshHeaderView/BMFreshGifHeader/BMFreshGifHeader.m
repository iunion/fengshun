//
//  BMFreshGifHeader.m
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshGifHeader.h"

@interface BMFreshGifHeader ()

@property (nonatomic, weak) UIImageView *gifImageView;

// 所有状态对应的动画图片
@property (strong, nonatomic) NSMutableDictionary *stateImages;
// 所有状态对应的动画时间
@property (strong, nonatomic) NSMutableDictionary *stateDurations;

@end

@implementation BMFreshGifHeader

- (NSMutableDictionary *)stateImages
{
    if (!_stateImages)
    {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations
{
    if (!_stateDurations)
    {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

- (void)setImages:(NSArray *)images forState:(BMFreshState)state
{
    [self setImages:images duration:images.count * 0.1f forState:state];
}

- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(BMFreshState)state
{
    if (![images bm_isNotEmpty])
    {
        return;
    }
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
}

- (void)prepare
{
    [super prepare];
    
    self.containerSize = CGSizeMake(32.0f, 32.0f);
}

- (void)makeGifImageView
{
    UIImageView *gifImageView = [[UIImageView alloc] init];
    [self.containerView addSubview:gifImageView];
    
    self.gifImageView = gifImageView;
}

- (void)makeSubviews
{
    [super makeSubviews];
    
    [self makeGifImageView];
}

- (void)freshSubviews
{
    [super freshSubviews];
    
    self.gifImageView.frame = CGRectMake(0, 0, self.containerSize.width, self.containerSize.height);
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    NSArray *images = self.stateImages[@(BMFreshStateIdle)];
    if (self.freshState != BMFreshStateIdle || images.count == 0)
    {
        return;
    }
    
    // 停止动画
    [self.gifImageView stopAnimating];
    
    NSUInteger index = 0;
    // 设置当前需要显示的图片
    if (self.pullingPercent >= 0.2f)
    {
        index = images.count * (self.pullingPercent-0.2f)*(1/0.8f);
        if (index >= images.count)
        {
            index = images.count - 1;
        }
    }
    self.gifImageView.image = images[index];
}

- (void)freshStateWillRefresh
{
    [self startAnimation:BMFreshStateWillRefresh];
    
    [super freshStateWillRefresh];
}

- (void)freshStateRefreshing
{
    [self startAnimation:BMFreshStateRefreshing];
    
    [super freshStateRefreshing];
}

- (void)startAnimation:(BMFreshState)state
{
    [self.gifImageView stopAnimating];
    
    NSArray *images = self.stateImages[@(state)];
    if (images.count == 1)
    { // 单张图片
        self.gifImageView.image = [images lastObject];
    }
    else
    { // 多张图片
        self.gifImageView.animationImages = images;
        self.gifImageView.animationDuration = [self.stateDurations[@(state)] doubleValue];
        [self.gifImageView startAnimating];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.scrollView.isDragging && self.stretchableWillRefresh)
    {
        if (self.freshState == BMFreshStateWillRefresh && self.scrollView.contentOffset.y < - self.pullMaxHeight)
        {
            self.gifImageView.bm_top = self.scrollView.contentOffset.y;
            self.gifImageView.bm_height = self.containerSize.height - self.scrollView.contentOffset.y;
        }
        else
        {
            self.gifImageView.bm_top = 0;
            self.gifImageView.bm_height = self.containerSize.height;
        }
    }
}

@end
