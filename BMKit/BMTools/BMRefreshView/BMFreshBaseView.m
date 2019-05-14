//
//  BMFreshBaseView.m
//  FengTiaoYuShun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 BMSoft. All rights reserved.
//

#import "BMFreshBaseView.h"

NSString *const DJFreshKeyPathContentOffset = @"contentOffset";
NSString *const DJFreshKeyPathContentSize = @"contentSize";
NSString *const DJFreshKeyPathContentInset = @"contentInset";
NSString *const DJFreshKeyPathPanState = @"state";

@interface BMFreshBaseView()

@property (strong, nonatomic) UIPanGestureRecognizer *pan;
// 所有状态对应的文字
@property (nonatomic, strong) NSMutableDictionary *stateTitles;

@end

@implementation BMFreshBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // 准备UI
        [self prepare];
        
        // 默认是普通状态
        self.freshState = BMFreshStateIdle;
    }
    
    return self;
}

- (void)prepare
{
    // 基本属性
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    
    self.stateTitles = [[NSMutableDictionary alloc] init];
}

// 需要子类自行创建
- (void)makeSubviews
{
    // 添加subView
}

- (void)freshSubviews
{
    // 刷新subView
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self freshSubviews];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]])
    {
        return;
    }
    
    [self removeObservers];
    
    if (!newSuperview)
    {
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.x = 0;
    frame.size.width = newSuperview.bounds.size.width;
    self.frame = frame;
    
    // 记录UIScrollView
    _scrollView = (UIScrollView *)newSuperview;
    // 设置永远支持垂直弹簧效果
    _scrollView.alwaysBounceVertical = YES;
    // 记录UIScrollView最开始的contentInset
    _scrollViewOriginalInset = self.scrollView.contentInset;
    //LLog(@"scrollViewInset : %@", @(_m_ScrollViewOriginalInset.top));
    
    [self addObservers];
    
    [self makeSubviews];
}

#pragma mark - KVO监听

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:DJFreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:DJFreshKeyPathContentSize];;
    [self.pan removeObserver:self forKeyPath:DJFreshKeyPathPanState];
    self.pan = nil;
}

- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:DJFreshKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:DJFreshKeyPathContentSize options:options context:nil];
    //[self.m_ScrollView addObserver:self forKeyPath:DJFreshKeyPathContentInset options:options context:nil];
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:DJFreshKeyPathPanState options:options context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled)
    {
        return;
    }
    
    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:DJFreshKeyPathContentSize])
    {
        [self scrollViewContentSizeDidChange:change];
    }
    
    // 看不见
    if (self.hidden)
    {
        return;
    }
    
    if ([keyPath isEqualToString:DJFreshKeyPathContentOffset])
    {
        [self scrollViewContentOffsetDidChange:change];
    }
    else if ([keyPath isEqualToString:DJFreshKeyPathContentInset])
    {
        [self scrollViewContentInsetDidChange:change];
    }
    else if ([keyPath isEqualToString:DJFreshKeyPathPanState])
    {
        [self scrollViewPanStateDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    //LLog(@"scrollViewContentOffsetDidChange");
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    //LLog(@"scrollViewContentSizeDidChange");
}

- (void)scrollViewContentInsetDidChange:(NSDictionary *)change
{
    //LLog(@"scrollViewContentInsetDidChange");
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    //LLog(@"scrollViewPanStateDidChange");
}


#pragma mark - 刷新状态控制

- (void)setFreshState:(BMFreshState)freshState
{
    _freshState = freshState;
    
    // 加入主队列的目的是等setState:方法调用完毕、设置完文字后再去布局子控件
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsLayout];
    });
}

- (void)freshStateError
{
    if ((self.delegate && [self.delegate respondsToSelector:@selector(freshView:changeState:)]) || self.freshStateBlock)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(freshView:changeState:)])
        {
            [self.delegate freshView:self changeState:BMFreshStateError];
        }
        if (self.freshStateBlock)
        {
            self.freshStateBlock(self, BMFreshStateError);
        }
    }
    else
    {
        self.freshState = BMFreshStateIdle;
    }
}

- (void)freshStateIdle
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(freshView:changeState:)])
    {
        [self.delegate freshView:self changeState:BMFreshStateIdle];
    }
    if (self.freshStateBlock)
    {
        self.freshStateBlock(self, BMFreshStateIdle);
    }
}

- (void)freshStateWillRefresh
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(freshView:changeState:)])
    {
        [self.delegate freshView:self changeState:BMFreshStateWillRefresh];
    }
    if (self.freshStateBlock)
    {
        self.freshStateBlock(self, BMFreshStateWillRefresh);
    }
}

- (void)freshStateRefreshing
{
    //self.pullingPercent = 1.0f;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(freshView:changeState:)])
    {
        [self.delegate freshView:self changeState:BMFreshStateRefreshing];
    }
    if (self.freshStateBlock)
    {
        self.freshStateBlock(self, BMFreshStateRefreshing);
    }
}

- (void)freshStateNoMoreData
{
    if ((self.delegate && [self.delegate respondsToSelector:@selector(freshView:changeState:)]) || self.freshStateBlock)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(freshView:changeState:)])
        {
            [self.delegate freshView:self changeState:BMFreshStateNoMoreData];
        }
        if (self.freshStateBlock)
        {
            self.freshStateBlock(self, BMFreshStateNoMoreData);
        }
    }
    else
    {
        self.freshState = BMFreshStateNoMoreData;
    }
}

// 进入刷新状态
- (void)beginReFreshing
{
    self.pullingPercent = 1.0f;
    
    // 只要正在刷新，就完全显示
    if (self.window)
    {
        self.freshState = BMFreshStateRefreshing;
        
        if (self.beginFreshingBlock)
        {
            self.beginFreshingBlock(self);
        }
    }
    else
    {
        // 预防正在刷新中时，调用本方法使得header inset回置失败
        if (self.freshState != BMFreshStateRefreshing)
        {
            self.freshState = BMFreshStateWillRefresh;
            // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
            [self setNeedsDisplay];
        }
    }
}

// 结束刷新状态
- (void)endReFreshing
{
    dispatch_async(dispatch_get_main_queue(), ^{
        BMFreshState oldState = self.freshState;
        self.freshState = BMFreshStateIdle;
        
        if (oldState == BMFreshStateRefreshing && self.endFreshingBlock)
        {
            self.endFreshingBlock(self);
        }
    });
}

- (BOOL)isReFreshing
{
    return self.freshState == BMFreshStateRefreshing;
}

- (void)setAutomaticallyChangeAlpha:(BOOL)automaticallyChangeAlpha
{
    _automaticallyChangeAlpha = automaticallyChangeAlpha;
    
    if (self.isReFreshing)
    {
        return;
    }
    
    if (automaticallyChangeAlpha)
    {
        self.alpha = self.pullingPercent;
    }
    else
    {
        self.alpha = 1.0f;
    }
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    if (pullingPercent > 1.0f)
    {
        pullingPercent = 1.0f;
    }
    
    _pullingPercent = pullingPercent;
    
    if (self.isReFreshing)
    {
        return;
    }
    
    if (self.isAutomaticallyChangeAlpha)
    {
        self.alpha = pullingPercent;
    }
}

- (void)setFreshTitle:(id)title forState:(BMFreshState)state
{
    if ([title bm_isNotEmpty])
    {
        self.stateTitles[@(state)] = title;
    }
    
    [self setNeedsLayout];
}

- (void)setFreshTitles:(NSDictionary *)titles
{
    if ([titles bm_isNotEmpty])
    {
        self.stateTitles = [NSMutableDictionary dictionaryWithDictionary:titles];
    }
    else
    {
        self.stateTitles = [[NSMutableDictionary alloc] init];
    }
    
    [self setNeedsLayout];
}

+ (CGFloat)zoomFloatData:(CGFloat)data fromMin:(CGFloat)fromMin fromMax:(CGFloat)fromMax toMin:(CGFloat)toMin toMax:(CGFloat)toMax
{
    return (data-fromMin)*(toMax-toMin)/(fromMax-fromMin)+toMin;
}

@end
