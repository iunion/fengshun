//
//  UIButton+BMContentRect.h
//  BMBasekit
//
//  Created by DennisDeng on 15/7/20.
//  Copyright (c) 2015年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BMButtonEdgeInsetsStyle)
{
    BMButtonEdgeInsetsStyleImageLeft,
    BMButtonEdgeInsetsStyleImageRight,
    BMButtonEdgeInsetsStyleImageTop,
    BMButtonEdgeInsetsStyleImageBottom
};

@interface UIButton (BMContentRect)

@property (nonatomic, assign) CGRect bm_titleRect;
@property (nonatomic, assign) CGRect bm_imageRect;

- (void)bm_layoutButtonWithEdgeInsetsStyle:(BMButtonEdgeInsetsStyle)style imageTitleGap:(CGFloat)gap;

@end
