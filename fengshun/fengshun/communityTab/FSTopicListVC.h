//
//  FSTopicListVC.h
//  fengshun
//
//  Created by best2wa on 2018/9/10.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSTableViewVC.h"

/**
 排序方式

 - FSTopicSortTypeNewReply: 最新回复
 - FSTopicSortTypeNewPulish: 最新发布
 - FSTopicSortTypeHot: 热门
 - FSTopicSortTypeEssence: 精华
 */
typedef NS_ENUM(NSUInteger, FSTopicSortType) {
    FSTopicSortTypeNewReply,   //最新回复
    FSTopicSortTypeNewPulish,  //最新发布
    FSTopicSortTypeHot,        //热门
    FSTopicSortTypeEssence     //精华
};

@interface FSTopicListVC : FSTableViewVC

- (instancetype)initWithTopicSortType:(FSTopicSortType)sortType;

@end
