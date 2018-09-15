//
//  MDTVideoRecordViewController.h
//  ODR
//
//  Created by DH on 2018/9/12.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "FSTableViewVC.h"
#import "FSSuperModel.h"

@interface MDTVideoRecordViewController : FSTableViewVC
+ (instancetype)VCWithMeetingId:(NSInteger)meetingId;
@end

@interface MDTVideoRecordViewModel : FSSuperModel
@property (nonatomic, assign) NSInteger meetingId;
@end
