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
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configBanner];
    _m_toolCollectionView.contentInset = UIEdgeInsetsMake(0, 30, 0, 30);
    [_m_toolCollectionView registerNib:[UINib nibWithNibName:@"FSMainToolCell" bundle:nil] forCellWithReuseIdentifier:@"FSMainToolCell"];
    
}
- (void)configBanner
{
    self.m_bannerView = [[FSPageBannerView alloc] initWithFrame:CGRectMake(0, 65, UI_SCREEN_WIDTH, 164) scrollDirection:FSBannerViewScrollDirectionLandscape images:nil pageWidth:UI_SCREEN_WIDTH - 56.0f padding:0 rollingScale:YES];
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
        self.delegate = delegate;
        [_m_bannerView setDelegate:delegate];
        [self layoutIfNeeded];
    }
    return self;
}


- (void)reloadBannerWithUrlArray:(NSArray<NSString *> *)urlArray
{
    _m_pageControl.numberOfPages = urlArray.count;
    [_m_bannerView reloadBannerWithData:urlArray];
    [_m_bannerView startRolling];
}
@end
