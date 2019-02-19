//
//  FSSearchHistoryTableView.m
//  fengshun
//
//  Created by Aiwei on 2019/2/19.
//  Copyright © 2019年 FS. All rights reserved.
//

#import "FSSearchHistoryTableView.h"

@implementation FSSearchHistoryTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.m_searchTextField resignFirstResponder];
}
@end
