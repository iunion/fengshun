//
//  BMTestAlignManager.m
//  fengshun
//
//  Created by jiang deng on 2018/11/28.
//  Copyright © 2018 FS. All rights reserved.
//

#import "BMTestAlignManager.h"
#import "BMTestAlignView.h"
#import "BMConsole.h"

@interface BMTestAlignManager ()

@property (nonatomic, strong) BMTestAlignView *alignView;

@end

@implementation BMTestAlignManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static BMTestAlignManager *instance;
    dispatch_once(&once, ^{
        instance = [[BMTestAlignManager alloc] init];
    });
    return instance;
}

- (void)show
{
#if USE_TEST_HELP
    if (!self.alignView)
    {
        self.alignView = [[BMTestAlignView alloc] init];
        UIWindow *delegateWindow = [[UIApplication sharedApplication].delegate window];
        if (delegateWindow && [delegateWindow isKindOfClass:[BMConsoleWindow class]])
        {
            [delegateWindow addSubview:self.alignView];
        }
    }
    
    [self.alignView bm_bringToFront];
#endif
}

- (void)close
{
    [self.alignView removeFromSuperview];
    self.alignView = nil;
}

- (BOOL)isShow
{
    return self.alignView != nil;
}

@end
