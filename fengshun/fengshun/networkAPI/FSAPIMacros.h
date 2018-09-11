//
//  FSAPIMacros.h
//  fengshun
//
//  Created by jiang deng on 2018/8/27.
//  Copyright © 2018年 FS. All rights reserved.
//

#ifndef FSAPIMacros_h
#define FSAPIMacros_h

#define FS_URL_SERVER       (@"https://devftls.odrcloud.net")

#define FS_H5_SERVER        (@"https://devftlsh5.odrcloud.net")

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
