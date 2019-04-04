//
//  BMAddressPickerView.h
//  BMBaseKit
//
//  Created by jiang deng on 2019/3/29.
//  Copyright © 2019 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^addressPickerBackCancel)(void);

typedef void(^getAddressList)(NSUInteger level, NSString *code);

@interface BMAddressPickerView : UIView

// title颜色
@property (nonatomic,strong) UIColor *titleColor;
// 选中颜色
@property (nonatomic,strong) UIColor *selectColor;


// 退出回调
@property (nonatomic, copy) addressPickerBackCancel backOnClickClose;

@property (nonatomic, copy) getAddressList getList;

- (void)showHUDWithAnimated:(BOOL)animated;
- (void)hideHUDWithAnimated:(BOOL)animated;
- (void)showHUDWithAnimated:(BOOL)animated detailText:(NSString *)text;

- (void)freshView;

- (void)changeProvinceArray:(NSMutableArray *)provinceArray;
- (void)changeCityArray:(NSMutableArray *)cityArray;
- (void)changeAreaArray:(NSMutableArray *)areaArray;

@end

NS_ASSUME_NONNULL_END
