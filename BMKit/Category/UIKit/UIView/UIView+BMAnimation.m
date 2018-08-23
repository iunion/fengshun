//
//  UIView+BMAnimation.m
//  BMBasekit
//
//  Created by DennisDeng on 14-5-4.
//  Copyright (c) 2014年 DennisDeng. All rights reserved.
//

#import "UIView+BMAnimation.h"


CGFloat radiansForDegrees(NSInteger degrees)
{
    return (CGFloat)degrees * M_PI / 180.0f;
}


@implementation UIView (BMAnimation)


#pragma mark - Moves

- (void)bm_moveTo:(CGPoint)destination duration:(NSTimeInterval)secs option:(UIViewAnimationOptions)option
{
    [self bm_moveTo:destination duration:secs option:option delegate:nil callback:nil];
}

- (void)bm_moveTo:(CGPoint)destination duration:(NSTimeInterval)secs option:(UIViewAnimationOptions)option delegate:(id)delegate callback:(SEL)method
{
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.frame = CGRectMake(destination.x,destination.y, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                         if (delegate != nil)
                         {
                             if (method != NULL)
                             {
                                 [delegate performSelector:method];
                             }
                         }
#pragma clang diagnostic pop
                     }];
}

- (void)bm_moveTo:(CGPoint)destination duration:(NSTimeInterval)secs option:(UIViewAnimationOptions)option callbackBlock:(void(^)(void))block
{
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.frame = CGRectMake(destination.x,destination.y, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                         if (block)
                         {
                             block();
                         }
#pragma clang diagnostic pop
                     }];
}

- (void)bm_raceTo:(CGPoint)destination withSnapBack:(BOOL)withSnapBack
{
    [self bm_raceTo:destination withSnapBack:withSnapBack delegate:nil callback:nil];
}

- (void)bm_raceTo:(CGPoint)destination withSnapBack:(BOOL)withSnapBack delegate:(id)delegate callback:(SEL)method
{
    CGPoint stopPoint = destination;
    if (withSnapBack)
    {
        // Determine our stop point, from which we will "snap back" to the final destination
        int diffx = destination.x - self.frame.origin.x;
        int diffy = destination.y - self.frame.origin.y;

        if (diffx < 0)
        {
            // Destination is to the left of current position
            stopPoint.x -= 10.0;
        }
        else if (diffx > 0)
        {
            stopPoint.x += 10.0;
        }

        if (diffy < 0)
        {
            // Destination is to the left of current position
            stopPoint.y -= 10.0;
        }
        else if (diffy > 0)
        {
            stopPoint.y += 10.0;
        }
    }

    // Do the animation
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.frame = CGRectMake(stopPoint.x, stopPoint.y, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (withSnapBack)
                         {
                             [UIView animateWithDuration:0.1
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  self.frame = CGRectMake(destination.x, destination.y, self.frame.size.width, self.frame.size.height);
                                              }
                                              completion:^(BOOL finished) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                                                  if (delegate && method)
                                                  {
                                                      [delegate performSelector:method];
                                                  }
#pragma clang diagnostic pop
                                              }];
                         }
                         else
                         {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                             if (delegate && method)
                             {
                                 [delegate performSelector:method];
                             }
#pragma clang diagnostic pop
                         }
                     }];
}


#pragma mark - Transforms

- (void)bm_rotate:(NSInteger)degrees secs:(NSTimeInterval)secs delegate:(id)delegate callback:(SEL)method
{
    [UIView animateWithDuration:secs
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformRotate(self.transform, radiansForDegrees(degrees));
                     }
                     completion:^(BOOL finished) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                         if (delegate && method)
                         {
                             [delegate performSelector:method];
                         }
#pragma clang diagnostic pop
                     }];
}

- (void)bm_scale:(NSTimeInterval)secs x:(CGFloat)scaleX y:(CGFloat)scaleY delegate:(id)delegate callback:(SEL)method
{
    [UIView animateWithDuration:secs
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, scaleX, scaleY);
                     }
                     completion:^(BOOL finished) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                         if (delegate && method)
                         {
                             [delegate performSelector:method];
                         }
#pragma clang diagnostic pop
                     }];
}

- (void)bm_spinClockwise:(NSTimeInterval)secs
{
    [UIView animateWithDuration:secs/4
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformRotate(self.transform, radiansForDegrees(90));
                     }
                     completion:^(BOOL finished) {
                         [self bm_spinClockwise:secs];
                     }];
}

- (void)bm_spinCounterClockwise:(NSTimeInterval)secs
{
    [UIView animateWithDuration:secs/4
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformRotate(self.transform, radiansForDegrees(270));
                     }
                     completion:^(BOOL finished) {
                         [self bm_spinCounterClockwise:secs];
                     }];
}


#pragma mark - Transitions

- (void)bm_curlDown:(NSTimeInterval)secs
{
    [UIView transitionWithView:self duration:secs
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^ { [self setAlpha:1.0]; }
                    completion:nil];
}

- (void)bm_curlUpAndAway:(NSTimeInterval)secs
{
    [UIView transitionWithView:self duration:secs
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^ { [self setAlpha:0]; }
                    completion:nil];
}

/*
- (void)drainAway:(float)secs
{
	NSTimer *timer;
    self.tag = 20;
	timer = [NSTimer scheduledTimerWithTimeInterval:secs/50 target:self selector:@selector(drainTimer:) userInfo:nil repeats:YES];
}

- (void)drainTimer:(NSTimer*)timer
{
	CGAffineTransform trans = CGAffineTransformRotate(CGAffineTransformScale(self.transform, 0.9, 0.9),0.314);
	self.transform = trans;
	self.alpha = self.alpha * 0.98;
	self.tag = self.tag - 1;
	if (self.tag <= 0) {
		[timer invalidate];
		[self removeFromSuperview];
	}
}
*/

#pragma mark - Effects

- (void)bm_changeAlpha:(CGFloat)newAlpha secs:(NSTimeInterval)secs
{
    [UIView animateWithDuration:secs
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alpha = newAlpha;
                     }
                     completion:nil];
}


@end
