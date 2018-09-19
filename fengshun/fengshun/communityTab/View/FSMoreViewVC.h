//
//  FSMoreViewVC.h
//  fengshun
//
//  Created by best2wa on 2018/9/17.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSuperVC.h"

@protocol FSMoreViewVCDelegate <NSObject>

@optional

- (void)moreViewClickWithType:(NSInteger )index;

@end

@interface FSMoreViewVC : FSSuperVC

+ (void)showMore:(UIViewController *)presentVC  delegate:(id)delegate isOwner:(BOOL)isOwner isCollection:(BOOL)isCollection;

@property (nonatomic, assign)id <FSMoreViewVCDelegate> delegate;

@end

