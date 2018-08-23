//
//  UIView+BMAnimation.h
//  BMBasekit
//
//  Created by DennisDeng on 14-5-4.
//  Copyright (c) 2014年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BMAnimation)

// Moves
- (void)bm_moveTo:(CGPoint)destination duration:(NSTimeInterval)secs option:(UIViewAnimationOptions)option;
- (void)bm_moveTo:(CGPoint)destination duration:(NSTimeInterval)secs option:(UIViewAnimationOptions)option delegate:(id)delegate callback:(SEL)method;
- (void)bm_moveTo:(CGPoint)destination duration:(NSTimeInterval)secs option:(UIViewAnimationOptions)option callbackBlock:(void(^)(void))block;
- (void)bm_raceTo:(CGPoint)destination withSnapBack:(BOOL)withSnapBack;
- (void)bm_raceTo:(CGPoint)destination withSnapBack:(BOOL)withSnapBack delegate:(id)delegate callback:(SEL)method;

// Transforms
- (void)bm_rotate:(NSInteger)degrees secs:(NSTimeInterval)secs delegate:(id)delegate callback:(SEL)method;
- (void)bm_scale:(NSTimeInterval)secs x:(CGFloat)scaleX y:(CGFloat)scaleY delegate:(id)delegate callback:(SEL)method;
- (void)bm_spinClockwise:(NSTimeInterval)secs;
- (void)bm_spinCounterClockwise:(NSTimeInterval)secs;

// Transitions
- (void)bm_curlDown:(NSTimeInterval)secs;
- (void)bm_curlUpAndAway:(NSTimeInterval)secs;

/*
- (void)drainAway:(float)secs;
*/

// Effects
- (void)bm_changeAlpha:(CGFloat)newAlpha secs:(NSTimeInterval)secs;

@end
