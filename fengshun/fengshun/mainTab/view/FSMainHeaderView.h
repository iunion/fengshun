//
//  FSMainHeaderView.h
//  fengshun
//
//  Created by Aiwei on 2018/8/30.
//  Copyright © 2018 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSPageBannerView.h"

@protocol FSMainHeaderDelegate <NSObject>

- (void)headerButtonClikedAtIndex:(NSUInteger)index;
@end

@interface FSMainHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIPageControl *m_pageControl;
@property (weak, nonatomic) IBOutlet UIButton *m_bottomButton;
@property (weak, nonatomic) IBOutlet UIView *   m_topView;
@property (nonatomic, strong) FSPageBannerView *m_bannerView;

@property (nonatomic, weak) id<FSBannerViewDelegate, FSMainHeaderDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id<FSBannerViewDelegate, FSMainHeaderDelegate>)delegate;
- (void)reloadBannerWithUrlArray:(NSArray<NSString *> *)urlArray;
@end
