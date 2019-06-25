//
//  BMTestColorPickerManager.m
//  fengshun
//
//  Created by jiang deng on 2018/11/30.
//  Copyright © 2018 FS. All rights reserved.
//

#import "BMTestColorPickerManager.h"
#import "BMTestColorPickerView.h"
#import "BMConsole.h"

@interface BMTestColorPickerManager ()

@property (nonatomic, strong) BMTestColorPickerView *colorPickerView;

@end

@implementation BMTestColorPickerManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static BMTestColorPickerManager *instance;
    dispatch_once(&once, ^{
        instance = [[BMTestColorPickerManager alloc] init];
    });
    return instance;
}

- (void)show
{
#if USE_TEST_HELP
    if (!self.colorPickerView)
    {
        self.colorPickerView = [[BMTestColorPickerView alloc] init];
        UIWindow *delegateWindow = [[UIApplication sharedApplication].delegate window];
        if (delegateWindow && [delegateWindow isKindOfClass:[BMConsoleWindow class]])
        {
            [delegateWindow addSubview:self.colorPickerView];
            self.colorPickerView.window = delegateWindow;
            [self.colorPickerView setCurrentColorWithHexStr:@"0xFF1010"];
            [self.colorPickerView bm_centerInSuperView];
        }
    }
    
    [self.colorPickerView bm_bringToFront];
#endif
}

- (void)close
{
    [self.colorPickerView removeFromSuperview];
    self.colorPickerView = nil;
}

- (BOOL)isShow
{
    return self.colorPickerView != nil;
}

@end
