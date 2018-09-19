//
//  FSVideoMediateDetailVC.h
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSuperVC.h"
#import "FSTableViewVC.h"
#import "FSVideoMediateModel.h"

typedef void(^FSVideoMediateDetailChangedBlock)(void);

@interface FSVideoMediateDetailVC : FSTableViewVC

@property (nonatomic, copy) FSVideoMediateDetailChangedBlock changedBlock;

@property (nonatomic, assign) NSInteger m_MeetingId;

@end
