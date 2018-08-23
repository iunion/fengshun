//
//  UIView+BMSize.h
//  BMBasekit
//
//  Created by DennisDeng on 14-5-5.
//  Copyright (c) 2014年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BMSize)

/**
 * Shortcut for frame.origin
 */
@property (nonatomic, assign) CGPoint bm_origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic, assign) CGSize bm_size;

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic, assign) CGFloat bm_left;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic, assign) CGFloat bm_right;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic, assign) CGFloat bm_top;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic, assign) CGFloat bm_bottom;

/** The x origin of the view's frame. */
@property (nonatomic, assign) CGFloat bm_originX;

/** The max y origin of the view's frame. */
@property (nonatomic, assign) CGFloat bm_originY;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic, assign) CGFloat bm_centerX;


/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic, assign) CGFloat bm_centerY;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic, assign) CGFloat bm_width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic, assign) CGFloat bm_height;


// bounds accessors
@property (nonatomic, assign) CGSize bm_boundsSize;
@property (nonatomic, assign) CGFloat bm_boundsWidth;
@property (nonatomic, assign) CGFloat bm_boundsHeight;


// content getters
@property (nonatomic, readonly) CGRect bm_contentBounds;
@property (nonatomic, readonly) CGPoint bm_contentCenter;


// additional frame setters
- (void)bm_setLeft:(CGFloat)left right:(CGFloat)right;
- (void)bm_setWidth:(CGFloat)width right:(CGFloat)right;
- (void)bm_setTop:(CGFloat)top bottom:(CGFloat)bottom;
- (void)bm_setHeight:(CGFloat)height bottom:(CGFloat)bottom;


@end
