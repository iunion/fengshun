//
//  UIView+BMPositioning.h
//  BMBasekit
//
//  Created by DennisDeng on 14-5-5.
//  Copyright (c) 2014年 DennisDeng. All rights reserved.
//

#import "UIView+BMPositioning.h"
#import "UIView+BMSize.h"

@implementation UIView (BMPositioning)

- (void)bm_centerInRect:(CGRect)rect
{
    [self setCenter:CGPointMake(floorf(CGRectGetMidX(rect)) + ((int)floorf([self bm_width]) % 2 ? .5 : 0) , floorf(CGRectGetMidY(rect)) + ((int)floorf([self bm_height]) % 2 ? .5 : 0))];
}

- (void)bm_centerInRect:(CGRect)rect leftOffset:(CGFloat)left
{
    [self setCenter:CGPointMake(left + floorf(CGRectGetMidX(rect)) + ((int)floorf([self bm_width]) % 2 ? .5 : 0) , floorf(CGRectGetMidY(rect)) + ((int)floorf([self bm_height]) % 2 ? .5 : 0))];
}

- (void)bm_centerInRect:(CGRect)rect topOffset:(CGFloat)top
{
    [self setCenter:CGPointMake(floorf(CGRectGetMidX(rect)) + ((int)floorf([self bm_width]) % 2 ? .5 : 0) , top + floorf(CGRectGetMidY(rect)) + ((int)floorf([self bm_height]) % 2 ? .5 : 0))];
}

- (void)bm_centerVerticallyInRect:(CGRect)rect
{
    [self setCenter:CGPointMake([self center].x, floorf(CGRectGetMidY(rect)) + ((int)floorf([self bm_height]) % 2 ? .5 : 0))];
}

- (void)bm_centerVerticallyInRect:(CGRect)rect left:(CGFloat)left
{
//    [self setCenter:CGPointMake(left + [self center].x, floorf(CGRectGetMidY(rect)) + ((int)floorf([self height]) % 2 ? .5 : 0))];
    
    [self bm_centerVerticallyInRect:rect];
    self.bm_left = left;
}

- (void)bm_centerHorizontallyInRect:(CGRect)rect
{
    [self setCenter:CGPointMake(floorf(CGRectGetMidX(rect)) + ((int)floorf([self bm_width]) % 2 ? .5 : 0), [self center].y)];
}

- (void)bm_centerHorizontallyInRect:(CGRect)rect top:(CGFloat)top
{
//    [self setCenter:CGPointMake(floorf(CGRectGetMidX(rect)) + ((int)floorf([self width]) % 2 ? .5 : 0), top + ((int)floorf([self height]) % 2 ? .5 : 0))];
    
    [self bm_centerHorizontallyInRect:rect];
    self.bm_top = top;
}

- (void)bm_centerInSuperView
{
    [self bm_centerInRect:[[self superview] bounds]];
}

- (void)bm_centerInSuperViewWithLeftOffset:(CGFloat)left
{
    [self bm_centerInRect:[[self superview] bounds] leftOffset:left];
}

- (void)bm_centerInSuperViewWithTopOffset:(CGFloat)top
{
    [self bm_centerInRect:[[self superview] bounds] topOffset:top];
}

- (void)bm_centerVerticallyInSuperView
{
    [self bm_centerVerticallyInRect:[[self superview] bounds]];
}

- (void)bm_centerVerticallyInSuperViewWithLeft:(CGFloat)left
{
    [self bm_centerVerticallyInRect:[[self superview] bounds] left:left];
}

- (void)bm_centerHorizontallyInSuperView
{
    [self bm_centerHorizontallyInRect:[[self superview] bounds]];
}

- (void)bm_centerHorizontallyInSuperViewWithTop:(CGFloat)top
{
    [self bm_centerHorizontallyInRect:[[self superview] bounds] top:top];
}

- (void)bm_centerHorizontallyBelow:(UIView *)view padding:(CGFloat)padding
{
    // for now, could use screen relative positions.
    NSAssert([self superview] == [view superview], @"views must have the same parent");
    
    [self setCenter:CGPointMake([view center].x,
                                floorf(padding + CGRectGetMaxY([view frame]) + ([self bm_height] / 2)))];
}

- (void)bm_centerHorizontallyBelow:(UIView *)view
{
    [self bm_centerHorizontallyBelow:view padding:0];
}

@end


@implementation UIView (BMSubview)

- (void)bm_addSubviewToBack:(UIView*)view
{
    [self addSubview:view];
    [self sendSubviewToBack:view];
}

- (UIViewController*)bm_viewController
{
//    for (UIView* next = [self superview]; next; next = next.superview) 
//    {
//        UIResponder* nextResponder = [next nextResponder];
//        if ([nextResponder isKindOfClass:[UIViewController class]])
//        {
//            return (UIViewController*)nextResponder;
//        }
//    }
//    return nil;
    
    //通过响应者链，获取此视图所在的视图控制器
    UIResponder *next = self.nextResponder;
    do
    {
        //判断响应者对象是否是视图控制器对象
        if ([next isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)next;
        }
        //不停的指向下一个响应者
        next = next.nextResponder;
        
    }
    while (next != nil);
    
    return nil;
}

- (NSInteger)bm_subviewIndex
{
    if (self.superview == nil)
    {
        return NSNotFound;
    }
    
    return [self.superview.subviews indexOfObject:self];
}

- (UIView *)bm_superViewWithClass:(Class)aClass
{
    return [self bm_superViewWithClass:aClass strict:NO];
}

- (UIView *)bm_superViewWithClass:(Class)aClass strict:(BOOL)strict
{
    UIView *view = self.superview;
    
    while(view)
    {
        if(strict && [view isMemberOfClass:aClass])
        {
            break;
        }
        else if(!strict && [view isKindOfClass:aClass])
        {
            break;
        }
        else
        {
            view = view.superview;
        }
    }
    
    return view;
}

- (UIView*)bm_descendantOrSelfWithClass:(Class)aClass
{
    return [self bm_descendantOrSelfWithClass:aClass strict:NO];
}

- (UIView *)bm_descendantOrSelfWithClass:(Class)aClass strict:(BOOL)strict
{
    if (strict && [self isMemberOfClass:aClass])
    {
        return self;
    }
    else if (!strict && [self isKindOfClass:aClass])
    {
        return self;
    }
    
    for (UIView* child in self.subviews)
    {
        UIView* viewWithClass = [child bm_descendantOrSelfWithClass:aClass strict:strict];
        
        if (viewWithClass != nil)
        {
            return viewWithClass;
        }
    }
    
    return nil;
}

- (void)bm_removeAllSubviews
{
//    while (self.subviews.count > 0)
//    {
//        UIView *child = self.subviews.lastObject;
//        [child removeFromSuperview];
//    }
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull childView, NSUInteger idx, BOOL * _Nonnull stop) {
        [childView removeFromSuperview];
    }];
}

- (void)bm_bringToFront
{
    [self.superview bringSubviewToFront:self];
}

- (void)bm_sendToBack
{
    [self.superview sendSubviewToBack:self];
}

- (void)bm_bringOneLevelUp
{
    NSInteger currentIndex = self.bm_subviewIndex;
    [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex+1];
}

- (void)bm_sendOneLevelDown
{
    NSInteger currentIndex = self.bm_subviewIndex;
    [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex-1];
}

- (BOOL)bm_isInFront
{
    return (self.superview.subviews.lastObject == self);
}

- (BOOL)bm_isAtBack
{
    return ([self.superview.subviews objectAtIndex:0] == self);
}

- (void)bm_swapDepthsWithView:(UIView*)swapView
{
    [self.superview exchangeSubviewAtIndex:self.bm_subviewIndex withSubviewAtIndex:swapView.bm_subviewIndex];
}


#pragma mark -
#pragma mark view searching

- (UIView *)bm_viewMatchingPredicate:(NSPredicate *)predicate
{
    if ([predicate evaluateWithObject:self])
    {
        return self;
    }

    for (UIView *view in self.subviews)
    {
        UIView *match = [view bm_viewMatchingPredicate:predicate];
        if (match)
        {
            return match;
        }
    }

    return nil;
}

- (UIView *)bm_viewWithTag:(NSInteger)tag ofClass:(Class)viewClass
{
    return [self bm_viewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, __unused NSDictionary *bindings) {
        return [evaluatedObject tag] == tag && [evaluatedObject isKindOfClass:viewClass];
    }]];
}

- (UIView *)bm_viewOfClass:(Class)viewClass
{
    return [self bm_viewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, __unused NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:viewClass];
    }]];
}

- (NSArray *)bm_viewsMatchingPredicate:(NSPredicate *)predicate
{
    NSMutableArray *matches = [NSMutableArray array];

    if ([predicate evaluateWithObject:self])
    {
        [matches addObject:self];
    }

    for (UIView *view in self.subviews)
    {
        //check for subviews
        //avoid creating unnecessary array
        if ([view.subviews count])
        {
        	[matches addObjectsFromArray:[view bm_viewsMatchingPredicate:predicate]];
        }
        else if ([predicate evaluateWithObject:view])
        {
            [matches addObject:view];
        }
    }

    return matches;
}

- (NSArray *)bm_viewsWithTag:(NSInteger)tag
{
    return [self bm_viewsMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, __unused id bindings) {
        return [evaluatedObject tag] == tag;
    }]];
}

- (NSArray *)bm_viewsWithTag:(NSInteger)tag ofClass:(Class)viewClass
{
    return [self bm_viewsMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, __unused id bindings) {
        return [evaluatedObject tag] == tag && [evaluatedObject isKindOfClass:viewClass];
    }]];
}

- (NSArray *)bm_viewsOfClass:(Class)viewClass
{
    return [self bm_viewsMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, __unused id bindings) {
        return [evaluatedObject isKindOfClass:viewClass];
    }]];
}

- (UIView *)bm_firstSuperviewMatchingPredicate:(NSPredicate *)predicate
{
    if ([predicate evaluateWithObject:self])
    {
        return self;
    }

    return [self.superview bm_firstSuperviewMatchingPredicate:predicate];
}

- (UIView *)bm_firstSuperviewOfClass:(Class)viewClass
{
    return [self bm_firstSuperviewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *superview, __unused id bindings) {
        return [superview isKindOfClass:viewClass];
    }]];
}

- (UIView *)bm_firstSuperviewWithTag:(NSInteger)tag
{
    return [self bm_firstSuperviewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *superview, __unused id bindings) {
        return superview.tag == tag;
    }]];
}

- (UIView *)bm_firstSuperviewWithTag:(NSInteger)tag ofClass:(Class)viewClass
{
    return [self bm_firstSuperviewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *superview, __unused id bindings) {
        return superview.tag == tag && [superview isKindOfClass:viewClass];
    }]];
}

- (BOOL)bm_viewOrAnySuperviewMatchesPredicate:(NSPredicate *)predicate
{
    if ([predicate evaluateWithObject:self])
    {
        return YES;
    }

    return [self.superview bm_viewOrAnySuperviewMatchesPredicate:predicate];
}

- (BOOL)bm_viewOrAnySuperviewIsKindOfClass:(Class)viewClass
{
    return [self bm_viewOrAnySuperviewMatchesPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *superview, __unused id bindings) {
        return [superview isKindOfClass:viewClass];
    }]];
}

//- (BOOL)isSuperviewOfView:(UIView *)view
//{
//    return [self firstSuperviewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *superview, __unused id bindings) {
//        return superview == view;
//    }]] != nil;
//}
//
//- (BOOL)isSubviewOfView:(UIView *)view
//{
//    return [view isSuperviewOfView:self];
//}

- (BOOL)bm_isSuperviewOfView:(UIView *)view
{
    return [view bm_isSubviewOfView:self];
}

- (BOOL)bm_isSubviewOfView:(UIView *)view
{
    return [self isDescendantOfView:view];
}


#pragma mark -
#pragma mark responder chain

- (UIViewController *)bm_firstViewController
{
    UIResponder *responder = self;

    while ((responder = [responder nextResponder]))
    {
        if ([responder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)responder;
        }
    }

    return nil;
}

- (UIView *)bm_firstResponder
{
    return [self bm_viewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, __unused id bindings) {
        return [evaluatedObject isFirstResponder];
    }]];
}

- (CGPoint)bm_convertCenterToView:(UIView *)view
{
    if (self.superview)
    {
        return [self.superview convertPoint:self.center toView:view];
    }
    
    return CGPointZero;
}

- (CGRect)bm_convertFrameToView:(UIView *)view
{
    if (self.superview)
    {
        return [self.superview convertRect:self.frame toView:view];
    }
    
    return CGRectZero;
}

- (void)bm_moveToView:(UIView *)view
{
    if (self.superview)
    {
        self.center = [self bm_convertCenterToView:view];
        [self removeFromSuperview];
        [view addSubview:self];
    }
}

- (void)bm_moveToBackOfView:(UIView *)view
{
    if (self.superview)
    {
        self.center = [self bm_convertCenterToView:view];
        [self removeFromSuperview];
        [view bm_addSubviewToBack:self];
    }
}

@end


#pragma mark -
#pragma mark UIView + BMUICommon

@implementation UIView (BMUICommon)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)bm_descendantOrSelfWithClass:(Class)cls
{
    if ([self isKindOfClass:cls])
    {
        return self;
    }
    
    for (UIView *child in self.subviews)
    {
        UIView *it = [child bm_descendantOrSelfWithClass:cls];
        if (it)
        {
            return it;
        }
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)bm_ancestorOrSelfWithClass:(Class)cls
{
    if ([self isKindOfClass:cls])
    {
        return self;
    }
    else if (self.superview)
    {
        return [self.superview bm_ancestorOrSelfWithClass:cls];
    }
    else
    {
        return nil;
    }
}

@end
