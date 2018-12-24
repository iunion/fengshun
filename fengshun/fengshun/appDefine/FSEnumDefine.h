//
//  FSEnumDefine.h
//  fengshun
//
//  Created by Aiwei on 2018/12/18.
//  Copyright © 2018年 FS. All rights reserved.
//

#ifndef FSEnumDefine_h
#define FSEnumDefine_h

typedef NS_ENUM(NSUInteger, FSAuthState) {
    FSAuthStateNone,///<所有信息未完善
    FSAuthStateAllDone,///<所有信息已完善
    FSAuthStateNoAuth,///<实名认证信息未完善
    FSAuthStateNoNickName,///<昵称未完善
};

#endif /* FSEnumDefine_h */
