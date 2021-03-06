//
//  FSAlertView.m
//  fengshun
//
//  Created by jiang deng on 2018/9/17.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSAlertView.h"

@interface FSAlertView ()

@end

@implementation FSAlertView

- (instancetype)initWithIcon:(NSString *)iconName
                       title:(id)title
                     message:(id)message
                 contentView:(UIView *)contentView
                 cancelTitle:(nullable NSString *)cancelTitle
                 otherTitles:(NSArray<NSString *> *)otherTitles
          buttonsShouldStack:(BOOL)shouldStack
                  completion:(BMAlertViewCompletionBlock)completion
{
    self = [super initWithIcon:iconName title:title message:message contentView:contentView cancelTitle:cancelTitle otherTitles:otherTitles buttonsShouldStack:shouldStack completion:completion];
    
    if (self)
    { 
        self.alertBgColor       = [UIColor whiteColor];
        self.alertMarkBgColor   = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
        self.alertMarkBgEffect  = nil;
        self.alertTitleFont     = [UIFont systemFontOfSize:18.f];
        self.alertTitleColor    = [UIColor bm_colorWithHex:0x333333];
        self.alertMessageFont   = [UIFont systemFontOfSize:14.f];
        self.alertMessageColor  = [UIColor bm_colorWithHex:0x333333];
        self.cancleBtnBgColor   = [UIColor whiteColor];
        self.otherBtnBgColor    = [UIColor whiteColor];
        self.cancleBtnTextColor = [UIColor bm_colorWithHex:0x999999];
        self.otherBtnTextColor  = [UIColor bm_colorWithHex:0x577EEE];
        self.btnFont            = [UIFont systemFontOfSize:16.f];
        self.alertGapLineColor  = [UIColor bm_colorWithHex:0xD8D8D8];
        self.showAnimationType  = BMAlertViewShowAnimationFadeIn;
        self.hideAnimationType  = BMAlertViewHideAnimationFadeOut;
        self.shouldDismissOnTapOutside = YES;
        self.showClose = YES;
    }
    
    return self;
}

@end
