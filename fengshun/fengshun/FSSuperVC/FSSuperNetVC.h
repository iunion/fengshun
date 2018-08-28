//
//  FSSuperNetVC.h
//  fengshun
//
//  Created by jiang deng on 2018/8/27.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSuperVC.h"
#import "FSApiRequest.h"
#import "MBProgressHUD.h"

@interface FSSuperNetVC : FSSuperVC
<
    FSSuperNetVCProtocol
>

// 网络等待
@property (nonatomic, strong) MBProgressHUD *m_ProgressHUD;

// 显示等待开关
@property (nonatomic, assign) BOOL m_ShowProgressHUD;
// 显示结果消息提示开关
@property (nonatomic, assign) BOOL m_ShowResultHUD;

// 网络请求成功后,data是否可以为空, 默认不为空(NO)
@property (nonatomic, assign) BOOL m_AllowEmptyJson;


@end
