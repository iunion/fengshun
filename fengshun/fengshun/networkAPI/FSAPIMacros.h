//
//  FSAPIMacros.h
//  fengshun
//
//  Created by jiang deng on 2018/8/27.
//  Copyright © 2018年 FS. All rights reserved.
//

#ifndef FSAPIMacros_h
#define FSAPIMacros_h

#if USE_TEST_HELP

// 开发环境
#define FS_URL_SERVER_DEV       (@"https://devftls.odrcloud.net")
#define FS_H5_SERVER_DEV        (@"https://devftlsh5.odrcloud.net")
#define FS_FILE_ADRESS_DEV      (@"/storm/file/download/")

// 测试环境
#define FS_URL_SERVER_TEST      (@"https://testapi.bjsjsadr.com")
#define FS_H5_SERVER_TEST       (@"https://devftls.odrcloud.net")
//#define FS_H5_SERVER_TEST        (@"https://devftlsh5.odrcloud.net")
#define FS_FILE_ADRESS_TEST     (@"/storm/file/download/")

// 线上环境
#define FS_URL_SERVER_ONLINE    (@"https://ftlsh5.odrcloud.cn")
#define FS_H5_SERVER_ONLINE     (@"https://ftlsh5.odrcloud.cn")
#define FS_FILE_ADRESS_ONLINE   (@"/storm/file/download/")

#define FS_URL_SERVER_INIT      FS_URL_SERVER_DEV
#define FS_H5_SERVER_INIT       FS_H5_SERVER_DEV
#define FS_FILE_ADRESS_INIT     FS_FILE_ADRESS_DEV

#define FS_URL_SERVER_KEY       (@"debug_api_server")
#define FS_URL_SERVER           [[NSUserDefaults standardUserDefaults] objectForKey:FS_URL_SERVER_KEY]

#define FS_H5_SERVER_KEY        (@"debug_h5_server")
#define FS_H5_SERVER            [[NSUserDefaults standardUserDefaults] objectForKey:FS_H5_SERVER_KEY]

#define FS_FILE_ADRESS_KEY      (@"debug_file_adress")
#define FS_FILE_ADRESS          [[NSUserDefaults standardUserDefaults] objectForKey:FS_FILE_ADRESS_KEY]

#else

#define FS_URL_SERVER       (@"https://ftlsh5.odrcloud.cn")
#define FS_H5_SERVER        (@"https://ftlsh5.odrcloud.cn")
//#define FS_H5_SERVER        (@"https://devftlsh5.odrcloud.net")
#define FS_FILE_ADRESS      (@"/storm/file/download/")

#endif


// 一般API超时时间
#define FSAPI_TIMEOUT_SECONDS               (30.0f)
// 数据上传超时时间
#define FSAPI_UPLOADIMAGE_TIMEOUT_SECONDS   (60.0f)
// 重试一次，即调用二次
#define FSAPI_TIMEOUT_RETRY_COUNT           (0)

//gps
#define FSAPI_GPS_LATITUDE_KEY              (@"latitude")
#define FSAPI_GPS_LONGITUDE_KEY             (@"longitude")


#define FSAPI_NET_ERRORCODE                 -100
#define FSAPI_DATA_ERRORCODE                -101
#define FSAPI_JSON_ERRORCODE                -102

// 每次加载数据的方式 按页取/按个数取, 默认: FSAPILoadDataType_Count
typedef NS_ENUM(NSUInteger, FSAPILoadDataType)
{
    FSAPILoadDataType_Count,
    FSAPILoadDataType_Page = 1,
};


#endif /* FSAPIMacros_h */
