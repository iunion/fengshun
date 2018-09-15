//
//  MDTMeetingListViewController.h
//  ODR
//
//  Created by DH on 2018/9/5.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "FSTableViewVC.h"
#import "FSSuperModel.h"

@interface MDTMeetingListViewController : FSTableViewVC
+ (instancetype)vcWithCaseId:(NSInteger)caseId;
@end

@interface MDTMeetingListViewModel : FSSuperModel
@property (nonatomic, assign) NSInteger caseId;
@end
