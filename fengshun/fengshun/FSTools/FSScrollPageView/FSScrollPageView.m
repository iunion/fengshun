//
//  FSScrollPageView.m
//  miaoqian
//
//  Created by dengjiang on 16/5/10.
//  Copyright © 2016年 MiaoQian. All rights reserved.
//

#import "FSScrollPageView.h"
//#import "MQTableView.h"



@interface FSScrollPageView ()
<
    UIScrollViewDelegate,
    FSScrollPageSegmentDelegate
>

@property (nonatomic, assign) BOOL m_IsEqualDivideSegment;

@property (nonatomic, strong) FSScrollPageSegment *m_SegmentBar;
@property (nonatomic, strong) UIScrollView *m_ScrollView;

@property (nonatomic, strong) NSMutableArray *m_TitleArray;
@property (nonatomic, strong) NSMutableArray *m_ViewArray;

@property (nonatomic, assign) NSUInteger m_PageCount;
@property (nonatomic, assign) NSUInteger m_CurrentIndex;

@property (nonatomic, assign) BOOL m_IsSubViewPageSegment;

@end


@implementation FSScrollPageView

- (instancetype)initWithFrame:(CGRect)frame titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor
{
    return [self initWithFrame:frame titleColor:titleColor selectTitleColor:selectTitleColor isEqualDivideSegment:NO];
}

- (instancetype)initWithFrame:(CGRect)frame titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor isEqualDivideSegment:(BOOL)isEqualDivideSegment
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.m_IsEqualDivideSegment = isEqualDivideSegment;
        //self.backgroundColor = [UIColor redColor];
        self.m_CurrentIndex = 0;
        self.m_TitleColor = titleColor;
        self.m_TitleSelectColor = selectTitleColor;
        self.m_IsSubViewPageSegment = YES;
        
        [self creatPageSegment];
        
        [self creatScrollPage];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor scrollPageSegment:(FSScrollPageSegment *)scrollPageSegment isSubViewPageSegment:(BOOL)isSubViewPageSegment
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.m_SegmentBar = scrollPageSegment;
        self.m_CurrentIndex = 0;
        self.m_TitleColor = titleColor;
        self.m_TitleSelectColor = selectTitleColor;
        self.m_IsSubViewPageSegment = isSubViewPageSegment;
        
        scrollPageSegment.delegate = self;
        
        [self creatScrollPage];
    }
    return self;
}


#pragma mark -
#pragma mark set

- (void)setM_TitleColor:(UIColor *)titleColor
{
    _m_TitleColor = titleColor;
    self.m_SegmentBar.m_TextColor = titleColor;
}

- (void)setM_TitleSelectColor:(UIColor *)titleSelectColor
{
    _m_TitleSelectColor = titleSelectColor;
    self.m_SegmentBar.m_SelectTextColor = titleSelectColor;
}

// 下划线的颜色
- (void)setM_MoveLineColor:(UIColor *)movelineColor
{
    self.m_SegmentBar.moveLineColor = movelineColor;
}

// 顶部菜单栏的背景颜色initWithTitles:nil titleColor:self.m_TitleColor selectTitleColor:self.m_TitleSelectColor
- (void)setM_TabBgColor:(UIColor *)tabBgColor
{
    self.m_SegmentBar.backgroundColor = tabBgColor;
}

- (void)creatPageSegment
{
    self.m_SegmentBar = [[FSScrollPageSegment alloc] initWithTitles:nil titleColor:self.m_TitleColor selectTitleColor:self.m_TitleSelectColor isEqualDivide:self.m_IsEqualDivideSegment];
    self.m_SegmentBar.bm_width = self.bounds.size.width;
    self.m_SegmentBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.m_SegmentBar.delegate = self;
    
    [self addSubview:self.m_SegmentBar];
}

- (void)creatScrollPage
{
    if (self.m_IsSubViewPageSegment)
    {
        if (!self.m_SegmentBar.superview)
        {
            [self addSubview:self.m_SegmentBar];
        }
    }
    self.m_ScrollView = [[UIScrollView alloc] init];
    CGFloat scrollViewY = self.m_IsSubViewPageSegment ? self.m_SegmentBar.bm_height : 0;
    CGFloat scrollViewH = self.m_IsSubViewPageSegment ? self.bm_height-self.m_SegmentBar.bm_height : self.bm_height;
    self.m_ScrollView.frame = CGRectMake(0, scrollViewY, self.bm_width, scrollViewH);
    self.m_ScrollView.delegate = self;
    self.m_ScrollView.backgroundColor = [UIColor clearColor];
    self.m_ScrollView.pagingEnabled = YES;
    self.m_ScrollView.showsHorizontalScrollIndicator = NO;
    self.m_ScrollView.bounces = NO;
    
    [self addSubview:self.m_ScrollView];
}

- (void)reloadPage
{
    self.m_PageCount = [self.datasource scrollPageViewNumberOfPages:self];
    [self.m_ScrollView bm_removeAllSubviews];
    if (self.m_PageCount == 0)
    {
        return;
    }
    self.m_ScrollView.contentSize = CGSizeMake(self.bm_width * self.m_PageCount, 0);
    self.m_ViewArray = [[NSMutableArray alloc] initWithCapacity:self.m_PageCount];
    self.m_TitleArray = [[NSMutableArray alloc] initWithCapacity:self.m_PageCount];
    for (NSUInteger index=0; index<self.m_PageCount; index++)
    {
        [self.m_ViewArray addObject:[NSNull null]];
        NSString *title = [self.datasource scrollPageView:self titleAtIndex:index];
        if (title)
        {
            [self.m_TitleArray addObject:title];
        }
        else
        {
            NSAssert(title, @"Cannot show use nil!");
        }
    }
    
    [self.m_SegmentBar freshButtonWithTitles:self.m_TitleArray titleColor:self.m_TitleColor selectTitleColor:self.m_TitleSelectColor];
}

- (void)scrollPageWithIndex:(NSUInteger)index
{
    if (self.m_PageCount == 0)
    {
        return;
    }
    
    [self moveScrollPageWithIndex:index];
    
    [self.m_SegmentBar selectBtnAtIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(scrollPageViewChangeToIndex:)])
    {
        [self.delegate scrollPageViewChangeToIndex:self.m_CurrentIndex];
    }
}

- (void)moveScrollPageWithIndex:(NSUInteger)index
{
    if (index >= self.m_ViewArray.count)
    {
        index = 0;
    }
    
    id view = self.m_ViewArray[index];
    
    if ((NSNull *)view == [NSNull null])
    {
        id newView = [self.datasource scrollPageView:self pageAtIndex:index];

        if (newView)
        {
            [self.m_ViewArray replaceObjectAtIndex:index withObject:newView];
            
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
            [self.m_ScrollView addSubview:aView];
            aView.frame = CGRectMake(self.bm_width * index, 0, self.bm_width, self.m_ScrollView.bm_height);
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
    
    self.m_CurrentIndex = index;
    
    CGFloat offsetX = self.bm_width * index;
    self.m_ScrollView.contentOffset = CGPointMake(offsetX, 0);
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
    if (self.m_CurrentIndex != index)
    {
        if (![self.m_SegmentBar isClickBtnWithScroll:index])
        {
            self.m_CurrentIndex = index;
            [self.m_SegmentBar selectBtnAtIndex:index];
        }
    }
}


#pragma mark -
#pragma mark FSScrollPageSegmentDelegate

- (void)scrollSegment:(FSScrollPageSegment *)scrollSegment selectedButtonAtIndex:(NSUInteger)index
{
    if (self.m_CurrentIndex != index)
    {
        [self moveScrollPageWithIndex:index];
    }
}

@end
