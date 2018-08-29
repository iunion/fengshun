//
//  FSLoginVC.h
//  fengshun
//
//  Created by jiang deng on 2018/8/29.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSetTableViewVC.h"
//#import "BMNavigationController.h"
#import "FSLoginProtocol.h"

@interface FSLoginVC : FSSetTableViewVC

@property (nonatomic, weak) id <FSLoginDelegate> delegate;

@end
