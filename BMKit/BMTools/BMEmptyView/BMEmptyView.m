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
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIActivityIndicatorView *indecator;

// 交互区   刷新按钮或者全视图点击刷新
@property (nonatomic, strong) UIButton *freshButton;

@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) UIView *customBgView;

// data
@property (nonatomic, assign) BMEmptyViewType emptyViewType;
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
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
    [self addSubview:_imageView];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40.0f)];
    _messageLabel.textColor = [UIColor bm_colorWithHex:0x577EEE];
    _messageLabel.font = [UIFont systemFontOfSize:16.0f];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.numberOfLines = 0;
    [self addSubview:_messageLabel];

    _indecator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    _indecator.hidesWhenStopped = YES;
    [self addSubview:_indecator];

    // 全视图点击刷新功能
    _refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 20.0f)];
    _refreshLabel.textColor = [UIColor bm_colorWithHex:0x999999];
    _refreshLabel.font = [UIFont systemFontOfSize:14];
    _refreshLabel.textAlignment = NSTextAlignmentCenter;
    _refreshLabel.text = @"轻点屏幕即可刷新重试";
    [self addSubview:_refreshLabel];

    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshAction:)];
    [self addGestureRecognizer:self.tapGesture];
    
    // 刷新按钮
    _freshButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90.0f, 30.0f)];
    [_freshButton setTitle:@"点击重试" forState:UIControlStateNormal];
    [_freshButton bm_setTitleColor:[UIColor bm_colorWithHex:0x577EEE]];
    _freshButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_freshButton addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_freshButton];
    
    // 用户视图
    _customBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0)];
    _customBgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_customBgView];
    
    [_indecator bm_bringToFront];
}

- (void)refreshAction:(id)sender
{
    if (self.actionBlock)
    {
        self.actionBlock(self, self.emptyViewType);
    }
}

- (void)setEmptyViewLoading:(BOOL)loading
{
    if (!loading && self.indecator.isAnimating)
    {
        [self.indecator stopAnimating];
    }
    else
    {
        [self.indecator startAnimating];
    }
}

- (void)setEmptyViewActionBlock:(BMEmptyViewActionBlock)actionBlock
{
    self.actionBlock = actionBlock;
}

- (NSAttributedString *)messsageWithType:(BMEmptyViewType)type
{
    NSMutableAttributedString *atrText = nil;
    switch (type)
    {
        case BMEmptyViewType_NoData:
        {
            NSString *text = @"该页面空空如也...";
            atrText = [[NSMutableAttributedString alloc] initWithString:text];
        }
            break;
        case BMEmptyViewType_NetworkError:
        {
            NSString *text = @"网络链接暂时失败...";
            atrText = [[NSMutableAttributedString alloc] initWithString:text];
        }
            break;
        case BMEmptyViewType_SysError:
        case BMEmptyViewType_ServerError:
        case BMEmptyViewType_DataError:
        case BMEmptyViewType_UnknownError:
        {
            NSString *text = @"抱歉，页面出现问题了...";
            atrText = [[NSMutableAttributedString alloc] initWithString:text];
        }
            break;
        case BMEmptyViewType_Video:
        {
            NSString *text = @"不方便线下调解？\n赶快发起视频调解随时随地进行调解";
            atrText = [[NSMutableAttributedString alloc] initWithString:text];
            [atrText bm_setFont:[UIFont systemFontOfSize:16.0f]];
            [atrText bm_setTextColor:[UIColor bm_colorWithHex:0x999999]];
            [atrText bm_setTextColor:[UIColor bm_colorWithHex:0x577EEE] range:[text rangeOfString:@"不方便线下调解？"]];
            return atrText;
        }
        case BMEmptyViewType_Comment:
        {
            NSString *text = @"您还没有参与过评论...";
            atrText = [[NSMutableAttributedString alloc] initWithString:text];
        }
            break;
        case BMEmptyViewType_Topic:
        {
            NSString *text = @"您还没有发布过帖子...";
            atrText = [[NSMutableAttributedString alloc] initWithString:text];
        }
            break;
        case BMEmptyViewType_Search:
        {
            NSString *text = @"暂未匹配到关键词...";
            atrText = [[NSMutableAttributedString alloc] initWithString:text];
        }
            break;
        case BMEmptyViewType_CollectCASE:
        {
            NSString *text = @"您还没有收藏过案例...";
            atrText = [[NSMutableAttributedString alloc] initWithString:text];
        }
            break;
        case BMEmptyViewType_CollectSTATUTE:
        {
            NSString *text = @"您还没有收藏过法规...";
            atrText = [[NSMutableAttributedString alloc] initWithString:text];
        }
            break;
        case BMEmptyViewType_CollectPOSTS:
        {
            NSString *text = @"您还没有收藏过帖子...";
            atrText = [[NSMutableAttributedString alloc] initWithString:text];
        }
            break;
        case BMEmptyViewType_CollectDOCUMENT:
        {
            NSString *text = @"您还没有收藏过文书范本...";
            atrText = [[NSMutableAttributedString alloc] initWithString:text];
        }
            break;
        case BMEmptyViewType_Ocr:
        {
            NSString *text = @"快速扫描文件\n转换PDF文档图片轻松识别转成文字";
            atrText = [[NSMutableAttributedString alloc] initWithString:text];
            [atrText bm_setFont:[UIFont systemFontOfSize:16.0f]];
            [atrText bm_setTextColor:[UIColor bm_colorWithHex:0x999999]];
            [atrText bm_setTextColor:[UIColor bm_colorWithHex:0x577EEE] range:[text rangeOfString:@"快速扫描文件"]];
            return atrText;
        }
        case BMEmptyViewType_Custom:
        {
            if ([self.customMessage bm_isNotEmpty])
            {
                atrText = [[NSMutableAttributedString alloc] initWithString:self.customMessage];
            }
        }
            break;

        default:
            return nil;
    }
    
    [atrText bm_setFont:[UIFont systemFontOfSize:16.0f]];
    [atrText bm_setTextColor:[UIColor bm_colorWithHex:0x999999]];
    
    return atrText;
}

- (NSString *)imageNameWithType:(BMEmptyViewType)type
{
    NSString *imageName = nil;
    switch (type)
    {
        case BMEmptyViewType_NoData:
            imageName = @"empty_commonicon";
            break;
        case BMEmptyViewType_NetworkError:
            imageName = @"empty_neticon";
            break;
        case BMEmptyViewType_SysError:
        case BMEmptyViewType_ServerError:
        case BMEmptyViewType_DataError:
        case BMEmptyViewType_UnknownError:
            imageName = @"empty_404icon";
            break;
        case BMEmptyViewType_Video:
            imageName = @"empty_videoicon";
            break;
        case BMEmptyViewType_Comment:
            imageName = @"empty_commenticon";
            break;
        case BMEmptyViewType_Topic:
            imageName = @"empty_topicicon";
            break;
        case BMEmptyViewType_Search:
            imageName = @"empty_searchicon";
            break;
        case BMEmptyViewType_CollectCASE:
        case BMEmptyViewType_CollectSTATUTE:
        case BMEmptyViewType_CollectPOSTS:
        case BMEmptyViewType_CollectDOCUMENT:
            imageName = @"empty_collecticon";
            break;
        case BMEmptyViewType_Ocr:
            imageName = @"empty_ocricon";
            break;
        case BMEmptyViewType_Custom:
            imageName = self.customImageName;
            break;
            
        default:
            return nil;
    }
    
    return imageName;
}

- (void)setFullViewTapEnable:(BOOL)enable
{
    self.tapGesture.enabled = enable;
    self.refreshLabel.hidden = !self.tapGesture.enabled;
    self.freshButton.hidden = enable;
}

- (void)showImageView:(BOOL)showImage messageView:(BOOL)showMessage customView:(BOOL)showCustom
{
    self.imageView.hidden = !showImage;
    self.messageLabel.hidden = !showMessage;
    self.customBgView.hidden = !showCustom;
}

- (void)setCustomView:(UIView *)customView
{
    if (customView == nil)
    {
        [self.customBgView bm_removeAllSubviews];
        
        return;
    }
    
    CGFloat height = customView.bm_height;
    
    self.customBgView.frame = CGRectMake(0, 0, self.bm_width, height);
    [self.customBgView addSubview:customView];
    
    [self updateViewFrame];
}

- (void)setEmptyViewType:(BMEmptyViewType)type
{
    if (self.indecator.isAnimating)
    {
        [self.indecator stopAnimating];
    }
    
    self.messageLabel.attributedText = [self messsageWithType:type];
    self.imageView.image = [UIImage imageNamed:[self imageNameWithType:type]];
    
    self.tapGesture.enabled = NO;
    self.refreshLabel.hidden = YES;
    self.freshButton.hidden = YES;
    
    switch (type)
    {
        case BMEmptyViewType_NoData:
            self.freshButton.hidden = NO;
            break;
        case BMEmptyViewType_NetworkError:
            self.freshButton.hidden = NO;
            break;
        case BMEmptyViewType_SysError:
        case BMEmptyViewType_ServerError:
        case BMEmptyViewType_DataError:
        case BMEmptyViewType_UnknownError:
            self.freshButton.hidden = NO;
            break;
        case BMEmptyViewType_Video:
            break;
        case BMEmptyViewType_Comment:
            break;
        case BMEmptyViewType_Topic:
            break;
        case BMEmptyViewType_Search:
            break;
        case BMEmptyViewType_CollectCASE:
        case BMEmptyViewType_CollectSTATUTE:
        case BMEmptyViewType_CollectPOSTS:
        case BMEmptyViewType_CollectDOCUMENT:
            break;
        case BMEmptyViewType_Ocr:
            break;
        case BMEmptyViewType_Custom:
            break;
            
        default:
            break;
    }
    
    [self updateViewFrame];
    
    _emptyViewType = type;
}

- (void)updateViewFrame
{
    self.imageView.bm_height = self.bm_height*0.25f;
    self.imageView.bm_width = self.imageView.bm_height;
    [self.imageView bm_centerHorizontallyInSuperViewWithTop:self.bm_height*0.15f];
    
    [self.messageLabel bm_centerInSuperView];
    
    [self.indecator bm_centerInSuperView];
    
    [self.freshButton bm_centerHorizontallyInSuperViewWithTop:self.messageLabel.bm_bottom+30.0f];
    
    [self.refreshLabel bm_centerHorizontallyInSuperViewWithTop:self.bm_height*0.75f];
    
    [self.customBgView bm_centerHorizontallyInSuperViewWithTop:(self.bm_height-self.customBgView.bm_height)];
}


@end
