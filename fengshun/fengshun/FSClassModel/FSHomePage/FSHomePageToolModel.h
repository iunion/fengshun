//
//  FSHomePageToolModel.h
//  fengshun
//
//  Created by Aiwei on 2018/9/5.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSImageJump.h"

typedef NS_ENUM(NSUInteger, FSHomePageTooltype) {
    FSHomePageTooltype_VideoMediation = 1,  //视频调解
    FSHomePageTooltype_FileScanning,        //文件扫描
    FSHomePageTooltype_Document,            //文书范本
    FSHomePageTooltype_StatuteSearching,    //法规检索
    FSHomePageTooltype_CaseSearching,       //案例检索
    FSHomePageTooltype_Calculator,          //计算器
    FSHomePageTooltype_Unknown = 1000,
};

@interface FSHomePageToolModel : FSImageJump

@property (nonatomic, assign) FSHomePageTooltype m_toolType;

@end
