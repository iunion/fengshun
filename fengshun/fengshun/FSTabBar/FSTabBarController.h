//
//  FSTabBarController.h
//  fengshun
//
//  Created by jiang deng on 2018/8/25.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "BMTabBarController.h"
#import "FSPushVCModel.h"

@interface FSTabBarController : BMTabBarController

- (instancetype)initWithDefaultItems;

- (void)addViewControllers;

- (void)topVCPushWithModel:(FSPushVCModel *)pushModel;

- (BOOL )topVCJumpWithUrl:(NSURL *)url;
@end
