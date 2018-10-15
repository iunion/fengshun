//
//  FSMoreViewVC.h
//  fengshun
//
//  Created by best2wa on 2018/9/17.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSuperVC.h"
#import "FSShareManager.h"

@protocol FSMoreViewVCDelegate <NSObject>

@optional

- (void)moreViewClickWithType:(NSInteger )index;

@end

@interface FSMoreViewVC : FSSuperVC

+ (void)showMoreDelegate:(id)delegate isOwner:(BOOL)isOwner isCollection:(BOOL)isCollection;

+ (void)showWebMoreDelegate:(id)delegate isCollection:(BOOL)isCollection ;
+ (void)showWebMoreDelegate:(id)delegate isCollection:(BOOL)isCollection hasRefresh:(BOOL)hasRefresh;

+ (void)showShareAlertViewDelegate:(id)delegate;

@property (nonatomic, assign)id <FSMoreViewVCDelegate> delegate;

@end


