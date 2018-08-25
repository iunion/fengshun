//
//  FASuperVC.h
//  fengshun
//
//  Created by jiang deng on 2018/8/25.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FSVCProtocol.h"

@interface FASuperVC : UIViewController
<
    FSSuperVCProtocol
>

// 是否使用手势返回，bm_CanBackInteractive设置



@end
