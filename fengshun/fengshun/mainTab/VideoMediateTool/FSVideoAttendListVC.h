//
//  FSVideoAttendListVC.h
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSTableViewVC.h"

@interface FSVideoAttendListVC : FSTableViewVC

@property (nonatomic, assign) NSInteger meetingId;
@property (nonatomic, strong) NSArray *m_AttendList;

@end
