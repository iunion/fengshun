//
//  UIImage+BMAssets.h
//  BMBasekit
//
//  Created by DennisDeng on 2017/3/20.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BMAssets)

/**
 * Returns the App icon.
 * @return The App icon.
 **/
+ (nullable UIImage *)bm_appIconImage;

/**
 * Return the name of the splash image for a given orientation.
 * @param orientation The interface orientation.
 * @return The name of the splash image.
 **/
+ (nullable NSString *)bm_splashImageNameForOrientation:(UIInterfaceOrientation)orientation;

/**
 * Returns the splash image for a given orientation.
 * @param orientation The interface orientation.
 * @return The splash image.
 **/
+ (nullable UIImage *)bm_splashImageForOrientation:(UIInterfaceOrientation)orientation;

@end
