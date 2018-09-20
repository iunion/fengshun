//
//  FSNewVideoMediateVC.h
//  fengshun
//
//  Created by ILLA on 2018/9/17.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSetTableViewVC.h"
#import "FSVideoMediateModel.h"

typedef NS_ENUM(NSInteger, FSMakeVideoMediateMode) {
    FSMakeVideoMediateMode_Create,      // 创建新视频调解
    FSMakeVideoMediateMode_Edit,        // 编辑
    FSMakeVideoMediateMode_ReSend       // 重新发起一个新的
};


typedef void(^makeVideoMediateSuccessBlock)(FSMeetingDetailModel *model, BOOL startImmediately);

@interface FSMakeVideoMediateVC : FSSetTableViewVC
@property (nonatomic, assign) FSMakeVideoMediateMode makeMode;
@property (nonatomic, copy) makeVideoMediateSuccessBlock successBlock;
@property (nonatomic, strong) FSMeetingDetailModel *m_CreateModel;

+ (instancetype)makevideoMediateVCWithModel:(FSMakeVideoMediateMode)mode
                                       data:(FSMeetingDetailModel *)data
                                      block:(makeVideoMediateSuccessBlock)block;

@end
