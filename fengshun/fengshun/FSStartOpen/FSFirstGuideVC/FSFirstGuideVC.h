//
//  FSFirstGuideVC.h
//  fengshun
//
//  Created by jiang deng on 2018/9/21.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSuperVC.h"

@protocol FSFirstGuideVCDelegate;

@interface FSFirstGuideVC : FSSuperVC

@property (nonatomic, weak) id<FSFirstGuideVCDelegate> delegate;

@end

@protocol FSFirstGuideVCDelegate <NSObject>

- (void)showFirstGuideVCFinish;

@end
