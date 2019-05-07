//
//  BMEmptyView.h
//  DJTableFreshViewSample
//
//  Created by ILLA on 2018/8/9.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BMEmptyView;

typedef NS_ENUM(NSUInteger, BMEmptyViewType) {
    BMEmptyViewType_NoData = 0,       // 显示无数据文本提示+刷新按钮
    BMEmptyViewType_NetworkError,     // 无网络连接，请检查网络+刷新按钮
    BMEmptyViewType_SysError,         // 系统错误
    BMEmptyViewType_ServerError,      // 服务器连接失败
    BMEmptyViewType_DataError,        // 显示数据错误
    BMEmptyViewType_Video,            // 视频调解
    BMEmptyViewType_Comment,          // 评论
    BMEmptyViewType_Topic,            // 帖子
    BMEmptyViewType_Search,           // 搜索结果
    BMEmptyViewType_CollectCASE,      // 收藏案例
    BMEmptyViewType_CollectSTATUTE,   // 收藏法规
    BMEmptyViewType_CollectPOSTS,     // 收藏帖子
    BMEmptyViewType_CollectCOLUMN,    // 收藏专题
    BMEmptyViewType_CollectDOCUMENT,  // 收藏文书范本
    BMEmptyViewType_CollectCOURSE,    // 收藏课程
    BMEmptyViewType_Ocr,              // 扫描
    BMEmptyViewType_OcrSearch,        // 扫描结果
    BMEmptyViewType_UnknownError,     // 显示未知错误+刷新按钮
    BMEmptyViewType_Custom            // 自定义
};

typedef void (^BMEmptyViewActionBlock)(BMEmptyView *emptyView, BMEmptyViewType type);

@interface BMEmptyView : UIView

@property (nonatomic, strong) NSString *customImageName;
@property (nonatomic, strong) NSString *customMessage;
@property (nonatomic, strong) NSString *customFreshMessage;

@property (nonatomic, assign) BOOL freshBtnUp;

+ (instancetype)EmptyViewWith:(UIView *)superView
                        frame:(CGRect)frame
                 refreshBlock:(BMEmptyViewActionBlock)block;

- (void)updateViewFrame;

- (void)setCenterTopOffset:(CGFloat)topOffset;
- (void)setCenterLeftOffset:(CGFloat)leftOffset;

- (void)setEmptyViewLoading:(BOOL)loading;

- (void)setEmptyViewType:(BMEmptyViewType)type;
- (void)setEmptyViewActionBlock:(BMEmptyViewActionBlock)actionBlock;

- (void)setFullViewTapEnable:(BOOL)enable;

// 无数据页面的自定义视图，永远在无数据页面最顶部，高度同自定义视图并居中
- (void)setCustomView:(UIView *)customView;

@end
