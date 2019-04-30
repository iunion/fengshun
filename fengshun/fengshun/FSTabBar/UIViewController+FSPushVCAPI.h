//
//  UIViewController+FSPushVCAPI.h
//  fengshun
//
//  Created by Aiwei on 2018/12/21.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSPushVCModel.h"
#define FS_URL_SCHEMES @"ftls"

@interface UIViewController (FSPushVCAPI)

- (void)fspush_withModel:(FSPushVCModel *)pushModel;

- (BOOL)fspush_withUrl:(NSURL *)url;

- (BOOL)canOpenUrl:(NSURL *)url;

@end
