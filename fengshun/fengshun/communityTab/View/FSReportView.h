//
//  FSReportView.h
//  fengshun
//
//  Created by best2wa on 2018/9/19.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSReportViewDelegate;
@class FSReportView;

@interface FSReportView : UIView

+ (void)showReportView:(id<FSReportViewDelegate>)delegate;

- (instancetype)initWithFrame:(CGRect)frame btnTitleArr:(NSArray *)btnTitleArr cancelTitle:(NSString *)cancelTitle;

@property (nonatomic, weak)id<FSReportViewDelegate> delegate;

@end

@protocol FSReportViewDelegate<NSObject>

@optional

- (void)alertViewClick:(FSReportView *)aView index:(NSInteger )index;

- (void)cancelAlertView:(FSReportView *)aView;

@end
