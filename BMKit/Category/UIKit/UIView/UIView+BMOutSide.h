//
//  UIView+BMOutSide.h
//  BMBasekit
//
//  Created by DennisDeng on 2017/1/6.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BMOutSide)

// 响应区域需要改变的大小，负值表示往外扩大，正值表示往内缩小
@property(nonatomic, assign) UIEdgeInsets bm_ActionEdgeInsets;

@end
