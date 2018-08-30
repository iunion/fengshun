//
//  FSLoginProtocol.h
//  fengshun
//
//  Created by jiang deng on 2018/8/29.
//  Copyright © 2018年 FS. All rights reserved.
//

#ifndef FSLoginProtocol_h
#define FSLoginProtocol_h

typedef NS_ENUM(NSUInteger, FSLoginProgressState)
{
    FSLoginProgress_LoginPhone,
    FSLoginProgress_InputPassWord,
    FSLoginProgress_RegistVerify,
    FSLoginProgress_ForgetVerify,
    FSLoginProgress_SetPassWord,
    FSLoginProgress_ChangePassWord,
    FSLoginProgress_FinishLogin,
    FSLoginProgress_FinishRegist,
    FSLoginProgress_FinishForget
};

@protocol FSLoginDelegate <NSObject>

@optional

- (void)loginProgressStateChanged:(FSLoginProgressState)progressState;

- (void)loginFailedWithProgressState:(FSLoginProgressState)progressState;

- (void)loginClosedWithProgressState:(FSLoginProgressState)progressState;

@end

#endif /* FSLoginProtocol_h */
