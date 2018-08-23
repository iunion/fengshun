//
//  BMEmptyView.m
//  DJTableFreshViewSample
//
//  Created by ILLA on 2018/8/9.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import "BMEmptyView.h"


@interface BMEmptyView ()

// 静态区域
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic ,strong) UILabel *messageLabel;
@property (nonatomic ,strong) UIActivityIndicatorView *indecator;

@property (nonatomic ,strong) UIView *customView;

// 交互区   刷新按钮或者全视图点击刷新
@property (nonatomic ,strong) UIButton *freshButton;
@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic ,strong) UITapGestureRecognizer *tapGesture;

// data
@property (nonatomic, assign) BMEmptyViewStatus emptyViewStatus;
@property (nonatomic, copy) BMEmptyViewActionBlock actionBlock;

@end

@implementation BMEmptyView

+ (instancetype)EmptyViewWith:(UIView *)superView
                        frame:(CGRect)frame
                 refreshBlock:(BMEmptyViewActionBlock)block
{
    BMEmptyView *empty = [[BMEmptyView alloc] initWithFrame:frame];
    [superView addSubview:empty];
    
    [empty initWithRefreshBlock:block];
    
    return empty;
}


- (void)initWithRefreshBlock:(BMEmptyViewActionBlock)block
{
    self.actionBlock = block;
    
    [self buildUI];
    
    // 默认全局点击刷新操作，隐藏刷新按钮
    [self setFullViewTapEnable:YES];
}

- (void)buildUI
{
    _imageView = [UIImageView new];
    [self addSubview:_imageView];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    _messageLabel.font = [UIFont systemFontOfSize:16];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_messageLabel];
    
    _indecator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    _indecator.hidesWhenStopped = YES;
    [self addSubview:_indecator];

    // 全视图点击刷新功能
    _refreshLabel = [[UILabel alloc] init];
    _refreshLabel.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    _refreshLabel.font = [UIFont systemFontOfSize:14];
    _refreshLabel.textAlignment = NSTextAlignmentCenter;
    _refreshLabel.text = @"轻点屏幕即可刷新重试";
    [self addSubview:_refreshLabel];

    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshAction:)];
    [self addGestureRecognizer:self.tapGesture];
    
    // 刷新按钮
    _freshButton = [[UIButton alloc] init];
    [_freshButton setTitle:@"刷新" forState:UIControlStateNormal];
    [_freshButton addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_freshButton];
}

- (void)refreshAction:(id)sender
{
    if (self.actionBlock)
    {
        self.actionBlock(self, self.emptyViewStatus);
    }
}

- (void)setEmptyViewStatus:(BMEmptyViewStatus)status
{
    self.hidden = (status == BMEmptyViewStatus_Hidden)? YES:NO;
    
    if (status != BMEmptyViewStatus_Loading && _indecator.isAnimating)
    {
        [_indecator stopAnimating];
    }
    
    switch (status)
    {
        case BMEmptyViewStatus_Loading:
            [_indecator startAnimating];
            [self setImageView:YES messageView:YES customView:YES];
            break;
        case BMEmptyViewStatus_NoData:
        case BMEmptyViewStatus_NetworkError:
        case BMEmptyViewStatus_DataError:
        case BMEmptyViewStatus_UnknownError:
            [self setImageView:NO messageView:NO customView:YES];
            break;
        case BMEmptyViewStatus_Custom:
            [self setImageView:YES messageView:YES customView:NO];
            break;
        default:
            [self setImageView:YES messageView:YES customView:YES];
            break;
    }
    
    _messageLabel.text = [self messsageWithStatus:status];
    _imageView.image = [UIImage imageNamed:[self imageNameWithStatus:status]];
    
    [self updateViewFrame];
    
    self.emptyViewStatus = status;
}

- (void)setImageView:(BOOL)hidden0 messageView:(BOOL)hidden1 customView:(BOOL)hidden2
{
    _imageView.hidden = hidden0;
    _messageLabel.hidden = hidden1;
    _customView.hidden = hidden2;
}

- (void)updateViewFrame
{
    CGSize size = _imageView.image.size;
    _imageView.frame = CGRectMake((self.frame.size.width - size.width)/2, (self.frame.size.height - size.height)/2, size.width, size.height);
    
    // 没导入cgreat
//    _messageLabel.frame
    
}

- (NSString *)messsageWithStatus:(BMEmptyViewStatus)status
{
    switch (status)
    {
        case BMEmptyViewStatus_NoData:
            return @"您还没有XXX，快去创建吧";
        case BMEmptyViewStatus_NetworkError:
            return @"网络连接异常，请检查网络";
        case BMEmptyViewStatus_DataError:
            return @"数据错误请稍后再试";
        case BMEmptyViewStatus_UnknownError:
            return @"发生未知错误";
        default:
            return nil;
    }
}

- (NSString *)imageNameWithStatus:(BMEmptyViewStatus)status
{
    switch (status)
    {
        case BMEmptyViewStatus_NoData:
            return @"load_no_data";
        case BMEmptyViewStatus_NetworkError:
            return @"load_network_error";
        case BMEmptyViewStatus_DataError:
            return @"load_unknown_error";
        case BMEmptyViewStatus_UnknownError:
            return @"load_unknown_error";
        default:
            return nil;
    }
}

- (void)setFullViewTapEnable:(BOOL)enable
{
    self.tapGesture.enabled = enable;
    self.refreshLabel.hidden = !self.tapGesture.enabled;
    self.freshButton.hidden = enable;
}

@end
