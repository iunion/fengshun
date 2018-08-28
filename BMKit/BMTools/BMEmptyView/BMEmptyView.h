//
//  BMEmptyView.h
//  DJTableFreshViewSample
//
//  Created by ILLA on 2018/8/9.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BMEmptyView;

typedef NS_ENUM(NSUInteger, BMEmptyViewStatus) {
    BMEmptyViewStatus_Hidden = 0,   // 完全隐藏视图
    BMEmptyViewStatus_SysError,     // 系统错误
    BMEmptyViewStatus_Loading,      // 加载中状态，只在中心显示一个菊花
    BMEmptyViewStatus_NoData,       // 显示无数据文本提示+刷新按钮
    BMEmptyViewStatus_NetworkError, // 无网络连接，请检查网络+刷新按钮
    BMEmptyViewStatus_ServerError,  // 服务器连接失败
    BMEmptyViewStatus_DataError,    // 显示数据错误+刷新按钮
    BMEmptyViewStatus_UnknownError, // 显示未知错误+刷新按钮
    BMEmptyViewStatus_Custom        // 自定义
};

typedef void (^BMEmptyViewActionBlock)(BMEmptyView *emptyView, BMEmptyViewStatus state);

@interface BMEmptyView : UIView

+ (instancetype)EmptyViewWith:(UIView *)superView
                        frame:(CGRect)frame
                 refreshBlock:(BMEmptyViewActionBlock)block;

- (void)setEmptyViewStatus:(BMEmptyViewStatus)status;
- (void)setEmptyViewActionBlock:(BMEmptyViewActionBlock)actionBlock;

- (void)setFullViewTapEnable:(BOOL)enable;

@end
