//
//  BMApiStatusView.m
//  fengshun
//
//  Created by jiang deng on 2019/4/4.
//  Copyright © 2019 FS. All rights reserved.
//

#import "BMApiStatusView.h"
#import "UIView+BMAnimationExtensions.h"

@interface BMApiStatusView ()

@property (nonatomic, assign) BMApiStatus loadingStatus;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic ,strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *refreshLabel;

@end

@implementation BMApiStatusView

- (instancetype)initWithView:(UIView *)fatherView delegate:(id <BMApiStatusViewDelegate>)delegate
{
    NSAssert(fatherView, @"FatherView must not be nil.");
    
    if (self = [super init])
    {
        _delegate = delegate;
        
        self.backgroundColor = [UIColor bm_colorWithHex:0xF8FAFF];

        // 给view添加手势
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)];
        [self addGestureRecognizer:tapGR];
        
        [fatherView addSubview:self];
        self.frame = fatherView.bounds;

        [self makeView];
    }

    return self;
}

- (void)makeView
{
    NSUInteger imageWidth = self.bm_height * 0.5f - 30.0f;
    if (imageWidth > self.bm_width-40.0f)
    {
        imageWidth = self.bm_width-40.0f;
    }
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
    [self addSubview:self.imageView];
    self.imageView.bm_centerX = self.bm_centerX;
    self.imageView.bm_top = self.bm_centerY-imageWidth;
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageView.bm_bottom+20.0f, self.bm_width, 20.0f)];
    self.messageLabel.textColor = [UIColor bm_colorWithHex:0x999999];
    self.messageLabel.font = [UIFont systemFontOfSize:16.0f];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.messageLabel];

    self.refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.messageLabel.bm_bottom+15.0f, self.bm_width, 20.0f)];
    self.refreshLabel.textColor = [UIColor bm_colorWithHex:0xCCCCCC];
    self.refreshLabel.font = [UIFont systemFontOfSize:16.0f];
    self.refreshLabel.textAlignment = NSTextAlignmentCenter;
    self.refreshLabel.text = @"轻点屏幕即可刷新重试";
    [self addSubview:self.refreshLabel];
    
    [self hide];
}

- (void)viewDidTap:(UITapGestureRecognizer *)tap
{
    if (_refreshLabel.hidden)
    {
        return;
    }
    else
    {
        [self.imageView bm_heartbeatDuration:0.3f maxSize:1.4f durationPerBeat:0.5f completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(apiStatusViewDidTap:)])
            {
                [self.delegate apiStatusViewDidTap:self];
                [self showWithStatus:BMApiStatus_Hidden];
            }
        }];
    }
}

- (void)hide
{
    [self showWithStatus:BMApiStatus_Hidden];
}

- (void)showWithStatus:(BMApiStatus)status
{
    _loadingStatus = status;
    
    // 将当前视图带到其父视图的最上层
    [self bm_bringToFront];
    self.hidden = NO;

    switch (status)
    {
        case BMApiStatus_Hidden:
        {
            self.hidden = YES;
        }
            break;
            
        case BMApiStatus_ServerError:
        {
            [self freshWithImageName:@"empty_404icon" message:@"服务器发生未知错误" isShowRefreshLabel:YES];
        }
            break;
        case BMApiStatus_NoData:
        {
            [self freshWithImageName:@"empty_topicicon" message:@"数据为空" isShowRefreshLabel:YES];
        }
            break;
        case BMApiStatus_NetworkError:
        {
            [self freshWithImageName:@"empty_neticon" message:@"网络异常" isShowRefreshLabel:YES];
        }
            break;
            
        case BMApiStatus_UnknownError:
        {
            [self freshWithImageName:@"empty_404icon" message:@"发生未知错误" isShowRefreshLabel:YES];
        }
            break;
            
        case BMApiStatus_NoUserInteractiveHidden:
        {
            [self freshWithImageName:nil message:nil isShowRefreshLabel:YES];
        }
            break;
        case BMApiStatus_Custom:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)freshWithImageName:(NSString *)imageName message:(NSString *)message isShowRefreshLabel:(BOOL)isShow
{
    if (imageName)
    {
        self.imageView.hidden = NO;
        self.imageView.image = [UIImage imageNamed:imageName];
    }
    else
    {
        self.imageView.hidden = YES;
    }

    if (message)
    {
        self.messageLabel.hidden = NO;
        self.messageLabel.text = message;
    }
    else
    {
        self.messageLabel.hidden = YES;
    }
    
    self.refreshLabel.hidden = !isShow;
}

@end
