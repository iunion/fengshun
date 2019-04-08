//
//  FSAddressPickerVC.m
//  fengshun
//
//  Created by jiang deng on 2019/4/3.
//  Copyright © 2019 FS. All rights reserved.
//

#import "FSAddressPickerVC.h"
#import "BMAddressPickerView.h"
#import "BMAddressModel.h"

@interface FSAddressPickerVC ()
{
    NSUInteger currentLevel;
}

@property (nonatomic, strong) BMAddressPickerView *addressPickerView;

@property (nonatomic, strong) NSURLSessionDataTask *m_getListTask;

@end

@implementation FSAddressPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    BMAddressPickerView *view = [[BMAddressPickerView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT*2/5, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT*3/5)];
    BMWeakSelf
    view.backOnClickClose = ^{
        [weakSelf onClickClose];
    };
    view.getList = ^(NSUInteger level, NSString * _Nonnull code) {
        [weakSelf getAddressListWithLevel:level code:code];
    };
    
    [self.view addSubview:view];
    self.addressPickerView = view;
    
    [view freshView];
}

- (void)onClickClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getAddressListWithLevel:(NSUInteger)level code:(NSString *)code
{
    [self.addressPickerView showHUDWithAnimated:YES];
    [self.addressPickerView hideStatusView];
    
    currentLevel = level;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *urlStr = @"https://yundr.gov.cn/mobileInit/getArea";
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters bm_setUInteger:level forKey:@"level"];
    [parameters bm_setApiString:code forKey:@"code"];
    NSMutableURLRequest *request = [FSApiRequest makeRequestWithURL:urlStr parameters:parameters];
    if (request)
    {
        [self.m_getListTask cancel];
        self.m_getListTask = nil;
        
        BMWeakSelf
        self.m_getListTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error)
            {
                BMLog(@"Error: %@", error);
                [weakSelf getListRequestFailed:response error:error];
            }
            else
            {
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
                [weakSelf getListRequestFinished:response responseDic:responseObject];
            }
        }];
        [self.m_getListTask resume];
    }
}

- (void)getListRequestFinished:(NSURLResponse *)response responseDic:(NSDictionary *)resDic
{
    [self.addressPickerView hideHUDWithAnimated:YES];
    
    if (![resDic bm_isNotEmptyDictionary])
    {
        [self.addressPickerView showHUDWithAnimated:YES detailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
        
        if (currentLevel == 1)
        {
            [self.addressPickerView changeProvinceArray:nil];
        }
        else if (currentLevel == 2)
        {
            [self.addressPickerView changeCityArray:nil];
        }
        else if (currentLevel == 3)
        {
            [self.addressPickerView changeAreaArray:nil];
        }
        
        [self.addressPickerView showUnknownError];
        
        return;
    }
    
#ifdef DEBUG
    NSString *responseStr = [[NSString stringWithFormat:@"%@", resDic] bm_convertUnicode];
    BMLog(@"地址返回数据是:+++++%@", responseStr);
#endif
    
    NSInteger statusCode = [resDic bm_intForKey:@"code"];
    if (statusCode == 200)
    {
        BMLog(@"地址成功");
        
        NSArray *dataDicArray = [resDic bm_arrayForKey:@"result"];
        if ([dataDicArray bm_isNotEmpty])
        {
            NSMutableArray *addressArray = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dataDic in dataDicArray)
            {
                if (currentLevel == 1)
                {
                    BMProvinceAddressModel *provinceAddressModel = [BMProvinceAddressModel provinceAddressWithServerDic:dataDic];
                    if (provinceAddressModel)
                    {
                        [addressArray addObject:provinceAddressModel];
                    }
                }
                else if (currentLevel == 2)
                {
                    BMCityAddressModel *cityAddressModel = [BMCityAddressModel cityAddressWithServerDic:dataDic];
                    if (cityAddressModel)
                    {
                        [addressArray addObject:cityAddressModel];
                    }
                }
                else if (currentLevel == 3)
                {
                    BMAddressModel *addressModel = [BMAddressModel addressWithServerDic:dataDic];
                    if (addressModel)
                    {
                        [addressArray addObject:addressModel];
                    }
                }
            }
            
            if (addressArray)
            {
                if (currentLevel == 1)
                {
                    [self.addressPickerView changeProvinceArray:addressArray];
                }
                else if (currentLevel == 2)
                {
                    [self.addressPickerView changeCityArray:addressArray];
                }
                else if (currentLevel == 3)
                {
                    [self.addressPickerView changeAreaArray:addressArray];
                }
            }
        }
        
        return;
    }
    
    NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
    BMLog(@"%@", message);

    [self.addressPickerView showHUDWithAnimated:YES detailText:message];
    
    if (currentLevel == 1)
    {
        [self.addressPickerView changeProvinceArray:nil];
    }
    else if (currentLevel == 2)
    {
        [self.addressPickerView changeCityArray:nil];
    }
    else if (currentLevel == 3)
    {
        [self.addressPickerView changeAreaArray:nil];
    }
    
    [self.addressPickerView showServerError];
}

- (void)getListRequestFailed:(NSURLResponse *)response error:(NSError *)error
{
    [self.addressPickerView showHUDWithAnimated:YES detailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE]];
    
    if (currentLevel == 1)
    {
        [self.addressPickerView changeProvinceArray:nil];
    }
    else if (currentLevel == 2)
    {
        [self.addressPickerView changeCityArray:nil];
    }
    else if (currentLevel == 3)
    {
        [self.addressPickerView changeAreaArray:nil];
    }
    
    [self.addressPickerView showNetworkError];
}

@end
