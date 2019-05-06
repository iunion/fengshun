//
//  FSSetProfessionalVC.h
//  fengshun
//
//  Created by jiang deng on 2019/4/16.
//  Copyright © 2019 FS. All rights reserved.
//

#import "FSSetTableViewVC.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FSSetTableViewVCDelegate;

@interface FSSetProfessionalVC : FSSetTableViewVC

@property (nullable, nonatomic, weak) id <FSSetTableViewVCDelegate> delegate;

@end

@protocol FSSetTableViewVCDelegate <NSObject>

@optional
- (void)setProfessionalFinished:(NSString *)professionalQualifications;

@end

NS_ASSUME_NONNULL_END
