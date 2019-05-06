//
//  FSAddressPickerVC.h
//  fengshun
//
//  Created by jiang deng on 2019/4/3.
//  Copyright © 2019 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FSAddressPickerVCDelegate;

@interface FSAddressPickerVC : UIViewController

@property (nullable, nonatomic, weak) id <FSAddressPickerVCDelegate> delegate;

@end

@protocol FSAddressPickerVCDelegate <NSObject>

@optional
- (void)addressPickerPickAddressFinished:(NSString *)address;

@end

NS_ASSUME_NONNULL_END
