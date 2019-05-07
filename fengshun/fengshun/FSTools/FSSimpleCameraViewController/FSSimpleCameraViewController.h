//
//  FSSimpleCameraViewController.h
//  fengshun
//
//  Created by Aiwei on 2019/2/26.
//  Copyright © 2019年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FSSimpleCameraViewController;

@protocol FSSimpleCameraControllerDelegate <UIImagePickerControllerDelegate>

@optional

- (void)fs_cameraCancelTakePicture:(FSSimpleCameraViewController *)cameraController;
- (void)imagePickerController:(UIViewController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;

@end

@interface FSSimpleCameraViewController : UIImagePickerController

@property (nonatomic, weak)id <UINavigationControllerDelegate, FSSimpleCameraControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
