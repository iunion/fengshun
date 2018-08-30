//
//  DJBannerViewDefine.h
//  DJBannerViewSample
//
//  Created by dengjiang on 16/6/2.
//  Copyright © 2016年 DJ. All rights reserved.
//

#ifndef FSBannerViewDefine_h
#define FSBannerViewDefine_h


#define FSBanner_StartTag       1000
#define FSBanner_CStartTag      2000

#define FSBanner_PageHeight     15.0f
#define FSBanner_PageWidth      60.0f
#define FSBanner_PageBottomGap  3.0f

#define FSBanner_MinScale       0.87f

// scrollView滚动的方向
typedef NS_ENUM(NSInteger, FSBannerViewScrollDirection)
{
    // 水平滚动
    FSBannerViewScrollDirectionLandscape,
    // 垂直滚动
    FSBannerViewScrollDirectionPortait
};

// PageControl位置
typedef NS_ENUM(NSInteger, FSBannerViewPageStyle)
{
    FSBannerViewPageStyle_None,
    FSBannerViewPageStyle_Left,
    FSBannerViewPageStyle_Middle,
    FSBannerViewPageStyle_Right
};

@protocol FSBannerViewDelegate <NSObject>

@optional
//- (void)imageCachedDidFinish:(UIView *)bannerView;

// banner滚动完成
- (void)bannerView:(nonnull UIView *)bannerView didScrollToIndex:(NSUInteger)index;

// banner点击事件
- (void)bannerView:(nonnull UIView *)bannerView didSelectIndex:(NSUInteger)index;

// banner关闭
- (void)bannerViewDidClosed:(nonnull UIView *)bannerView;

@end


@protocol FSBannerViewDataSource <NSObject>

// page数量
- (NSUInteger)bannerViewCountOfPages:(nonnull UIView *)bannerView;
// 自定义pageView
- (nonnull UIView *)bannerView:(nonnull UIView *)bannerView pageAtIndex:(NSUInteger)index;

@end

#endif /* FSBannerViewDefine_h */
