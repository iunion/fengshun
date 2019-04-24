//
//  BMAddressModel.h
//  BMBaseKit
//
//  Created by jiang deng on 2019/3/29.
//  Copyright © 2019 BM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BMProvinceAddressModel;
@class BMCityAddressModel;

@interface BMAddressModel : NSObject

// 地址编码
@property (nonatomic, strong) NSString *code;
// 地址名
@property (nonatomic, strong) NSString *name;

// BMProvinceAddressModel, BMCityAddressModel
@property (nullable, nonatomic, weak) id precincts;

// UI
// 是否选中
@property (nonatomic, assign) BOOL isSelected;


+ (nullable instancetype)addressWithServerDic:(NSDictionary *)dic;
- (void)updateWithServerDic:(NSDictionary *)dic;

- (nullable BMCityAddressModel *)cityAddress;
- (void)setCityAddress:(nullable BMCityAddressModel *)cityAddress;

@end


@interface BMProvinceAddressModel : BMAddressModel

// 城市列表
@property (nonatomic, strong) NSArray<BMAddressModel *> *cityArray;

+ (nullable instancetype)provinceAddressWithServerDic:(NSDictionary *)dic;
- (void)updateWithServerDic:(NSDictionary *)dic;

@end


@interface BMCityAddressModel : BMAddressModel

// 区域列表
@property (nonatomic, strong) NSArray<BMAddressModel *> *areaArray;

+ (nullable instancetype)cityAddressWithServerDic:(NSDictionary *)dic;
- (void)updateWithServerDic:(NSDictionary *)dic;

- (nullable BMProvinceAddressModel *)provinceAddress;
- (void)setProvinceAddress:(nullable BMProvinceAddressModel *)provinceAddress;

@end


@interface BMChooseAddressModel : NSObject

// 省份
@property (nullable, nonatomic, strong) BMProvinceAddressModel *province;

// 城市
@property (nullable, nonatomic, strong) BMCityAddressModel *city;

// 地区
@property (nullable, nonatomic, strong) BMAddressModel *area;

@end

NS_ASSUME_NONNULL_END
