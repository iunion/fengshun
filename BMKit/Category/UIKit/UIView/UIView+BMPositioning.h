//
//  UIView+BMPositioning.h
//  BMBasekit
//
//  Created by DennisDeng on 14-5-5.
//  Copyright (c) 2014年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BMPositioning)

- (void)bm_centerInRect:(CGRect)rect;
- (void)bm_centerInRect:(CGRect)rect leftOffset:(CGFloat)left;
- (void)bm_centerInRect:(CGRect)rect topOffset:(CGFloat)top;
- (void)bm_centerVerticallyInRect:(CGRect)rect;
- (void)bm_centerVerticallyInRect:(CGRect)rect left:(CGFloat)left;
- (void)bm_centerHorizontallyInRect:(CGRect)rect;
- (void)bm_centerHorizontallyInRect:(CGRect)rect top:(CGFloat)top;

- (void)bm_centerInSuperView;
- (void)bm_centerInSuperViewWithLeftOffset:(CGFloat)left;
- (void)bm_centerInSuperViewWithTopOffset:(CGFloat)top;
- (void)bm_centerVerticallyInSuperView;
- (void)bm_centerVerticallyInSuperViewWithLeft:(CGFloat)left;
- (void)bm_centerHorizontallyInSuperView;
- (void)bm_centerHorizontallyInSuperViewWithTop:(CGFloat)top;

- (void)bm_centerHorizontallyBelow:(UIView *)view padding:(CGFloat)padding;
- (void)bm_centerHorizontallyBelow:(UIView *)view;

@end

@interface UIView (BMSubview)

/**
 * The view controller whose view contains this view.
 */
// 只有在addSubView后才有用，不要再init中使用
@property (nonatomic, readonly) UIViewController *bm_viewController;
@property (nonatomic, readonly) NSInteger bm_subviewIndex;

- (void)bm_addSubviewToBack:(UIView*)view;

- (UIView *)bm_superViewWithClass:(Class)aClass; // strict:NO
- (UIView *)bm_superViewWithClass:(Class)aClass strict:(BOOL)strict;

- (UIView *)bm_descendantOrSelfWithClass:(Class)aClass; // strict:NO
- (UIView *)bm_descendantOrSelfWithClass:(Class)aClass strict:(BOOL)strict;

- (void)bm_removeAllSubviews;
- (void)bm_removeAllSubviewsWithClass:(Class)viewClass;

- (void)bm_bringToFront;
- (void)bm_sendToBack;

- (void)bm_bringOneLevelUp;
- (void)bm_sendOneLevelDown;

- (BOOL)bm_isInFront;
- (BOOL)bm_isAtBack;

- (void)bm_swapDepthsWithView:(UIView*)swapView;


// view searching

- (UIView *)bm_viewMatchingPredicate:(NSPredicate *)predicate;
- (UIView *)bm_viewWithTag:(NSInteger)tag ofClass:(Class)viewClass;
- (UIView *)bm_viewOfClass:(Class)viewClass;
- (NSArray *)bm_viewsMatchingPredicate:(NSPredicate *)predicate;
- (NSArray *)bm_viewsWithTag:(NSInteger)tag;
- (NSArray *)bm_viewsWithTag:(NSInteger)tag ofClass:(Class)viewClass;
- (NSArray *)bm_viewsOfClass:(Class)viewClass;

- (UIView *)bm_firstSuperviewMatchingPredicate:(NSPredicate *)predicate;
- (UIView *)bm_firstSuperviewOfClass:(Class)viewClass;
- (UIView *)bm_firstSuperviewWithTag:(NSInteger)tag;
- (UIView *)bm_firstSuperviewWithTag:(NSInteger)tag ofClass:(Class)viewClass;

- (BOOL)bm_viewOrAnySuperviewMatchesPredicate:(NSPredicate *)predicate;
- (BOOL)bm_viewOrAnySuperviewIsKindOfClass:(Class)viewClass;
- (BOOL)bm_isSuperviewOfView:(UIView *)view;
- (BOOL)bm_isSubviewOfView:(UIView *)view;

// 只有在addSubView后才有用，不要再init中使用
// 同viewController
- (UIViewController *)bm_firstViewController;
- (UIView *)bm_firstResponder;

/** Converts the view's center coordinate to a view.
 @param view The given view to translate to.
 @return The point the correlates to the center of the view on the given view.
 */
- (CGPoint)bm_convertCenterToView:(UIView *)view;

/** Converts the view's frame to a view.
 @param view The given view to translate to.
 @return The `CGRect` the correlates to the center of the view on the given view.
 */
- (CGRect)bm_convertFrameToView:(UIView *)view;

/** Moves the view to a different superview while maintaining its overall position.
 @param view The view that will hold the view.
 */
- (void)bm_moveToView:(UIView *)view;

/** Moves the view to the back of a different superview while maintaining its overall position.
 @param view The view that will hold the view.
 */
- (void)bm_moveToBackOfView:(UIView *)view;

@end

@interface UIView (BMUICommon)

/**
 * Finds the first descendant view (including this view) that is a member of a particular class.
 */
- (UIView *)bm_descendantOrSelfWithClass:(Class)cls;

/**
 * Finds the first ancestor view (including this view) that is a member of a particular class.
 */
- (UIView *)bm_ancestorOrSelfWithClass:(Class)cls;

@end
