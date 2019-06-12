//
//  UIImageView+BMCategory.m
//  BMBasekit
//
//  Created by DennisDeng on 15-2-26.
//  Copyright (c) 2015年 DennisDeng. All rights reserved.
//
// tapku.com || http://github.com/devinross/tapkulibrary


#import "UIImageView+BMCategory.h"
#import "UIView+BMSize.h"
#import "NSObject+BMCategory.h"


@implementation UIImageView (BMCategory)

+ (instancetype)bm_imageViewWithImageNamed:(NSString *)imageName
{
	return [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
}

+ (instancetype)bm_imageViewWithFrame:(CGRect)frame
{
	return [[UIImageView alloc] initWithFrame:frame];
}

+ (instancetype)bm_imageViewWithStretchableImage:(NSString *)imageName Frame:(CGRect)frame
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    
    return imageView;
}

- (void)bm_setImageWithStretchableImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    self.image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
}

- (void)bm_setImageWithStretchableImage:(NSString *)imageName atPoint:(CGPoint)point
{
    UIImage *image = [UIImage imageNamed:imageName];
    self.image = [image stretchableImageWithLeftCapWidth:point.x topCapHeight:point.y];
}

+ (instancetype)bm_imageViewWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration
{
    return [UIImageView bm_imageViewWithImageArray:imageArray duration:duration repeatCount:0];
}

+ (instancetype)bm_imageViewWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration repeatCount:(NSUInteger)repeatCount
{
    if (![imageArray bm_isNotEmpty])
    {
        return nil;
    }
    
    UIImageView *imageView = [UIImageView bm_imageViewWithImageNamed:[imageArray objectAtIndex:0]];
    
    NSMutableArray *images = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < imageArray.count; i++)
    {
        UIImage *image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        if ([image bm_isNotEmpty])
        {
            [images addObject:image];
        }
    }
    
    //[imageView setImage:[images objectAtIndex:0]];
    
    if (images.count > 1)
    {
        [imageView setAnimationImages:images];
        [imageView setAnimationDuration:duration];
        [imageView setAnimationRepeatCount:repeatCount];
        
        [imageView stopAnimating];
    }
    
    return imageView;
}

- (void)bm_animationWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration repeatCount:(NSUInteger)repeatCount
{
    [self bm_animationWithImageArray:imageArray duration:duration repeatCount:repeatCount imageWithIndex:0];
}

- (void)bm_animationWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration repeatCount:(NSUInteger)repeatCount imageWithIndex:(NSUInteger)index
{
    NSMutableArray *images = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < imageArray.count; i++)
    {
        UIImage *image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        if ([image bm_isNotEmpty])
        {
            [images addObject:image];
        }
    }
    
    if (images.count > 1)
    {
        UIImage *image = [images bm_safeObjectAtIndex:index];
        if (image)
        {
            [self setImage:image];
        }
        
        [self setAnimationImages:images];
        [self setAnimationDuration:duration];
        [self setAnimationRepeatCount:repeatCount];
    }
    
    [self stopAnimating];
}

// 画水印
- (void)bm_setImage:(UIImage *)image withWaterMark:(UIImage *)mark inRect:(CGRect)rect
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions([self bm_size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    }
#else
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0)
    {
        UIGraphicsBeginImageContext([self bm_size]);
    }
#endif
    
//    CGContextRef thisctx = UIGraphicsGetCurrentContext();
    
//    CGAffineTransform myTr = CGAffineTransformMake(1, 0, 0, -1, 0, self.height);
//    CGContextConcatCTM(thisctx, myTr);
    
    //CGContextDrawImage(thisctx,CGRectMake(0,0,self.width,self.height),[image CGImage]); //原图
    //CGContextDrawImage(thisctx,rect,[mask CGImage]); //水印图
    //原图
    [image drawInRect:self.bounds];
    //水印图
    [mark drawInRect:rect];
    
//    NSString *s = @"dfd";
//    [[UIColor redColor] set];
//    [s drawInRect:self.bounds withFont:[UIFont systemFontOfSize:15.0]];
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.image = newPic;
}

- (void)bm_setImage:(UIImage *)image withStringWaterMark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions(self.bm_size, NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    }
#else
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0)
    {
        UIGraphicsBeginImageContext([self size]);
    }
#endif
    
    //原图
    [image drawInRect:self.bounds];
    
    //文字颜色
    [color set];
    
//    const CGFloat *colorComponents = CGColorGetComponents([color CGColor]);
//    CGContextSetRGBFillColor(context, colorComponents[0], colorComponents[1], colorComponents [2], colorComponents[3]);

    //水印文字
    [markString drawInRect:rect withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName: color}];
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.image = newPic;
}

- (void)bm_setImage:(UIImage *)image withStringWaterMark:(NSString *)markString atPoint:(CGPoint)point color:(UIColor *)color font:(UIFont *)font
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions(self.bm_size, NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    }
#else
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0)
    {
        UIGraphicsBeginImageContext([self size]);
    }
#endif
    
    //原图
    [image drawInRect:self.bounds];
    
    //文字颜色
    [color set];
    
    //水印文字
    [markString drawAtPoint:point withAttributes:@{NSFontAttributeName:font}];
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
     
    self.image = newPic;
}

@end
