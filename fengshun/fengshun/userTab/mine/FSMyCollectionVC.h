//
//  FSMyCollectionVC.h
//  fengshun
//
//  Created by jiang deng on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSTableViewVC.h"

@interface FSMyCollectionVC : FSTableViewVC

// 使用BMScrollPageSegment加载时，用于push下级页面
@property (nonatomic, weak) FSSuperVC *m_PushVC;

- (instancetype)initWithCollectionType:(FSCollectionType)collectionType;

@end
