//
//  FSBaseComTopicListVC.m
//  fengshun
//
//  Created by jiang deng on 2018/12/21.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSBaseComTopicListVC.h"

@interface FSBaseComTopicListVC ()

// 判断手指是否离开
@property (nonatomic, assign) BOOL m_IsTouch;

@end

@implementation FSBaseComTopicListVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_TableView.showsVerticalScrollIndicator = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.m_IsTouch = YES;
}

///用于判断手指是否离开了 要做到当用户手指离开了，tableview滑道顶部，也不显示出主控制器
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //NSLog(@"手指离开了");
    self.m_IsTouch = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.m_CanScroll)
    {
        [scrollView setContentOffset:CGPointZero];
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0)
    {
        // 当手指离开了，也不允许显示主控制器，这里可以根据实际需求做处理
        if (!self.m_IsTouch)
        {
            return;
        }
        
        if ([self.scrollTopDelegate respondsToSelector:@selector(comTopicScrollToTop:)])
        {
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"kLeaveTopNtf" object:@1];
            [self.scrollTopDelegate comTopicScrollToTop:self.m_TableView];
        }
        
        self.m_CanScroll = NO;

        scrollView.contentOffset = CGPointZero;
    }
}

@end
