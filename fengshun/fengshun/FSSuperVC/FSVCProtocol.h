//
//  FSVCProtocol.h
//  fengshun
//
//  Created by jiang deng on 2018/8/25.
//  Copyright © 2018年 FS. All rights reserved.
//

#ifndef FSVCProtocol_h
#define FSVCProtocol_h

@protocol FSSuperVCProtocol <NSObject>

@required

// backAction前操作, 包含手势返回(可用手势返回时)
- (BOOL)shouldPopOnBackButton;
- (void)backAction:(id)sender;

@optional

@end

#endif /* FSVCProtocol_h */
