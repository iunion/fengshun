//
//  FSCommunitySecVC.h
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSTableViewVC.h"

@interface FSCommunitySecVC : FSTableViewVC

@property (nonatomic, copy)void (^m_AttentionChangeBlock)(void);

// 板块id
- (instancetype)initWithFourmId:(NSInteger )fourmId fourmName:(NSString *)fourmName;

@end
