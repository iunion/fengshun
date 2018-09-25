//
//  FSMainHeaderView.m
//  fengshun
//
//  Created by Aiwei on 2018/8/30.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSMainHeaderView.h"
#import "UIButton+BMContentRect.h"
#import "FSMainToolCell.h"

@implementation FSMainHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (CGFloat)headerConstheight
{
    return 409 + UI_NAVIGATION_BAR_HEIGHT+UI_STATUS_BAR_HEIGHT;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configBanner];
    _m_toolCollectionView.contentInset = UIEdgeInsetsMake(0, 30, 0, 30);
    _m_topViewHeightConstraint.constant = 197 + UI_NAVIGATION_BAR_HEIGHT+UI_STATUS_BAR_HEIGHT;
    [_m_toolCollectionView registerNib:[UINib nibWithNibName:@"FSMainToolCell" bundle:nil] forCellWithReuseIdentifier:@"FSMainToolCell"];
    
}
- (void)configBanner
{
    self.m_bannerView = [[FSPageBannerView alloc] initWithFrame:CGRectMake(0, 1+UI_NAVIGATION_BAR_HEIGHT+UI_STATUS_BAR_HEIGHT, UI_SCREEN_WIDTH, 164) scrollDirection:FSBannerViewScrollDirectionLandscape images:nil pageWidth:UI_SCREEN_WIDTH - 56.0f padding:0 rollingScale:YES];
    [_m_bannerView setPageControlStyle:FSBannerViewPageStyle_None];
    _m_bannerView.showClose = NO;
    [_m_bannerView setCorner:5.0f];
    _m_bannerView.rollingDelayTime = 5.0;
    [self.m_topView addSubview:_m_bannerView];
}
- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id<FSBannerViewDelegate, FSMainHeaderDelegate>)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"FSMainHeaderView" owner:self options:nil] firstObject];
    if (self)
    {
        self.frame    = frame;
        [self layoutIfNeeded];
        self.delegate = delegate;
        [_m_bannerView setDelegate:delegate];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame            = _m_bottomButton.bounds;
        gradientLayer.colors           = @[ (__bridge id)[UIColor bm_colorWithHexString:@"#577EEE"].CGColor, (__bridge id)[UIColor bm_colorWithHexString:@"#4A9EFE"].CGColor ];
        gradientLayer.startPoint       = CGPointMake(0, 0);
        gradientLayer.endPoint         = CGPointMake(1, 0);
        gradientLayer.locations        = @[ @0, @1 ];
        [_m_bottomButton.layer addSublayer:gradientLayer];
        [_m_bottomButton bm_roundedRect:30.0f];


        [self layoutIfNeeded];
    }
    return self;
}

- (IBAction)buttonClicked:(id)sender {
    [_delegate AIButtonCliked];
}

- (void)reloadBannerWithUrlArray:(NSArray<NSString *> *)urlArray
{
    _m_pageControl.numberOfPages = urlArray.count;
    [_m_bannerView reloadBannerWithData:urlArray];
    [_m_bannerView startRolling];
}
@end
