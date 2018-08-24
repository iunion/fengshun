//
//  UIScrollView+BMEmpty.h
//  fengshun
//
//  Created by best2wa on 2018/8/23.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMEmptyView.h"

@interface UIScrollView (BMEmpty)

@property(nonatomic,strong)BMEmptyView *bm_emptyView;


- (void)showNoDataView:(BOOL )isShow state:(BMEmptyViewStatus )status action:(BMEmptyViewActionBlock)action;



@end
