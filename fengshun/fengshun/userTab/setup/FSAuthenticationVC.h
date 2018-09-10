//
//  FSAuthenticationVC.h
//  fengshun
//
//  Created by jiang deng on 2018/9/7.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSetTableViewVC.h"

@protocol FSAuthenticationDelegate;
@interface FSAuthenticationVC : FSSetTableViewVC

@property (nonatomic, weak) id <FSAuthenticationDelegate> delegate;

@end

@protocol FSAuthenticationDelegate <NSObject>

@optional

- (void)authenticationFinished:(FSAuthenticationVC *)vc;

@end
