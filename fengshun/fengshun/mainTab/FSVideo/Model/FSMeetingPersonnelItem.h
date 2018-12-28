//
//  FSMeetingPersonnelItem.h
//  fengshun
//
//  Created by ILLA on 2018/9/17.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "BMTableViewItem.h"
#import "FSVideoMediateModel.h"

typedef void (^FSMeetingPersonnelSelectionHandler)(FSMeetingPersonnelModel *personModel);

@interface FSMeetingPersonnelItem : BMTableViewItem

@property (nonatomic, strong) FSMeetingPersonnelModel *personModel;

@property (nonatomic, copy) FSMeetingPersonnelSelectionHandler personnelSelectionHandler;

@end
