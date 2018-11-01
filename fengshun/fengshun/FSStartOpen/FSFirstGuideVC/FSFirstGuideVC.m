//
//  FSFirstGuideVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/21.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSFirstGuideVC.h"
#import "AppDelegate.h"

#define FSFirstGuide_PageCount  4

@interface FSFirstGuideVC ()
<
    UIScrollViewDelegate
>

@property (nonatomic, strong) UIScrollView *m_FirstGuideScrollView;

@property (nonatomic, strong) UIPageControl *m_PageControl;

@end

@implementation FSFirstGuideVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_FirstGuideScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    self.m_FirstGuideScrollView.delegate = self;
    self.m_FirstGuideScrollView.pagingEnabled = YES;
    self.m_FirstGuideScrollView.bounces = NO;
    self.m_FirstGuideScrollView.showsHorizontalScrollIndicator = NO;
    self.m_FirstGuideScrollView.showsVerticalScrollIndicator = NO;
    
    for (int i = 0; i < FSFirstGuide_PageCount; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        if (IS_IPHONE4)
        {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"fsintroguide_640x960_%@", @(i+1)]];
        }
        else if (IS_IPHONE5)
        {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"fsintroguide_640X1136_%@", @(i+1)]];
        }
        else if (IS_IPHONE6)
        {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"fsintroguide_750x1334_%@", @(i+1)]];
        }
        else if (IS_IPHONE6P)
        {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"fsintroguide_1242x2208_%@", @(i+1)]];
        }
        else if (IS_IPHONEX)
        {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"fsintroguide_1125x2436_%@", @(i+1)]];
        }
        else if (IS_IPHONEXP)
        {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"fsintroguide_1242x2688_%@", @(i+1)]];
        }

        [self.m_FirstGuideScrollView addSubview:imageView];
        imageView.bm_size = self.m_FirstGuideScrollView.bm_size;
        imageView.bm_origin = CGPointMake(UI_SCREEN_WIDTH * i, 0.0f);
        imageView.userInteractionEnabled = YES;
        
        if (i == FSFirstGuide_PageCount - 1)
        {
            CGRect btnFrame;
            CGFloat btnOffset = 0;
            if (IS_IPHONE6P || IS_IPHONEXP)
            {
                btnFrame = CGRectMake(0, 0, UI_SCREEN_WIDTH-220.0f, 44.0f);
                btnOffset = 56;
            }
            else if (IS_IPHONE6 || IS_IPHONEX)
            {
                btnFrame = CGRectMake(0, 0, UI_SCREEN_WIDTH-200.0f, 44.0f);
                btnOffset = 36;
            }
            else
            {
                btnFrame = CGRectMake(0, 0, UI_SCREEN_WIDTH-190.0f, 36.0f);
                btnOffset = 20;
            }

            UIButton *button = [UIButton bm_buttonWithFrame:btnFrame color:UI_COLOR_BL1];
            [imageView addSubview:button];
            button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:@"立即体验" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(enterFSApp) forControlEvents:UIControlEventTouchUpInside];
            [button bm_roundedRect:button.bm_height*0.5];
            [button bm_centerHorizontallyInSuperViewWithTop:(UI_SCREEN_HEIGHT-44-btnOffset)];
        }
    }
    
    self.m_FirstGuideScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH * FSFirstGuide_PageCount, UI_SCREEN_HEIGHT);
    [self.m_FirstGuideScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [self.view addSubview:self.m_FirstGuideScrollView];
    
    self.m_PageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 80.0f, 30.0f)];
    [self.view addSubview:self.m_PageControl];
    [self.m_PageControl bm_centerHorizontallyInSuperViewWithTop:(UI_SCREEN_HEIGHT-64.0f)];
    self.m_PageControl.numberOfPages = FSFirstGuide_PageCount;
    self.m_PageControl.currentPage = 0;
    self.m_PageControl.pageIndicatorTintColor = UI_COLOR_B5;
    self.m_PageControl.currentPageIndicatorTintColor = UI_COLOR_B3;
    
#if USE_TEST_HELP
    if (IOS_VERSION >= 12.0)
    {
        [GetAppDelegate showFPS];
    }
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)enterFSApp
{
    [self dissMiss];
}

- (void)dissMiss
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showFirstGuideVCFinish)])
    {
        [self.delegate showFirstGuideVCFinish];
    }
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.m_FirstGuideScrollView.bounds);
    CGFloat pageFraction = self.m_FirstGuideScrollView.contentOffset.x / pageWidth;
    self.m_PageControl.currentPage = roundf(pageFraction);
    
    if (self.m_PageControl.currentPage == FSFirstGuide_PageCount - 1)
    {
        self.m_PageControl.hidden = YES;
    }
    else
    {
        self.m_PageControl.hidden = NO;
    }
}

@end
