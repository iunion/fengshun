//
//  FSSearchReaultView.h
//  fengshun
//
//  Created by Aiwei on 2018/9/4.
//  Copyright © 2018 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTableView.h"

@interface FSSearchReaultView : UIView
<
    UITableViewDelegate,
    UITableViewDataSource,
    FSTableViewDelegate
>

@property (nonatomic, strong) FSTableView *m_tableView;

// 这些方法供子类使用
- (void)configTableViewWithStartY:(CGFloat)startY;

// 这些方法子类中实现
- (void)addSearchkey:(NSString *)searchkey;
@end
