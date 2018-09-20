//
//  DJFreshAutoContainerFooterView.m
//  DJTableFreshViewSample
//
//  Created by jiang deng on 2018/8/7.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import "BMFreshAutoContainerFooterView.h"

@interface BMFreshAutoContainerFooterView ()

@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UILabel *messageLabel;

#if BMFRESH_SHOWPULLINGPERCENT
@property (nonatomic, weak) UILabel *pullingPercentLabel;
#endif

@end

@implementation BMFreshAutoContainerFooterView

- (UIView *)containerView
{
    if (!_containerView)
    {
        UIView *containerView = [[UIView alloc] init];
        containerView.bm_boundsSize = CGSizeMake(BMFreshDefaultContainerSize, BMFreshDefaultContainerSize);
        containerView.backgroundColor = [UIColor clearColor];
        _containerView = containerView;
        [self addSubview:containerView];
    }
    return _containerView;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithWhite:0.6f alpha:0.8f];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.numberOfLines = 0;
        label.text = BMFRESH_DEFAULT_AUTONORMALFOOTERTEXT;
        _messageLabel = label;
        [self addSubview: label];
    }
    return _messageLabel;
}

#if BMFRESH_SHOWPULLINGPERCENT
- (UILabel *)pullingPercentLabel
{
    if (!_pullingPercentLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor redColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15.0f];
        _pullingPercentLabel = label;
        [self addSubview: label];
    }
    return _pullingPercentLabel;
}
#endif

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
#if BMFRESH_SHOWPULLINGPERCENT
    self.pullingPercentLabel.text = [NSString stringWithFormat:@"%@", @(self.pullingPercent)];
#endif
}

- (void)setContainerSize:(CGSize)containerSize
{
    if (containerSize.width < 20.0f)
    {
        containerSize.width = 20.0f;
    }
    _containerSize = containerSize;
    
    [self setNeedsLayout];
}

- (void)setContainerLabelGap:(CGFloat)containerLabelGap
{
    _containerLabelGap = containerLabelGap;
    
    [self setNeedsLayout];
}

- (void)setContainerXOffset:(CGFloat)containerXOffset
{
    _containerXOffset = containerXOffset;
    
    [self setNeedsLayout];
}

- (void)setContainerYOffset:(CGFloat)containerYOffset
{
    _containerYOffset = containerYOffset;
    
    [self setNeedsLayout];
}

- (void)setFreshTitle:(id)title forState:(BMFreshState)state
{
    [super setFreshTitle:title forState:state];
    
    if (state == self.freshState)
    {
        [self setNeedsLayout];
    }
}

- (void)prepare
{
    [super prepare];
    
    self.containerSize = CGSizeMake(BMFreshDefaultContainerSize, BMFreshDefaultContainerSize);
    self.containerLabelGap = BMFreshDefaultContainerLabelGap;
    self.containerXOffset = 0;
    self.containerYOffset = 0;

    [self setFreshTitle:BMFRESH_DEFAULT_AUTONORMALFOOTERTEXT forState:BMFreshStateIdle];
    [self setFreshTitle:BMFRESH_DEFAULT_WILLLOADFOOTERTEXT forState:BMFreshStateWillRefresh];
    [self setFreshTitle:BMFRESH_DEFAULT_LOADINGFOOTERTEXT forState:BMFreshStateRefreshing];
    [self setFreshTitle:BMFRESH_DEFAULT_NOMOREDATAFOOTERTEXT forState:BMFreshStateNoMoreData];
}

- (void)messageLabelClick
{
    if (self.freshState == BMFreshStateIdle)
    {
        [self beginReFreshing];
    }
}

- (void)makeSubviews
{
    [super makeSubviews];
    
    self.containerView.bm_width = self.containerSize.width;
    self.containerView.bm_height = self.containerSize.height;
    self.containerView.bm_left = self.bm_width * 0.5-self.containerView.bm_width-self.containerLabelGap;
    self.containerView.bm_centerY = self.bm_centerY;
    
    self.messageLabel.bm_left = self.bm_width * 0.25;
    self.messageLabel.bm_width = self.bm_width * 0.5;
    self.messageLabel.bm_height = self.bm_height;
    self.messageLabel.bm_centerY = self.bm_centerY;
    
    // 监听label点击
    self.messageLabel.userInteractionEnabled = YES;
    [self.messageLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageLabelClick)]];

#if BMFRESH_SHOWPULLINGPERCENT
    self.pullingPercentLabel.frame = CGRectMake(20, self.bm_height-24, 50, 20);
#endif
}

- (void)freshSubviews
{
    [super freshSubviews];
    
    self.containerView.bm_width = self.containerSize.width;
    self.containerView.bm_height = self.containerSize.height;
    
    // container中心点
    CGFloat containerCenterX = self.bm_width * 0.5 + self.containerXOffset;
    CGFloat containerCenterY = self.bm_height * 0.5 + self.containerYOffset;

    // 刷新文本
    CGFloat textWidth = 0;
    if ([self.stateTitles[@(self.freshState)] isKindOfClass:[NSAttributedString class]])
    {
        self.messageLabel.attributedText = self.stateTitles[@(self.freshState)];
        textWidth = [self.messageLabel bm_attribSizeToFitWidth:UI_SCREEN_WIDTH * 0.5].width;
    }
    else
    {
        self.messageLabel.text = self.stateTitles[@(self.freshState)];
        textWidth = [self.messageLabel bm_labelSizeToFitWidth:UI_SCREEN_WIDTH * 0.5].width;
    }
    
    if (textWidth)
    {
        containerCenterX = containerCenterX - (textWidth * 0.5 + self.containerLabelGap);
        self.messageLabel.bm_left = self.bm_width * 0.25 + self.containerXOffset;
        
        self.containerView.bm_centerX = containerCenterX - self.containerView.bm_width * 0.5;
    }
    else
    {
        self.containerView.bm_centerX = containerCenterX;
    }
    
    self.containerView.bm_centerY = containerCenterY;
    self.messageLabel.bm_centerY = containerCenterY;
}

- (void)setFreshState:(BMFreshState)freshState
{
    [super setFreshState:freshState];
    
    if ([self.stateTitles[@(self.freshState)] isKindOfClass:[NSAttributedString class]])
    {
        self.messageLabel.attributedText = self.stateTitles[@(self.freshState)];
    }
    else
    {
        self.messageLabel.text = self.stateTitles[@(self.freshState)];
    }
}

@end
