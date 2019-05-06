//
//  BMAddressPickerView.h
//  BMBaseKit
//
//  Created by jiang deng on 2019/3/29.
//  Copyright © 2019 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BMChooseAddressModel;

typedef void(^addressPickerBackCancel)(void);
typedef void(^getAddressList)(NSUInteger level, NSString *code);

typedef void(^addressPickerFinished)(BMChooseAddressModel *address, NSString *addressString);

@class BMChooseAddressModel;

@interface BMAddressPickerView : UIView

// title颜色
@property (nonatomic,strong) UIColor *titleColor;
// 选中颜色
@property (nonatomic,strong) UIColor *selectColor;

// 省份
@property (nonatomic, strong, readonly) NSMutableArray *provinceArray;
// 已选地址
@property (nonatomic, strong, readonly) BMChooseAddressModel *chooseAddress;
@property (nonatomic, assign, readonly) NSUInteger currentLevel;

// 退出回调
@property (nonatomic, copy) addressPickerBackCancel backOnClickClose;

@property (nonatomic, copy) getAddressList getList;

@property (nonatomic, copy) addressPickerFinished pickFinished;

- (void)freshView;

- (void)changeProvinceArray:(nullable NSMutableArray *)provinceArray;
- (void)changeCityArray:(nullable NSMutableArray *)cityArray;
- (void)changeAreaArray:(nullable NSMutableArray *)areaArray;

- (void)showHUDWithAnimated:(BOOL)animated;
- (void)hideHUDWithAnimated:(BOOL)animated;
- (void)showHUDWithAnimated:(BOOL)animated detailText:(NSString *)text;

- (void)hideStatusView;
- (void)showNetworkError;
- (void)showServerError;
- (void)showUnknownError;
- (void)showNoData;

@end

NS_ASSUME_NONNULL_END
