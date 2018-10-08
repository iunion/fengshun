//
//  UIImage+BMCategory.h
//  BMBasekit
//
//  Created by DennisDeng on 15-2-26.
//  Copyright (c) 2015年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocation.h>


#define ROUNDEDRECT_PERCENTAGE 10

typedef NS_ENUM(NSInteger, IMAGE_GRAYSCALETYPE)
{
    IMAGE_GRAYSCALETYPE_GRAY = 0,
    IMAGE_GRAYSCALETYPE_BROWN,
    IMAGE_GRAYSCALETYPE_INVERSE
};

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (BMCategory)

// 图片拉伸
+ (UIImage *)strethImageWith:(NSString *)imageName;
- (UIImage *)stretchableImage;

- (UIImage *)resizedImageModeTile;
+ (UIImage *)resizedImageModeTileWithName:(NSString *)name;

+ (UIImage *)resizedImageWithName:(NSString *)name;
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

+ (nullable UIImage *)imageWithColor:(UIColor *)color;
+ (nullable UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

// 图片先压缩到size大小然后再做圆角大小为r，然后在view上圆角与图片可能被等比拉伸/缩放
+ (UIImage *)createRoundedRectImage:(UIImage *)image size:(CGSize)size radius:(CGFloat)r;
// 先在原图做r大的圆角，然后在view上圆角与图片可能被等比拉伸/缩放
+ (UIImage *)createRoundedRectImage:(UIImage *)image radius:(CGFloat)r;

// 文字转为图片
+ (UIImage *)imageFromText:(NSString *)text;
+ (UIImage *)imageFromText:(NSString *)text font:(UIFont *)font size:(CGSize)size;
+ (UIImage *)imageFromText:(NSString *)text font:(UIFont *)font color:(nullable UIColor *)color size:(CGSize)size;

- (UIImage *)fixOrientation;

// 图像旋转(角度)
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;


// 画水印
// 图片水印
- (UIImage *)imageWithWaterMask:(UIImage *)mask inRect:(CGRect)rect;
// 文字水印
- (UIImage *)imageWithStringWaterMark:(NSString *)markString inRect:(CGRect)rect color:(nullable UIColor *)color font:(UIFont *)font;
- (UIImage *)imageWithStringWaterMark:(NSString *)markString atPoint:(CGPoint)point color:(nullable UIColor *)color font:(UIFont *)font;

// 蒙板
- (UIImage *)imageWithColor:(UIColor *)color inRect:(CGRect)rect;

// 保存图像文件
- (BOOL)writeImageToFileAtPath:(NSString *)aPath;


// 黑白
- (nullable UIImage *)convertToGrayScale;    // 有黑底
- (UIImage *)imageWithBlackWhite;

// 图片处理 黑白灰度 做旧深棕色 反色
- (UIImage *)grayScaleWithType:(IMAGE_GRAYSCALETYPE)type;

// 平均的颜色
// 主色调
- (UIColor *)averageColor;

@end


@interface UIImage (BMBorder)

- (UIImage *)imageWithColoredBorder:(NSUInteger)borderThickness borderColor:(UIColor *)color withShadow:(BOOL)withShadow;
- (nullable UIImage *)imageWithTransparentBorder:(NSUInteger)thickness;

@end

@interface UIImage (BMMGProportionalFill)

typedef enum {
    MGImageResizeCrop,	// analogous to UIViewContentModeScaleAspectFill, i.e. "best fit" with no space around.
    MGImageResizeCropStart,
    MGImageResizeCropEnd,
    MGImageResizeScale	// analogous to UIViewContentModeScaleAspectFit, i.e. scale down to fit, leaving space around if necessary.
} MGImageResizingMethod;

- (UIImage *)imageToFitSize:(CGSize)size method:(MGImageResizingMethod)resizeMethod;
- (UIImage *)imageCroppedToFitSize:(CGSize)size; // uses MGImageResizeCrop
- (UIImage *)imageScaledToFitSize:(CGSize)size; // uses MGImageResizeScale

@end

@interface UIImage (BMBlur)
- (UIImage *)boxblurImageWithBlur:(CGFloat)blur;
@end

@interface UIImage (BMImageMetadata)
- (nullable NSMutableDictionary *)getImageMetadata;
- (nullable NSData *)setImageDateTime:(NSDate *)date latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude withCompressionQuality:(CGFloat)compressionQuality;
- (nullable NSData *)setImageMetadata:(NSMutableDictionary *)metaData;
- (nullable NSData *)setImageMetadata:(NSMutableDictionary *)metaData withCompressionQuality:(CGFloat)compressionQuality;
@end

NS_ASSUME_NONNULL_END

