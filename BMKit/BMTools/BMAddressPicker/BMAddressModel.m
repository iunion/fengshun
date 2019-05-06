//
//  BMAddressModel.m
//  BMBaseKit
//
//  Created by jiang deng on 2019/3/29.
//  Copyright © 2019 BM. All rights reserved.
//

#import "BMAddressModel.h"

@implementation BMAddressModel

+ (nullable instancetype)addressWithServerDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return nil;
    }
    
    NSString *code = [dic bm_stringTrimForKey:@"code"];
    if (![code bm_isNotEmpty])
    {
        return nil;
    }
    
    BMAddressModel *addressModel = [[BMAddressModel alloc] init];
    [addressModel updateWithServerDic:dic];
    
    if ([addressModel.code bm_isNotEmpty])
    {
        return addressModel;
    }
    else
    {
        return nil;
    }
}

- (void)updateWithServerDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return;
    }
    
    // 地址编码 code
    // code不存在不修改
    NSString *code = [dic bm_stringTrimForKey:@"code"];
    if (![code bm_isNotEmpty])
    {
        return;
    }
    self.code = code;

    // 地址名 name
    self.name = [dic bm_stringTrimForKey:@"name"];
    
    // 详细地址 fullName
    //self.fullName = [dic bm_stringTrimForKey:@"fullName"];
    
    // parentCode
    //self.parentCode = [dic bm_stringTrimForKey:@"parentCode"];
}

- (BMCityAddressModel *)cityAddress
{
    return self.precinct;
}

- (void)setCityAddress:(BMCityAddressModel *)cityAddress
{
    self.precinct = cityAddress;
}

@end


@implementation BMProvinceAddressModel

+ (nullable instancetype)provinceAddressWithServerDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return nil;
    }
    
    NSString *code = [dic bm_stringTrimForKey:@"code"];
    if (![code bm_isNotEmpty])
    {
        return nil;
    }
    
    BMProvinceAddressModel *provinceAddressModel = [[BMProvinceAddressModel alloc] init];
    [provinceAddressModel updateWithServerDic:dic];
    
    if ([provinceAddressModel.code bm_isNotEmpty])
    {
        return provinceAddressModel;
    }
    else
    {
        return nil;
    }
}

- (void)updateWithServerDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return;
    }
    
    // code不存在不修改
    NSString *code = [dic bm_stringTrimForKey:@"code"];
    if (![code bm_isNotEmpty])
    {
        return;
    }
    self.code = code;
    
    self.name = [dic bm_stringTrimForKey:@"name"];
    
    NSArray *dataDicArray = [dic bm_arrayForKey:@"citys"];
    if ([dataDicArray bm_isNotEmpty])
    {
        NSMutableArray *cityArray  = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dataDic in dataDicArray)
        {
            BMCityAddressModel *cityAddressModel = [BMCityAddressModel cityAddressWithServerDic:dataDic];
            if (cityAddressModel)
            {
                [cityArray addObject:cityAddressModel];
            }
        }
        
        if ([cityArray bm_isNotEmpty])
        {
            self.cityArray = cityArray;
        }
    }
}

@end


@implementation BMCityAddressModel

+ (nullable instancetype)cityAddressWithServerDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return nil;
    }
    
    NSString *code = [dic bm_stringTrimForKey:@"code"];
    if (![code bm_isNotEmpty])
    {
        return nil;
    }
    
    BMCityAddressModel *cityAddressModel = [[BMCityAddressModel alloc] init];
    [cityAddressModel updateWithServerDic:dic];
    
    if ([cityAddressModel.code bm_isNotEmpty])
    {
        return cityAddressModel;
    }
    else
    {
        return nil;
    }
}

- (void)updateWithServerDic:(NSDictionary *)dic
{
    if (![dic bm_isNotEmptyDictionary])
    {
        return;
    }
    
    // code不存在不修改
    NSString *code = [dic bm_stringTrimForKey:@"code"];
    if (![code bm_isNotEmpty])
    {
        return;
    }
    self.code = code;
    
    self.name = [dic bm_stringTrimForKey:@"name"];
    
    NSArray *dataDicArray = [dic bm_arrayForKey:@"areas"];
    if ([dataDicArray bm_isNotEmpty])
    {
        NSMutableArray *areaArray  = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dataDic in dataDicArray)
        {
            BMAddressModel *addressModel = [BMAddressModel addressWithServerDic:dataDic];
            if (addressModel)
            {
                [areaArray addObject:addressModel];
            }
        }
        
        if ([areaArray bm_isNotEmpty])
        {
            self.areaArray = areaArray;
        }
    }
}

- (BMProvinceAddressModel *)provinceAddress
{
    return self.precinct;
}

- (void)setProvinceAddress:(BMProvinceAddressModel *)provinceAddress
{
    self.precinct = provinceAddress;
}

@end

@implementation BMChooseAddressModel

@end
