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
#define FS_FILE_ADDRESS_DEV     (@"/storm/file/download/")
//#define FS_CASE_STATUTE_DEV     (@"https://lawsearch-pre.odrcloud.cn")
#define FS_CASE_STATUTE_DEV     (@"https://lawsearch-ftls-pre.odrcloud.cn")
#define FS_AI_SERVER_DEV        (@"https://robot.odrcloud.cn")

// 测试环境
#define FS_URL_SERVER_TEST      (@"https://testftls.odrcloud.cn")
#define FS_H5_SERVER_TEST       (@"https://testftlsh5.odrcloud.cn")
#define FS_FILE_ADDRESS_TEST    (@"/storm/file/download/")
//#define FS_CASE_STATUTE_TEST    (@"https://lawsearch-pre.odrcloud.cn")
#define FS_CASE_STATUTE_TEST    (@"https://lawsearch-ftls-pre.odrcloud.cn")
#define FS_AI_SERVER_TEST       (@"https://robot.odrcloud.cn")

// 线上环境
#define FS_URL_SERVER_ONLINE    (@"https://ftlsh5.odrcloud.cn")
#define FS_H5_SERVER_ONLINE     (@"https://ftlsh5.odrcloud.cn")
#define FS_FILE_ADDRESS_ONLINE  (@"/storm/file/download/")
//#define FS_CASE_STATUTE_ONLINE  (@"https://lawsearch.odrcloud.cn")
#define FS_CASE_STATUTE_ONLINE  (@"https://lawsearch-ftls.odrcloud.cn")
#define FS_AI_SERVER_ONLINE     (@"https://robot.odrcloud.cn")

#define FS_URL_SERVER_INIT      FS_URL_SERVER_DEV
#define FS_H5_SERVER_INIT       FS_H5_SERVER_DEV
#define FS_FILE_ADDRESS_INIT    FS_FILE_ADDRESS_DEV
#define FS_CASE_STATUTE_INIT    FS_CASE_STATUTE_DEV
#define FS_AI_SERVER_INIT       FS_AI_SERVER_DEV

#define FS_URL_SERVER_KEY       (@"debug_api_server")
#define FS_URL_SERVER           [[NSUserDefaults standardUserDefaults] objectForKey:FS_URL_SERVER_KEY]

#define FS_H5_SERVER_KEY        (@"debug_h5_server")
#define FS_H5_SERVER            [[NSUserDefaults standardUserDefaults] objectForKey:FS_H5_SERVER_KEY]

#define FS_FILE_ADDRESS_KEY     (@"debug_file_address")
#define FS_FILE_ADDRESS         [[NSUserDefaults standardUserDefaults] objectForKey:FS_FILE_ADDRESS_KEY]

// v1.1法规及案例检索变更为专门的服务器提供的服务,相关接口请求域名变更
#define FS_CASE_STATUTE_URL_KEY (@"debug_case_statute_h5")
#define FS_CASE_STATUTE_URL     [[NSUserDefaults standardUserDefaults] objectForKey:FS_CASE_STATUTE_URL_KEY]

#define FS_AI_SERVER_KEY        (@"debug_ai_server")
#define FS_AI_SERVER            [[NSUserDefaults standardUserDefaults] objectForKey:FS_AI_SERVER_KEY]

#else

#define FS_URL_SERVER           (@"https://ftlsh5.odrcloud.cn")
#define FS_H5_SERVER            (@"https://ftlsh5.odrcloud.cn")
//#define FS_H5_SERVER        (@"https://devftlsh5.odrcloud.net")

#define FS_FILE_ADDRESS         (@"/storm/file/download/")
//#define FS_CASE_STATUTE_URL     (@"https://lawsearch.odrcloud.cn")
//#define FS_CASE_STATUTE_URL     (@"https://lawsearch-ftls.odrcloud.cn")
#define FS_AI_SERVER            (@"https://robot.odrcloud.cn")

#define FS_CASE_STATUTE_URL_KEY (@"online_case_statute_h5")
#define FS_CASE_STATUTE_INIT    (@"https://lawsearch-ftls.odrcloud.cn")
//#define FS_CASE_STATUTE_URL             [[[NSUserDefaults standardUserDefaults] objectForKey:FS_CASE_STATUTE_URL_KEY] bm_isNotEmpty] ? [[NSUserDefaults standardUserDefaults] objectForKey:FS_CASE_STATUTE_URL_KEY] : FS_CASE_STATUTE_INIT
#define FS_CASE_STATUTE_URL     [[NSUserDefaults standardUserDefaults] objectForKey:FS_CASE_STATUTE_URL_KEY]

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
