//
//  FSMessageListVC.h
//  fengshun
//
//  Created by jiang deng on 2018/9/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSTableViewVC.h"
#import "FSMessage.h"

@interface FSMessageListVC : FSTableViewVC

// 使用BMScrollPageSegment加载时，用于push下级页面
@property (nonatomic, weak) FSSuperVC *m_PushVC;

- (instancetype)initWithMessageType:(FSMessageType)messageType;

@end
