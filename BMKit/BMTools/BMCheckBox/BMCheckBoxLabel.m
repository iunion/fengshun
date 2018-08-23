//
//  BMCheckBoxLabel.m
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2018/2/9.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "BMCheckBoxLabel.h"
#import "UIView+BMSize.h"
#import "NSObject+BMCategory.h"
#import "BMAlignedImageView.h"
#import "UIImageView+WebCache.h"

#define BMCheckboxDefaultGap 6.0f

@interface BMCheckBoxLabel ()
<
    UIGestureRecognizerDelegate
>

@property (nonatomic, assign) CGFloat labelWidth;

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) BMAlignedImageView *imageView;

@property (nonatomic, weak) UITapGestureRecognizer *imageTapGestureRecognizer;
@property (nonatomic, weak) UILongPressGestureRecognizer *imageLongPressGestureRecognizer;

@end

@interface BMCheckBox ()

- (void)placeCheckBoxView;

@end

@implementation BMCheckBoxLabel

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, BMCheckboxDefaultWidth, BMCheckboxDefaultWidth)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame checkWidth:BMCheckboxDefaultWidth];
}

- (instancetype)initWithFrame:(CGRect)frame checkWidth:(CGFloat)checkWidth
{
    return [self initWithFrame:frame checkWidth:checkWidth useGesture:NO];
}

- (instancetype)initWithFrame:(CGRect)frame checkWidth:(CGFloat)checkWidth useGesture:(BOOL)useGesture
{
    return [self initWithFrame:frame checkWidth:checkWidth labelText:nil useGesture:NO];
}

- (instancetype)initWithFrame:(CGRect)frame checkWidth:(CGFloat)checkWidth labelText:(nullable NSString *)labelText useGesture:(BOOL)useGesture
{
    return [self initWithFrame:frame checkWidth:checkWidth labelText:labelText checkBoxGap:BMCheckboxDefaultGap useGesture:NO];
}

- (instancetype)initWithFrame:(CGRect)frame checkWidth:(CGFloat)checkWidth labelText:(NSString *)labelText checkBoxGap:(CGFloat)checkBoxGap useGesture:(BOOL)useGesture
{
    self = [super initWithFrame:frame checkWidth:checkWidth useGesture:useGesture];
    if (self)
    {
        [self setupTextLabel];
        [self setupImageView];
        
        self.checkBoxGap = checkBoxGap;
        self.labelText = labelText;
        
        self.labelTextCheckedColor = [UIColor blackColor];
        self.labelTextUnCheckedColor = [UIColor blackColor];
        self.labelTextMixedColor = [UIColor blackColor];
        
        self.labelTextAlignment = NSTextAlignmentLeft;
        self.labelTextFont = [UIFont systemFontOfSize:14.0f];
    }
    return self;
}

- (void)setupTextLabel
{
    UILabel *textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.numberOfLines = 0;
    textLabel.adjustsFontSizeToFitWidth = YES;
    textLabel.minimumScaleFactor = 0.5f;
    textLabel.hidden = YES;
    self.textLabel = textLabel;
    [self addSubview:textLabel];
}

- (void)setupImageView
{
    BMAlignedImageView *imageView = [[BMAlignedImageView alloc] initWithFrame:self.bounds];
    self.imageView = imageView;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.userInteractionEnabled = NO;
    imageView.hidden = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
}

- (void)setCheckState:(BMCheckBoxState)checkState
{
    [super setCheckState:checkState];
    
    self.textLabel.textColor = self.labelTextColor;
    if (self.labelAttrText)
    {
        self.textLabel.attributedText = self.labelAttrText;
    }
}

- (void)placeCheckBoxView
{
    [super placeCheckBoxView];
    
    self.labelWidth = self.bm_width-self.checkWidth-self.checkBoxGap;
    
    self.textLabel.frame = self.bounds;
    self.textLabel.bm_width = self.labelWidth;
    
    self.imageView.frame = self.bounds;
    self.imageView.bm_width = self.labelWidth;
    
    switch (self.horizontallyType)
    {
        case BMCheckBoxHorizontallyType_Left:
            self.textLabel.bm_left = self.checkWidth+self.checkBoxGap;
            self.imageView.bm_left = self.checkWidth+self.checkBoxGap;
            self.imageView.horizontallyAlignment = BMImageViewHorizontallyAlignmentLeft;
            break;
            
        case BMCheckBoxHorizontallyType_Right:
            self.textLabel.bm_left = 0;
            self.imageView.bm_left = 0;
            self.imageView.horizontallyAlignment = BMImageViewHorizontallyAlignmentRight;
            break;
            
        default:
            self.textLabel.bm_left = self.checkWidth+self.checkBoxGap;
            self.imageView.bm_left = self.checkWidth+self.checkBoxGap;
            self.imageView.horizontallyAlignment = BMImageViewHorizontallyAlignmentLeft;
            break;
    }
    
    switch (self.verticallyType)
    {
        case BMCheckBoxVerticallyType_Top:
            self.imageView.verticallyAlignment = BMImageViewVerticallyAlignmentTop;
            break;
            
        case BMCheckBoxVerticallyType_Center:
            self.imageView.verticallyAlignment = BMImageViewVerticallyAlignmentCenter;
            break;
            
        case BMCheckBoxVerticallyType_Bottom:
            self.imageView.verticallyAlignment = BMImageViewVerticallyAlignmentBottom;
            break;
            
        default:
            self.imageView.verticallyAlignment = BMImageViewVerticallyAlignmentTop;
            break;
    }
    
    if (self.labelImage)
    {
        self.imageView.image = self.labelImage;
    }
    else if (self.labelImageUrl)
    {
        [self.imageView.realImageView sd_setImageWithURL:[NSURL URLWithString:self.labelImageUrl]
                          placeholderImage:self.placeholderLabelImage
                                   options:SDWebImageRetryFailed | SDWebImageLowPriority
                                 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                     [self.imageView setNeedsLayout];
                                 }];
    }
}

- (BMCheckBoxLabelType)boxLabelType
{
    if (self.imageView.hidden == NO)
    {
        return BMCheckBoxLabelType_Image;
    }

    return BMCheckBoxLabelType_Text;
}

- (void)setCheckBoxGap:(CGFloat)checkBoxGap
{
    if (checkBoxGap < 0)
    {
        checkBoxGap = 0;
    }
    
    _checkBoxGap = checkBoxGap;
    
    [self placeCheckBoxView];
}

- (void)setLabelText:(NSString *)labelText
{
    _labelText = labelText;
    
    self.labelUnCheckedAttrText = nil;
    self.labelCheckedAttrText = nil;
    self.labelMixedAttrText = nil;
    self.textLabel.text = labelText;
    if (labelText)
    {
        self.textLabel.hidden = NO;
        self.imageView.hidden = YES;
    }
}

- (void)setLabelUnCheckedAttrText:(NSAttributedString *)labelUnCheckedAttrText
{
    _labelUnCheckedAttrText = labelUnCheckedAttrText;
    if (self.checkState == BMCheckBoxState_UnChecked)
    {
        self.textLabel.attributedText = labelUnCheckedAttrText;
    }
    
    if (labelUnCheckedAttrText)
    {
        self.textLabel.hidden = NO;
        self.imageView.hidden = YES;
    }
}

- (void)setLabelCheckedAttrText:(NSAttributedString *)labelCheckedAttrText
{
    _labelCheckedAttrText = labelCheckedAttrText;
    if (self.checkState == BMCheckBoxState_Checked)
    {
        self.textLabel.attributedText = labelCheckedAttrText;
    }
    
    if (labelCheckedAttrText)
    {
        self.textLabel.hidden = NO;
        self.imageView.hidden = YES;
    }
}

- (void)setLabelMixedAttrText:(NSAttributedString *)labelMixedAttrText
{
    _labelMixedAttrText = labelMixedAttrText;
    if (self.checkState == BMCheckBoxState_Mixed)
    {
        self.textLabel.attributedText = labelMixedAttrText;
    }
    
    if (labelMixedAttrText)
    {
        self.textLabel.hidden = NO;
        self.imageView.hidden = YES;
    }
}

- (NSAttributedString *)labelAttrText
{
    switch (self.checkState)
    {
        case BMCheckBoxState_UnChecked:
            return self.labelUnCheckedAttrText;
            
        case BMCheckBoxState_Checked:
            return self.labelCheckedAttrText;
            
        case BMCheckBoxState_Mixed:
            return self.labelMixedAttrText;
            
        default:
            return self.labelUnCheckedAttrText;
    }
}

- (void)setLabelTextAlignment:(NSTextAlignment)labelTextAlignment
{
    _labelTextAlignment = labelTextAlignment;
    self.textLabel.textAlignment = labelTextAlignment;
}

- (void)setLabelTextFont:(UIFont *)labelTextFont
{
    _labelTextFont = labelTextFont;
    self.textLabel.font = labelTextFont;
}

- (void)setLabelTextUnCheckedColor:(UIColor *)labelTextUnCheckedColor
{
    _labelTextUnCheckedColor = labelTextUnCheckedColor;
    if (self.checkState == BMCheckBoxState_UnChecked)
    {
        self.textLabel.textColor = labelTextUnCheckedColor;
    }
}

- (void)setLabelTextCheckedColor:(UIColor *)labelTextCheckedColor
{
    _labelTextCheckedColor = labelTextCheckedColor;
    if (self.checkState == BMCheckBoxState_Checked)
    {
        self.textLabel.textColor = labelTextCheckedColor;
    }
}

- (void)setLabelTextMixedColor:(UIColor *)labelTextMixedColor
{
    _labelTextMixedColor = labelTextMixedColor;
    if (self.checkState == BMCheckBoxState_Mixed)
    {
        self.textLabel.textColor = labelTextMixedColor;
    }
}

- (UIColor *)labelTextColor
{
    switch (self.checkState)
    {
        case BMCheckBoxState_UnChecked:
            return self.labelTextUnCheckedColor;
            
        case BMCheckBoxState_Checked:
            return self.labelTextCheckedColor;
            
        case BMCheckBoxState_Mixed:
            return self.labelTextMixedColor;
            
        default:
            return self.labelTextUnCheckedColor;
    }
}

- (void)setLabelImage:(UIImage *)labelImage
{
    _labelImage = labelImage;
    
    if (labelImage)
    {
        self.labelImageUrl = nil;
        
        self.textLabel.hidden = YES;
        self.imageView.hidden = NO;
    }
    
    [self placeCheckBoxView];
}

- (void)setLabelImageUrl:(NSString *)labelImageUrl
{
    _labelImageUrl = labelImageUrl;
    
    if (labelImageUrl)
    {
        self.labelImage = nil;
        
        self.textLabel.hidden = YES;
        self.imageView.hidden = NO;
    }
    
    [self placeCheckBoxView];
}

- (void)setImageLongPress:(checkBoxLabelImageLongPress)imageLongPress
{
    _imageLongPress = imageLongPress;
    
    if (imageLongPress)
    {
        self.imageView.userInteractionEnabled = YES;
        self.imageView.exclusiveTouch = YES;

        UITapGestureRecognizer *imageTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapCheckBox:)];
         self.imageTapGestureRecognizer = imageTapGestureRecognizer;
        imageTapGestureRecognizer.delegate = self;
        [self.imageView addGestureRecognizer:imageTapGestureRecognizer];

        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureDidFire:)];
        [imageTapGestureRecognizer requireGestureRecognizerToFail:longPressGestureRecognizer];
        longPressGestureRecognizer.delegate = self;
        self.imageLongPressGestureRecognizer = longPressGestureRecognizer;
        [self.imageView addGestureRecognizer:longPressGestureRecognizer];
    }
    else
    {
        self.imageView.userInteractionEnabled = NO;

        if (self.imageTapGestureRecognizer)
        {
            [self.imageView removeGestureRecognizer:self.imageTapGestureRecognizer];
            self.imageTapGestureRecognizer = nil;
        }
        if (self.imageLongPressGestureRecognizer)
        {
            [self.imageView removeGestureRecognizer:self.imageLongPressGestureRecognizer];
            self.imageLongPressGestureRecognizer = nil;
        }
    }
}

- (void)longPressGestureDidFire:(UILongPressGestureRecognizer *)longPressGestureRecognizer
{
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if (self.imageLongPress)
        {
            self.imageLongPress(self);
        }
        else
        {
            [self handleTapCheckBox:longPressGestureRecognizer];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
