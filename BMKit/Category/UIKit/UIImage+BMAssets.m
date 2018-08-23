//
//  UIImage+BMAssets.m
//  BMBasekit
//
//  Created by DennisDeng on 2017/3/20.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "UIImage+BMAssets.h"

@implementation UIImage (BMAssets)

+ (UIImage *)bm_appIconImage
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    
    //id ccc = [infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"];
    NSString *iconName = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    if (iconName)
    {
        UIImage *icon = [UIImage imageNamed:iconName];
        return icon;
    }

    return nil;
}


+ (NSString *)bm_splashImageNameForOrientation:(UIInterfaceOrientation)orientation
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    
    NSString *viewOrientation = @"Portrait";
    
    if (UIDeviceOrientationIsLandscape((UIDeviceOrientation)orientation))
    {
        viewSize = CGSizeMake(viewSize.height, viewSize.width);
        viewOrientation = @"Landscape";
    }
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            return dict[@"UILaunchImageName"];
        }
    }
    
    return nil;
}

+ (UIImage *)bm_splashImageForOrientation:(UIInterfaceOrientation)orientation
{
    NSString *imageName = [self bm_splashImageNameForOrientation:orientation];
    if (imageName)
    {
        UIImage *image = [UIImage imageNamed:imageName];
        return image;
    }
    
    return nil;
}

@end
