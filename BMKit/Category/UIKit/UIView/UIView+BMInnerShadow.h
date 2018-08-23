#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (BMInnerShadow)

- (void)bm_drawInnerShadowInRect:(CGRect)rect fillColor:(UIColor *)fillColor;
- (void)bm_drawInnerShadowInRect:(CGRect)rect radius:(CGFloat)radius fillColor:(UIColor *)fillColor;

@end

@interface UIView (BMShadow)

- (void)bm_addShadow;
- (void)bm_addShadow:(NSInteger)borderWidth Radius:(CGFloat)radius BorderColor:(UIColor *)borderColor ShadowColor:(UIColor *)shadowColor;
- (void)bm_addShadow:(NSInteger)borderWidth Radius:(CGFloat)radius BorderColor:(UIColor *)borderColor ShadowColor:(UIColor *)shadowColor Offset:(CGSize)offset Opacity:(float)opacity;

- (void)bm_addCurveShadow;
- (void)bm_addCurveShadowWithColor:(UIColor *)color;

- (void)bm_addGrayGradientShadow;
- (void)bm_addGrayGradientShadowWithColor:(UIColor *)color;

- (void)bm_addMovingShadow;

/**
 *  Remove the shadow around the UIView
 */
- (void)bm_removeShadow;

@end


@interface UIView (BMScreenshot)
- (UIImage *)bm_screenshot;
- (UIImage *)bm_screenshotWithRect:(CGRect)rect;
@end

