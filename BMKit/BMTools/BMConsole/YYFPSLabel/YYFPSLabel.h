//
//  YYFPSLabel.h
//  YYKitExample
//
//  Created by ibireme on 15/9/3.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#if USE_TEST_HELP

#import <UIKit/UIKit.h>

/**
 Show Screen FPS...
 
 The maximum fps in OSX/iOS Simulator is 60.00.
 The maximum fps on iPhone is 59.97.
 The maxmium fps on iPad is 60.0.
 */

typedef NS_OPTIONS(NSUInteger, YYFPSLabelType)
{
    YYFPSLabelType_FPS = 0,
    YYFPSLabelType_CPU = 1 << 0,
    YYFPSLabelType_MEM = 1 << 1,
    YYFPSLabelType_ALL = YYFPSLabelType_CPU | YYFPSLabelType_MEM,
};


@interface YYFPSLabel : UILabel

@property (nonatomic, assign) YYFPSLabelType type;

@end

#endif
