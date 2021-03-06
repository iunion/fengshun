//
//  UIViewController+VideoCall.m
//  ODR
//
//  Created by DH on 2018/8/15.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "UIViewController+VideoCall.h"
#import "ASRManager.h"

@implementation VideoCallController (VideoCall)

//#pragma mark - privte
- (void)vc_showMessage:(NSString *)msg {
    
    __block MASConstraint *labelTopMas;
    
    UILabel *label = [UILabel new];
    label.text = msg;
    label.font = UI_FONT_16;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = UI_COLOR_BL1;
    [self.view insertSubview:label belowSubview:self.topBar];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(35);
        make.left.right.equalTo(self.view);
        labelTopMas = make.top.equalTo(self.topBar.mas_bottom).offset(-35);
    }];
    
    [self.view layoutIfNeeded];
    [labelTopMas uninstall];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        labelTopMas = make.top.equalTo(self.topBar.mas_bottom).offset(0);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view layoutIfNeeded];
        [labelTopMas uninstall];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            labelTopMas = make.top.equalTo(self.topBar.mas_bottom).offset(-35);
        }];
        [UIView animateWithDuration:0.25 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

@end
