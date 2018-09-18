//
//  MDTViewCallView.h
//  ODR
//
//  Created by DH on 2018/8/10.
//  Copyright © 2018年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifdef FSVIDEO_ON
#import <ILiveSDK/ILiveCoreHeader.h>
#endif

/**
 视屏窗口
 */
@class VideoCallMemberModel;
@protocol VideoCallVideoViewDelegate;
@interface VideoCallVideoView : UIView
@property (nonatomic, strong) VideoCallMemberModel *model;
@property(nonatomic, weak) id <VideoCallVideoViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *redPointImgView;
@property (nonatomic, strong) UIButton *pirChatBtn;
@property (nonatomic, strong) UIView *avPackView;
@property (nonatomic, strong) UIButton *videoBtn;
@property (nonatomic, strong) UIButton *audioBtn;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UILabel *nameLabel;
//@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@property (nonatomic, strong, readonly) ILiveRenderView *renderView;
@property (nonatomic, copy, readonly) NSString *userId;

@property (nonatomic, strong) UIImageView *videoClosedView;

- (instancetype)initWithRenderView:(ILiveRenderView *)renderView model:(VideoCallMemberModel *)model;
- (void)reloadData;
- (void)isShowRedPoint:(BOOL)isShow;
//- (void)loadFinished;
@end

@protocol VideoCallVideoViewDelegate <NSObject>
@optional;
- (void)videoCallVideoView:(VideoCallVideoView *)view priChatBtnDidClick:(VideoCallMemberModel *)member;
- (void)videoCallVideoView:(VideoCallVideoView *)view avPackViewDidTap:(VideoCallMemberModel *)model;
@end

/**
 视屏窗口容器
 */
@interface VideoCallPackView : UIView
- (void)adjustLayout;
- (VideoCallVideoView *)elementForUserId:(NSString *)useId;
@end


/**
 顶部工具条
 */
@protocol VideoCallTopBarDelegate;
@interface VideoCallTopBar : UIView
@property(nonatomic, weak) id <VideoCallTopBarDelegate>delegate;

/**
 设置某个按钮状态
 
 @param isSelected 选中状态
 @param index 第几个按钮
 */
- (void)setBtnIsSelected:(BOOL)isSelected index:(NSInteger )index;
- (BOOL)getBtnSelectedStatusWithIndex:(NSInteger)index;
@end

@protocol VideoCallTopBarDelegate <NSObject>
@optional
- (void)videoCallTopBarDidClick:(VideoCallTopBar *)topBar index:(NSInteger)index;
@end



/**
 底部工具条
 */
@protocol VideoCallBottomBarDelegate;
@interface VideoCallBottomBar : UIView
@property(nonatomic,weak)id <VideoCallBottomBarDelegate> delegate;
@end

@protocol VideoCallBottomBarDelegate <NSObject>
@optional
/**
 底部按钮点击
 
 @param bottomBar VideoCallBottomBar
 @param index 按钮点击从左到右 0...index
 */
- (void)videoCallBottomBar:(VideoCallBottomBar *)bottomBar index:(NSInteger)index;
@end

