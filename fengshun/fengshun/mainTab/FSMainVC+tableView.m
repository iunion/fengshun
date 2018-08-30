//
//  FSMainVC+tableView.m
//  fengshun
//
//  Created by Aiwei on 2018/8/30.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSMainVC+tableView.h"
#import "BMNavigationBar.h"

@implementation FSMainVC (tableView)

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat maxOffset = (261.0/667 * UI_SCREEN_HEIGHT -97)/2;
    BMNavigationBar *navBar = (BMNavigationBar *)self.navigationController.navigationBar;
    if (offsetY <= 0) {
        navBar.backgroundImageView.alpha = 0;
    }
    else if (offsetY >= maxOffset)
    {
        navBar.backgroundImageView.alpha = 1.0;
    }
    else
    {
        navBar.backgroundImageView.alpha = offsetY/maxOffset;
    }
}
@end
