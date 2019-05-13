//
//  BMScrollPageView.h
//  BMBaseKit
//
//  Created by jiang deng on 2019/2/19.
//  Copyright © 2019 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMScrollPageSegment.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BMScrollPageViewDataSource;
@protocol BMScrollPageViewDelegate;

@interface BMScrollPageView : UIView

@property (nonatomic, weak) id <BMScrollPageViewDataSource> datasource;
@property (nonatomic, weak) id <BMScrollPageViewDelegate> delegate;

@property (nullable, nonatomic, strong, readonly) BMScrollPageSegment *segmentBar;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

// 当前位置index
@property (nonatomic, assign, readonly) NSUInteger currentIndex;

- (instancetype)initWithFrame:(CGRect)frame withScrollPageSegment:(nullable BMScrollPageSegment *)scrollPageSegment;

- (void)reloadPages;

- (void)scrollPageWithIndex:(NSUInteger)index;

@end

@protocol BMScrollPageViewDataSource <NSObject>

- (NSUInteger)scrollPageViewNumberOfPages:(BMScrollPageView *)scrollPageView;
- (NSString *)scrollPageView:(BMScrollPageView *)scrollPageView titleAtIndex:(NSUInteger)index;
- (id)scrollPageView:(BMScrollPageView *)scrollPageView pageAtIndex:(NSUInteger)index;

@end


@protocol BMScrollPageViewDelegate <NSObject>

@optional

- (void)scrollPageViewChangeToIndex:(NSUInteger)index;
- (void)scrollPageResetPages;

@end

NS_ASSUME_NONNULL_END
