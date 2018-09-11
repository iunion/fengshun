//
//  FSTextSearchResultView.m
//  fengshun
//
//  Created by Aiwei on 2018/9/10.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSTextSearchResultView.h"
#import "FSTextSearchResultVC.h"

@implementation FSTextSearchResultView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andResultVC:[[FSTextSearchResultVC alloc]initWithNibName:nil bundle:nil freshViewType:BMFreshViewType_Bottom]];
}
@end
