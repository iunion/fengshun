//
//  BMTestColorPickerView.m
//  fengshun
//
//  Created by jiang deng on 2018/11/29.
//  Copyright © 2018 FS. All rights reserved.
//

static const CGFloat kPickerViewSize = 100.0f;
static const CGFloat kImageIconSize = 32.0f;

#import "BMTestColorPickerView.h"

@interface BMTestColorPickerView ()

@property (nonatomic, strong) UIImageView *sightImageView;
@property (nonatomic, strong) UIImageView *paletteImageView;

@property (nonatomic, strong) UILabel *colorLabel;

@property (nonatomic, strong) UIPanGestureRecognizer *colorPickerPanGesture;

@end


@implementation BMTestColorPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.frame = CGRectMake(0, 0, kPickerViewSize, kPickerViewSize);
        self.backgroundColor = [UIColor clearColor];
        self.layer.zPosition = FLT_MAX;
        //self.userInteractionEnabled = NO;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kImageIconSize, kImageIconSize)];
        imageView.image = [UIImage imageNamed:@"testcolorpicker"];
        [self addSubview:imageView];
        self.sightImageView = imageView;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, kImageIconSize, kImageIconSize, kImageIconSize)];
        imageView.image = [UIImage imageNamed:@"testcolorpalette"];
        [imageView bm_circleView];
        [self addSubview:imageView];
        self.paletteImageView = imageView;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kImageIconSize, 0, 50.0f, 16.0f)];
        label.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:label];
        self.colorLabel = label;
    }
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(colorPickerPanGestureAction:)];
    [self addGestureRecognizer:pan];
    
    return self;
}

- (void)setCurrentColorWithHexStr:(NSString *)hexColor
{
    [self setCurrentColorWithHexStr:hexColor alpha:1.0f];
}

- (void)setCurrentColorWithHexStr:(NSString *)hexColor alpha:(CGFloat)alpha
{
    UIColor *color = [UIColor bm_colorWithHexString:hexColor alpha:alpha];
    UIImage *image = [[UIImage imageNamed:@"testcolorpalette"] bm_imageWithTintColor:color];
    self.paletteImageView.image = image;
    self.paletteImageView.backgroundColor = [color contrastingColor];

    self.colorLabel.text = [hexColor uppercaseString];
    self.colorLabel.textColor = color;
    [self.colorLabel sizeToFit];
    self.colorLabel.backgroundColor = [color contrastingColor];
}

- (void)colorPickerPanGestureAction:(UIPanGestureRecognizer *)panGesture
{
    UIView *panView = panGesture.view;
    
    //1、获得拖动位移
    CGPoint offsetPoint = [panGesture translationInView:panView];
    //2、清空拖动位移
    [panGesture setTranslation:CGPointZero inView:panView];
    //3、重新设置控件位置
    CGFloat newX = panView.bm_centerX+offsetPoint.x;
    CGFloat newY = panView.bm_centerY+offsetPoint.y;
    CGPoint centerPoint = CGPointMake(newX, newY);
    panView.center = centerPoint;
    
    CGFloat pickX = panView.bm_left+offsetPoint.x;
    CGFloat pickY = panView.bm_top+offsetPoint.y+kImageIconSize;
    CGPoint pickPoint = CGPointMake(pickX, pickY);
    
    //NSLog(@"%@", NSStringFromCGPoint(pickPoint));
    //NSLog(@"%@", NSStringFromCGPoint(centerPoint));

    NSString *hexColor = [self getColorWithPoint:pickPoint];
    NSLog(@"%@", hexColor);
    
    [self setCurrentColorWithHexStr:hexColor];
}

- (NSString *)getColorWithPoint:(CGPoint)point
{
    //UIViewController *topVc = [DoraemonUtil topViewControllerForKeyWindow];
    //return [self getColorOfPoint:centerPoint InView:topVc.view];
    
    return [self getColorOfPoint:point InView:self.window];
}

- (NSString *)getColorOfPoint:(CGPoint)point InView:(UIView*)view
{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel,
                                                 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [view.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    NSString *hexColor = [NSString stringWithFormat:@"#%02x%02x%02x", pixel[0], pixel[1], pixel[2]];
    //NSString *alpha = [NSString stringWithFormat:@"%02d", pixel[3]];
    //NSLog(@"alpha == %@", alpha);
    return hexColor;
}

@end
