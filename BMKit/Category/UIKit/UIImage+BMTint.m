//
//  UIImage+BMTint.m
//  BMBasekit
//
//  Created by DennisDeng on 17/3/14.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "UIImage+BMTint.h"

@implementation UIImage (BMTint)

// Tint: Color + Rect + level
//- (UIImage *)imageWithTintColor:(UIColor *)color rect:(CGRect)rect level:(CGFloat)level
//{
//    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
//    
//    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    [self drawInRect:imageRect];
//    
//    CGContextSetFillColorWithColor(ctx, [color CGColor]);
//    CGContextSetAlpha(ctx, level);
//    CGContextSetBlendMode(ctx, kCGBlendModeSourceAtop);
//    CGContextFillRect(ctx, rect);
//    
//    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
//    UIImage *tintedImage = [UIImage imageWithCGImage:imageRef
//                                             scale:self.scale
//                                       orientation:self.imageOrientation];
//    CGImageRelease(imageRef);
//    
//    UIGraphicsEndImageContext();
//    
//    return tintedImage;
//}


#pragma mark blendMode

- (UIImage *)bm_imageWithTintColor:(UIColor *)tintColor
{
    // 用kCGBlendModeDestinationIn能保留透明度信息
    return [self bm_imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)bm_imageWithTintColor:(UIColor *)tintColor insets:(UIEdgeInsets)insets
{
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    return [self bm_imageWithTintColor:tintColor rect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (UIImage *)bm_imageWithTintColor:(UIColor *)tintColor rect:(CGRect)rect
{
    return [self bm_imageWithTintColor:tintColor rect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0f];
}

- (UIImage *)bm_imageWithGradientTintColor:(UIColor *)tintColor
{
    // 用kCGBlendModeOverlay能保留灰度信息
    return [self bm_imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *)bm_imageWithGradientTintColor:(UIColor *)tintColor insets:(UIEdgeInsets)insets
{
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    return [self bm_imageWithGradientTintColor:tintColor rect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (UIImage *)bm_imageWithGradientTintColor:(UIColor *)tintColor rect:(CGRect)rect
{
    return [self bm_imageWithTintColor:tintColor rect:rect blendMode:kCGBlendModeOverlay alpha:1.0f];
}

- (UIImage *)bm_imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    return [self bm_imageWithTintColor:tintColor rect:rect blendMode:blendMode alpha:1.0f];
}

- (UIImage *)bm_imageWithTintColor:(UIColor *)tintColor rect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    // 填充颜⾊
    [tintColor setFill];
    UIRectFill(rect);
    
    //Draw the tinted image in context
    [self drawInRect:rect blendMode:blendMode alpha:alpha];
    
    // 保留透明度信息
    if (blendMode != kCGBlendModeDestinationIn)
    {
        [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

/*
- (void)changeBlendMode:(CGBlendMode)blendMode
{
    NSString *strMsg;
    switch (blendMode)
    {
        case kCGBlendModeNormal:
        {
            strMsg = @"kCGBlendModeNormal: 正常；也是默认的模式。前景图会覆盖背景图";
            break;
        }
        case kCGBlendModeMultiply:
        {
            strMsg = @"kCGBlendModeMultiply: 正片叠底；混合了前景和背景的颜色，最终颜色比原先的都暗";
            break;
        }
        case kCGBlendModeScreen:
        {
            strMsg = @"kCGBlendModeScreen: 滤色；把前景和背景图的颜色先反过来，然后混合";
            break;
        }
        case kCGBlendModeOverlay:
        {
            strMsg = @"kCGBlendModeOverlay: 覆盖；能保留灰度信息，结合kCGBlendModeSaturation能保留透明度信息，在imageWithBlendMode方法中两次执行drawInRect方法实现我们基本需求";
            break;
        }
        case kCGBlendModeDarken:
        {
            strMsg = @"kCGBlendModeDarken: 变暗";
            break;
        }
        case kCGBlendModeLighten:
        {
            strMsg = @"kCGBlendModeLighten: 变亮";
            break;
        }
        case kCGBlendModeColorDodge:
        {
            strMsg = @"kCGBlendModeColorDodge: 颜色变淡";
            break;
        }
        case kCGBlendModeColorBurn:
        {
            strMsg = @"kCGBlendModeColorBurn: 颜色加深";
            break;
        }
        case kCGBlendModeSoftLight:
        {
            strMsg = @"kCGBlendModeSoftLight: 柔光";
            break;
        }
        case kCGBlendModeHardLight:
        {
            strMsg = @"kCGBlendModeHardLight: 强光";
            break;
        }
        case kCGBlendModeDifference:
        {
            strMsg = @"kCGBlendModeDifference: 插值";
            break;
        }
        case kCGBlendModeExclusion:
        {
            strMsg = @"kCGBlendModeExclusion: 排除";
            break;
        }
        case kCGBlendModeHue:
        {
            strMsg = @"kCGBlendModeHue: 色调";
            break;
        }
        case kCGBlendModeSaturation:
        {
            strMsg = @"kCGBlendModeSaturation: 饱和度";
            break;
        }
        case kCGBlendModeColor:
        {
            strMsg = @"kCGBlendModeColor: 颜色";
            break;
        }
        case kCGBlendModeLuminosity:
        {
            strMsg = @"kCGBlendModeLuminosity: 亮度";
            break;
        }
        // Apple额外定义的枚举
        // R: premultiplied result, 表示混合结果
        // S: Source, 表示源颜色(Sa对应透明度值: 0.0-1.0)
        // D: destination colors with alpha, 表示带透明度的目标颜色(Da对应透明度值: 0.0-1.0)
        case kCGBlendModeClear:
        {
            strMsg = @"kCGBlendModeClear: R = 0";
            break;
        }
        case kCGBlendModeCopy:
        {
            strMsg = @"kCGBlendModeCopy: R = S";
            break;
        }
        case kCGBlendModeSourceIn:
        {
            strMsg = @"kCGBlendModeSourceIn: R = S*Da";
            break;
        }
        case kCGBlendModeSourceOut:
        {
            strMsg = @"kCGBlendModeSourceOut: R = S*(1 - Da)";
            break;
        }
        case kCGBlendModeSourceAtop:
        {
            strMsg = @"kCGBlendModeSourceAtop: R = S*Da + D*(1 - Sa)";
            break;
        }
        case kCGBlendModeDestinationOver:
        {
            strMsg = @"kCGBlendModeDestinationOver: R = S*(1 - Da) + D";
            break;
        }
        case kCGBlendModeDestinationIn:
        {
            strMsg = @"kCGBlendModeDestinationIn: R = D*Sa；能保留透明度信息";
            break;
        }
        case kCGBlendModeDestinationOut:
        {
            strMsg = @"kCGBlendModeDestinationOut: R = D*(1 - Sa)";
            break;
        }
        case kCGBlendModeDestinationAtop:
        {
            strMsg = @"kCGBlendModeDestinationAtop: R = S*(1 - Da) + D*Sa";
            break;
        }
        case kCGBlendModeXOR:
        {
            strMsg = @"kCGBlendModeXOR: R = S*(1 - Da) + D*(1 - Sa)";
            break;
        }
        case kCGBlendModePlusDarker:
        {
            strMsg = @"kCGBlendModePlusDarker: R = MAX(0, (1 - D) + (1 - S))";
            break;
        }
        case kCGBlendModePlusLighter:
        {
            strMsg = @"kCGBlendModePlusLighter: R = MIN(1, S + D)（最后一种混合模式）";
            break;
        }
        default:
        {
            break;
        }
    }
//    _imgVBlend.image=[[UIImage imageNamed:@"xx"] imageWithTintColor:[UIColor orangeColor] blendMode:blendMode];
//    _lblMsg.text = strMsg;
//    
//    blendMode++;
//    if (blendMode > kCGBlendModePlusLighter) {
//        blendMode = kCGBlendModeNormal;
}
*/
 
@end
