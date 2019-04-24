//
//  UIViewController+FSPushVCAPI.h
//  fengshun
//
//  Created by Aiwei on 2018/12/21.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSPushVCModel.h"
#define FS_URL_Schemes @"ftls"

@interface UIViewController (FSPushVCAPI)

- (void)fspush_withModel:(FSPushVCModel *)pushModel;

- (void)fspush_withUrl:(NSURL *)url;

@end
