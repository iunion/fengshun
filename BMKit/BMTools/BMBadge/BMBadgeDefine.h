//
//  BMBadgeDefine.h
//  BMBadgeSample
//
//  Created by jiang deng on 2018/8/17.
//  Copyright © 2018年 DJ. All rights reserved.
//

#ifndef BMBadgeDefine_h
#define BMBadgeDefine_h

#define BMBadgeDefaultMaxBits       2

#define BMBadgeDefaultFont          [UIFont systemFontOfSize:9.0f]
#define BMBadgeDefaultTextColor     [UIColor whiteColor]
#define BMBadgeDefaultBgColor       [UIColor redColor]

#define BMBadgeDefaultBorderColor   [UIColor yellowColor]
#define BMBadgeDefaultBorderWidth   1.0f
//#define BMBadgeDefaultBorderRadius  3.0f
#define BMBadgeDefaultBorderGap     4.0f

#define BMBadgeDefaultRedDotRadius  4.0f

typedef NS_ENUM(NSUInteger, BMBadgeStyle)
{
    BMBadgeStyleRedDot = 0,          /* red dot style */
    BMBadgeStyleNumber,              /* badge with number */
    BMBadgeStyleNew                  /* badge with a fixed text "new" */
};

typedef NS_ENUM(NSUInteger, BMBadgeAnimationType)
{
    BMBadgeAnimationTypeNone = 0,   /* without animation, badge stays still */
    BMBadgeAnimationTypeScale,      /* scale effect */
    BMBadgeAnimationTypeShake,      /* shaking effect */
    BMBadgeAnimationTypeBounce,     /* bouncing effect */
    BMBadgeAnimationTypeBreathe     /* breathing light effect, which makes badge more attractive */
};

typedef NS_ENUM(NSUInteger, BMBadgeHorizontallyAlignment)
{
    // 左
    BMBadgeHorizontallyAlignmentLeft = 0,
    // 中
    BMBadgeHorizontallyAlignmentCenter,
    // Default 右
    BMBadgeHorizontallyAlignmentRight,
};

typedef NS_ENUM(NSUInteger, BMBadgeVerticallyAlignment)
{
    // Default 上
    BMBadgeVerticallyAlignmentTop = 0,
    // 中
    BMBadgeVerticallyAlignmentCenter,
    // 下
    BMBadgeVerticallyAlignmentBottom
};

#endif /* BMBadgeDefine_h */
