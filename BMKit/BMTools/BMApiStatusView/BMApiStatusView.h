//
//  BMApiStatusView.h
//  fengshun
//
//  Created by jiang deng on 2019/4/4.
//  Copyright © 2019 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BMApiStatus)
{
    BMApiStatus_Hidden = 0,
    BMApiStatus_ServerError, ///< 服务器数据错误code500
    BMApiStatus_NoData, ///< 空数据界面
    BMApiStatus_NetworkError, ///< 网络连接错误 code
    BMApiStatus_UnknownError, ///< 发生未知错误
    BMApiStatus_NoUserInteractiveHidden, ///< 看起来是隐藏的，并且不允许交互
    BMApiStatus_Custom ///< 用户自定义
};

@protocol BMApiStatusViewDelegate;

@interface BMApiStatusView : UIView

@property (nonatomic, weak) id <BMApiStatusViewDelegate> delegate;

@property (nonatomic, assign, readonly) BMApiStatus loadingStatus;

- (instancetype)initWithView:(UIView *)fatherView delegate:(id <BMApiStatusViewDelegate>)delegate;

- (void)showWithStatus:(BMApiStatus)status;
- (void)hide;

@end

@protocol BMApiStatusViewDelegate <NSObject>

- (void)apiStatusViewDidTap:(BMApiStatusView *)statusView;

@end

NS_ASSUME_NONNULL_END
