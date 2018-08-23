//
//  UIView+BMOutSide.m
//  BMBasekit
//
//  Created by DennisDeng on 2017/1/6.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "UIView+BMOutSide.h"
#import "NSObject+BMCategory.h"
#import <objc/runtime.h>


static char kAssociatedObjectKey_actionEdgeInsets;

@implementation UIView (OutSide)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self bm_swizzleMethod:@selector(pointInside:withEvent:) withMethod:@selector(actionEdgePointInside:withEvent:) error:nil];
    });
}

- (void)setBm_ActionEdgeInsets:(UIEdgeInsets)edgeInsets
{
    objc_setAssociatedObject(self, &kAssociatedObjectKey_actionEdgeInsets, [NSValue valueWithUIEdgeInsets:edgeInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)bm_ActionEdgeInsets
{
    return [objc_getAssociatedObject(self, &kAssociatedObjectKey_actionEdgeInsets) UIEdgeInsetsValue];
}

- (BOOL)actionEdgePointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (([event type] != UIEventTypeTouches))
    {
        return [self actionEdgePointInside:point withEvent:event];
    }
    
    UIEdgeInsets edgeInsets = self.bm_ActionEdgeInsets;
    CGRect boundsInsetOutsideEdge = CGRectMake(CGRectGetMinX(self.bounds) + edgeInsets.left, CGRectGetMinY(self.bounds) + edgeInsets.top, CGRectGetWidth(self.bounds) - (edgeInsets.left + edgeInsets.right), CGRectGetHeight(self.bounds) - (edgeInsets.top + edgeInsets.bottom));
    
    return CGRectContainsPoint(boundsInsetOutsideEdge, point);
}

@end
