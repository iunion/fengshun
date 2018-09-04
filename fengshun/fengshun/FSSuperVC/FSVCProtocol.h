//
//  FSVCProtocol.h
//  fengshun
//
//  Created by jiang deng on 2018/8/25.
//  Copyright © 2018年 FS. All rights reserved.
//

#ifndef FSVCProtocol_h
#define FSVCProtocol_h

@protocol FSSuperVCProtocol <NSObject>

@required

// backAction前操作, 包含手势返回(可用手势返回时)
- (BOOL)shouldPopOnBackButton;
- (void)backAction:(id)sender;
- (void)backRootAction:(id)sender;

@optional

@end


@protocol FSSuperNetVCProtocol <NSObject>

@required

// 刷新数据
- (BOOL)canLoadApiData;
- (void)loadApiData;

// 设置具体的API请求
- (NSMutableURLRequest *)setLoadDataRequest;
- (NSMutableURLRequest *)setLoadDataRequestWithFresh:(BOOL)isLoadNew;
// API请求成功的代理方法
- (void)loadDataResponseFinished:(NSURLResponse *)response responseDic:(NSDictionary *)responseDic;
// API请求失败的代理方法，一般不需要重写
- (void)loadDataResponseFailed:(NSURLResponse *)response error:(NSError *)error;

// 处理成功的数据使用succeedLoadedRequestWithDic:
- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)requestDic;
- (BOOL)succeedLoadedRequestWithArray:(NSArray *)requestArray;

// 全部失败情况适用
- (void)failLoadedResponse:(NSURLResponse *)response responseDic:(NSDictionary *)responseDic withErrorCode:(NSInteger)errorCode;

// 将等待和错误提示等上移
- (void)bringSomeViewToFront;

@optional

// 获取下一页
- (void)loadNextApiData;

// 全部获取数据判断
- (BOOL)checkLoadFinish:(NSDictionary *)requestDic;

- (void)loadDateFinished:(BOOL)isNoMoreData;

@end

#endif /* FSVCProtocol_h */
