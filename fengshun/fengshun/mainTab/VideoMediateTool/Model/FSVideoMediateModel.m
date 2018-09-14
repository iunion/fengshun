//
//  FSVideoMediateModel.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoMediateModel.h"
#import "FSUserInfoModle.h"

@implementation MeetingPersonnelModel

+ (instancetype)userModel
{
    FSUserInfoModle *user = [FSUserInfoModle userInfo];
    
    MeetingPersonnelModel *model = [MeetingPersonnelModel new];
    model.id = [user.m_UserBaseInfo.m_UserId integerValue];
    model.mobilePhone = user.m_UserBaseInfo.m_PhoneNum;
    model.userName = user.m_UserBaseInfo.m_RealName;
    model.meetingIdentityTypeEnums = @"MEDIATOR";
    model.selectState = -1;

    model.id = 123;
    model.mobilePhone = @"13000009987";
    model.userName = @"邓家佳";
    model.meetingIdentityTypeEnums = @"MEDIATOR";
    model.selectState = -1;

    return model;
}

+ (instancetype)userModelWithState:(NSUInteger)state
{
    MeetingPersonnelModel *model = [MeetingPersonnelModel new];
    model.id = 123;
    model.mobilePhone = @"13000009987";
    model.userName = @"邓家佳";
    model.meetingIdentityTypeEnums = @"MEDIATOR";
    model.selectState = state;
    
    return model;

}

@end


@implementation VideoMediateListModel

@end
