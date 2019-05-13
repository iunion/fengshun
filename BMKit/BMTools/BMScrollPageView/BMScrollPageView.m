//
//  BMScrollPageView.m
//  BMBaseKit
//
//  Created by jiang deng on 2019/2/19.
//  Copyright © 2019 BM. All rights reserved.
//

#import "BMScrollPageView.h"

@interface UIScrollView (AllowPanGestureEventPass)

@end

@implementation UIScrollView (AllowPanGestureEventPass)

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]
        && [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
    {
        return YES;
    }
    else
    {
        return  NO;
    }
}

@end


@interface BMScrollPageView  ()
<
    UIScrollViewDelegate,
    BMScrollPageSegmentDelegate
>

@property (nonatomic, strong) BMScrollPageSegment *segmentBar;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) NSUInteger pageCount;
@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, strong) NSMutableArray *pageArray;
@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation BMScrollPageView

- (instancetype)initWithFrame:(CGRect)frame withScrollPageSegment:(BMScrollPageSegment *)scrollPageSegment
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.currentIndex = 0;
        
        self.segmentBar = scrollPageSegment;
        self.segmentBar.delegate = self;
        
        [self makeView];
    }
    
    return self;
}


#pragma mark -
#pragma mark makeView

- (void)makeView
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = self.bounds;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self addSubview:self.scrollView];
}

- (void)reloadPages
{
    self.pageCount = [self.datasource scrollPageViewNumberOfPages:self];
    [self.scrollView bm_removeAllSubviews];
    if (self.pageCount == 0)
    {
        return;
    }

    self.scrollView.contentSize = CGSizeMake(self.bm_width * self.pageCount, 0);
    self.pageArray = [[NSMutableArray alloc] initWithCapacity:self.pageCount];
    self.titleArray = [[NSMutableArray alloc] initWithCapacity:self.pageCount];

    for (NSUInteger index=0; index<self.pageCount; index++)
    {
        [self.pageArray addObject:[NSNull null]];
        NSString *title = [self.datasource scrollPageView:self titleAtIndex:index];
        if (title)
        {
            [self.titleArray addObject:title];
        }
        else
        {
            NSAssert(title, @"Cannot show use nil!");
        }
    }
    
    [self.segmentBar freshItemsWithTitles:self.titleArray];
}

- (void)moveScrollPageToIndex:(NSUInteger)index
{
    if (index >= self.pageArray.count)
    {
        index = 0;
    }
    
    id view = self.pageArray[index];
    
    if ((NSNull *)view == [NSNull null])
    {
        id newView = [self.datasource scrollPageView:self pageAtIndex:index];
        
        if (newView)
        {
            [self.pageArray replaceObjectAtIndex:index withObject:newView];
            
            UIView *aView = nil;
            if ([newView isKindOfClass:[UIViewController class]])
            {
                UIViewController *vc = (UIViewController *)newView;
                aView = vc.view;
            }
            else if ([newView isKindOfClass:[UIView class]])
            {
                aView = newView;
            }
            else
            {
                NSAssert(newView, @"Cannot show the pages, it is not a view!");
            }
            
            if (aView)
            {
                [self.scrollView addSubview:aView];
            }
            aView.frame = CGRectMake(self.bm_width * index, 0, self.bm_width, self.scrollView.bm_height);
            //aView.backgroundColor = [UIColor bm_randomColor];
            aView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

            UITableView *tableView = (UITableView *)[aView bm_viewOfClass:[UITableView class]];
            if (tableView)
            {
                tableView.frame = aView.bounds;
            }
        }
        else
        {
            NSAssert(newView, @"Cannot show the pages!");
        }
    }
    
    self.currentIndex = index;
    
    CGFloat offsetX = self.bm_width * index;
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger index = (NSUInteger)((scrollView.contentOffset.x + self.bm_width / 2) / self.bm_width);
    [self scrollPageWithIndex:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger index = (NSUInteger)((scrollView.contentOffset.x + self.bm_width / 2) / self.bm_width);
    if (self.currentIndex != index)
    {
        if (self.segmentBar.currentIndex != index)
        {
            self.currentIndex = index;
            [self.segmentBar selectItemAtIndex:index];
        }
    }
}


#pragma mark -
#pragma mark BMScrollPageSegmentDelegate

- (void)scrollSegment:(BMScrollPageSegment *)scrollSegment selectedItemAtIndex:(NSUInteger)index
{
    if (self.currentIndex != index)
    {
        [self moveScrollPageToIndex:index];
        
        if ([self.delegate respondsToSelector:@selector(scrollPageViewChangeToIndex:)])
        {
            [self.delegate scrollPageViewChangeToIndex:self.currentIndex];
        }
    }
}

- (void)scrollSegmentSetSegments:(BMScrollPageSegment *)scrollSegment
{
    if ([self.delegate respondsToSelector:@selector(scrollPageResetPages)])
    {
        [self.delegate scrollPageResetPages];
    }
}

#pragma mark - public Method

- (void)scrollPageWithIndex:(NSUInteger)index
{
    if (self.pageCount == 0)
    {
        return;
    }
    
    [self moveScrollPageToIndex:index];
    
    [self.segmentBar selectItemAtIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(scrollPageViewChangeToIndex:)])
    {
        [self.delegate scrollPageViewChangeToIndex:self.currentIndex];
    }
}


@end
