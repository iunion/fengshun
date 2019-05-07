//
//  BMImageTextView.m
//  BMkit
//
//  Created by DennisDeng on 15/9/03.
//  Copyright (c) 2015年 DennisDeng. All rights reserved.
//

#import "BMImageTextView.h"

#import "UILabel+BMCategory.h"
#import "UIImageView+WebCache.h"

#define IMAGE_GAP           4.0f
#define IMAGETEXT_GAP       4.0f
#define ACCESSORYARROW_GAP  8.0f

#define ARROWIMAGE_WIDTH    12.0f

@interface BMImageTextView ()

@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIControl *controlView;

@property (strong, nonatomic) UIImageView *arrowImageView;

@end

@implementation BMImageTextView
@synthesize textColor = _textColor;
@synthesize textFont = _textFont;

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"init not supported, use initWithText: instead." userInfo:nil];
    return nil;
}

- (instancetype)initWithText:(NSString *)text
{
    return [self initWithText:text height:TABLE_CELL_HEIGHT];
}

- (instancetype)initWithText:(NSString *)text height:(CGFloat)height
{
    return [self initWithImage:nil text:text height:height gap:IMAGETEXT_GAP];
}

- (instancetype)initWithImage:(NSString *)image height:(CGFloat)height
{
    return [self initWithImage:image text:nil height:height gap:IMAGETEXT_GAP];
}

- (instancetype)initWithImage:(NSString *)image text:(NSString *)text height:(CGFloat)height gap:(CGFloat)gap
{
    return [self initWithImage:image text:text type:BMImageTextViewType_ImageLeft height:height gap:gap];
}

- (instancetype)initWithImage:(NSString *)image text:(NSString *)text type:(BMImageTextViewType)type height:(CGFloat)height gap:(CGFloat)gap
{
    return [self initWithImage:image text:text type:type textColor:nil textFont:nil height:height gap:gap];
}

- (instancetype)initWithImage:(nullable NSString *)image text:(nullable NSString *)text type:(BMImageTextViewType)type textColor:(UIColor *)textColor textFont:(UIFont *)textFont height:(CGFloat)height gap:(CGFloat)gap
{
    return [self initWithImage:image text:text type:type textColor:textColor textFont:textFont height:height gap:gap clicked:nil];
}

- (instancetype)initWithImage:(nullable NSString *)image text:(nullable NSString *)text type:(BMImageTextViewType)type textColor:(nullable UIColor *)textColor textFont:(nullable UIFont *)textFont height:(CGFloat)height gap:(CGFloat)gap clicked:(BMImageTextViewClicked)clicked
{
    return [self initWithImage:image text:text attributedText:nil type:type textColor:textColor textFont:textFont height:height gap:gap clicked:clicked];
}

- (instancetype)initWithImage:(nullable NSString *)image text:(nullable NSString *)text attributedText:(NSAttributedString *)attributedText type:(BMImageTextViewType)type textColor:(nullable UIColor *)textColor textFont:(nullable UIFont *)textFont height:(CGFloat)height gap:(CGFloat)gap clicked:(BMImageTextViewClicked)clicked
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    _type = type;
    
    _imageName = image;
    _imageUrl = nil;
    
    _text = text;
    _attributedText = attributedText;
    
    _textColor = textColor;
    
    _textFont = textFont;
    
    _imageTextGap = gap;
    _accessoryArrowGap = ACCESSORYARROW_GAP;
    _accessoryArrowType = BMImageTextViewAccessoryArrowType_Show;
    
    if (height <= 0)
    {
        height = TABLE_CELL_HEIGHT;
    }
    self.bm_height = height;
    
    _imageTextViewClicked = clicked;

    [self makeView];
    
    return self;
}

- (instancetype)initWithAttributedText:(NSAttributedString *)attributedText
{
    return [self initWithAttributedText:attributedText height:TABLE_CELL_HEIGHT];
}

- (instancetype)initWithAttributedText:(NSAttributedString *)attributedText height:(CGFloat)height
{
    return [self initWithImage:nil attributedText:attributedText height:height gap:IMAGETEXT_GAP];
}

- (instancetype)initWithAttributedText:(NSAttributedString *)attributedText image:(NSString *)image
{
    return [self initWithImage:image attributedText:attributedText type:BMImageTextViewType_ImageRight height:TABLE_CELL_HEIGHT gap:6.0f];
}

- (instancetype)initWithAttributedText:(NSAttributedString *)attributedText image:(NSString *)image gap:(CGFloat)gap
{
    return [self initWithImage:image attributedText:attributedText type:BMImageTextViewType_ImageRight height:TABLE_CELL_HEIGHT gap:gap];
}

- (instancetype)initWithImage:(NSString *)image attributedText:(NSAttributedString *)attributedText height:(CGFloat)height gap:(CGFloat)gap
{
    return [self initWithImage:image attributedText:attributedText type:BMImageTextViewType_ImageLeft height:height gap:gap];
}

- (instancetype)initWithImage:(NSString *)image attributedText:(NSAttributedString *)attributedText type:(BMImageTextViewType)type height:(CGFloat)height gap:(CGFloat)gap
{
    return [self initWithImage:image attributedText:attributedText type:type height:height gap:gap clicked:nil];
}

- (instancetype)initWithImage:(NSString *)image attributedText:(NSAttributedString *)attributedText type:(BMImageTextViewType)type height:(CGFloat)height gap:(CGFloat)gap clicked:(BMImageTextViewClicked)clicked
{
    return [self initWithImage:image text:nil attributedText:attributedText type:type textColor:nil textFont:nil height:height gap:gap clicked:clicked];
}

- (void)setImageTextViewClicked:(BMImageTextViewClicked)imageTextViewClicked
{
    self.controlView.hidden = (imageTextViewClicked == nil);
    
    _imageTextViewClicked = imageTextViewClicked;
}

- (void)makeView
{
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *textLable = [[UILabel alloc] init];
    textLable.backgroundColor = [UIColor clearColor];
    textLable.hidden = YES;
    
    [self addSubview:textLable];
    
    self.textLabel = textLable;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.hidden = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    self.imageView = imageView;
    
    imageView = [[UIImageView alloc] init];
    imageView.hidden = YES;
    imageView.bm_width = ARROWIMAGE_WIDTH;
    imageView.bm_height = ARROWIMAGE_WIDTH;
    imageView.image = [UIImage imageNamed:@"BMTableView_arrows_rightBlack"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    self.arrowImageView = imageView;
    
    UIControl *control = [[UIControl alloc] init];
    control.backgroundColor = [UIColor clearColor];
    control.hidden = (_imageTextViewClicked == nil);
    control.exclusiveTouch = YES;
    [control addTarget:self action:@selector(viewClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:control];
    
    self.controlView = control;
}

- (void)viewClicked
{
    if (self.imageTextViewClicked)
    {
        self.imageTextViewClicked(self);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize textSize = CGSizeZero;
    CGFloat textMaxWidth = 0;
    if (self.text || self.attributedText)
    {
        self.textLabel.hidden = NO;
        
        self.textLabel.textColor = self.textColor;
        self.textLabel.font = self.textFont;

        if (self.text)
        {
            self.textLabel.text = self.text;
            textSize = [self.textLabel bm_labelSizeToFit:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        }
        else
        {
            self.textLabel.attributedText = self.attributedText;
            textSize = [self.textLabel bm_attribSizeToFit:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        }
        
        textSize.height = self.bm_height;
        self.textLabel.bm_height = self.bm_height;
    }
    else
    {
        self.textLabel.hidden = YES;
    }
    
    CGFloat imageHeight = 0;
    CGFloat imageWidth = 0;
    if (self.imageName || self.imageUrl)
    {
        self.imageView.hidden = NO;
        
        if (self.imageName)
        {
            UIImage *placeholderImage = [UIImage imageNamed:self.imageName];
            self.imageView.image = placeholderImage;
            
            CGSize imageSize = placeholderImage.size;
            imageHeight = imageSize.height;
            if (imageHeight > self.bm_height - IMAGE_GAP)
            {
                imageHeight = self.bm_height - IMAGE_GAP;
            }
            if (imageSize.width)
            {
                imageWidth = imageHeight * (imageSize.width / imageSize.height);
            }
            else
            {
                imageWidth = imageHeight;
            }
            
            if (!CGSizeEqualToSize(self.imageSize, CGSizeZero))
            {
                imageHeight = self.imageSize.height;
                imageWidth = self.imageSize.width;
            }
            
            if (self.afterSetimage)
            {
                self.imageView.image = self.afterSetimage(self, placeholderImage, CGSizeMake(imageWidth, imageHeight));
            }
            
            if ([self.imageUrl bm_isNotEmpty])
            {
                BMWeakSelf
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:placeholderImage options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (!error)
                    {
                        if (weakSelf.afterSetimage)
                        {
                            weakSelf.imageView.image = weakSelf.afterSetimage(weakSelf, image, CGSizeMake(imageWidth, imageHeight));
                        }
                    }
                    else
                    {
                        if (weakSelf.afterSetimage)
                        {
                            weakSelf.imageView.image = weakSelf.afterSetimage(weakSelf, placeholderImage, CGSizeMake(imageWidth, imageHeight));
                        }
                    }
                }];
            }
        }
        else
        {
            UIImage *placeholderImage = [UIImage imageNamed:self.placeholderImageName];
            imageHeight = self.bm_height - IMAGE_GAP;
            imageWidth = imageHeight;
            
            BMWeakSelf
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:placeholderImage options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error)
                {
                    if (weakSelf.afterSetimage)
                    {
                        weakSelf.imageView.image = weakSelf.afterSetimage(weakSelf, image, CGSizeMake(imageWidth, imageHeight));
                    }
                }
                else
                {
                    if (weakSelf.afterSetimage)
                    {
                        weakSelf.imageView.image = weakSelf.afterSetimage(weakSelf, placeholderImage, CGSizeMake(imageWidth, imageHeight));
                    }
                }
            }];
        }
        
        self.imageView.bm_width = imageWidth;
        self.imageView.bm_height = imageHeight;
        
        // 为了好计算先加上间隙
        imageWidth = imageWidth + self.imageTextGap;
    }
    else
    {
        UIImage *placeholderImage = [UIImage imageNamed:self.placeholderImageName];
        if (placeholderImage)
        {
            self.imageView.hidden = NO;
            self.imageView.image = placeholderImage;
            
            imageHeight = self.bm_height - IMAGE_GAP;
            imageWidth = imageHeight;
            
            if (self.afterSetimage)
            {
                self.imageView.image = self.afterSetimage(self, placeholderImage, CGSizeMake(imageWidth, imageHeight));
            }
        }
        else
        {
            self.imageView.hidden = YES;
        }
        
        self.imageView.bm_width = imageWidth;
        self.imageView.bm_height = imageHeight;
    }
        
    if (self.showTableCellAccessoryArrow)
    {
        imageWidth = imageWidth + ARROWIMAGE_WIDTH + self.accessoryArrowGap;
    }

    if (self.maxWidth)
    {
        // 如果最大宽度比图片还小，将禁用，按原宽度显示
        if (self.maxWidth > imageWidth)
        {
            textMaxWidth = self.maxWidth - imageWidth;
            if (textMaxWidth < textSize.width)
            {
                textSize.width = textMaxWidth;
            }
        }
    }
    
    self.bm_width = imageWidth + textSize.width;
    self.controlView.frame = self.bounds;
    self.textLabel.bm_width = textSize.width;
    
    self.textLabel.bm_centerY = self.bm_height*0.5;
    self.imageView.bm_centerY = self.bm_height*0.5;

    self.arrowImageView.bm_centerY = self.bm_height*0.5;
    self.arrowImageView.bm_left = self.bm_width - ARROWIMAGE_WIDTH;
    if (self.showTableCellAccessoryArrow)
    {
        if (self.accessoryArrowType == BMImageTextViewAccessoryArrowType_Show)
        {
            self.arrowImageView.hidden = NO;
        }
        else
        {
            self.arrowImageView.hidden = YES;
        }
    }
    else
    {
        self.arrowImageView.hidden = YES;
    }

    if (self.type == BMImageTextViewType_ImageLeft)
    {
        self.imageView.bm_left = 0;
        self.textLabel.bm_left = self.imageView.bm_width + self.imageTextGap;
    }
    else
    {
        self.textLabel.bm_left = 0;
        self.imageView.bm_left = textSize.width + self.imageTextGap;
    }
    
    if (self.circleImage)
    {
        [self.imageView bm_circleView];
    }
    else
    {
        [self.imageView bm_removeBorders];
    }
}


#pragma mark settor/gettor

- (void)setType:(BMImageTextViewType)type
{
    if (_type != type)
    {
        _type = type;
        
        [self setNeedsLayout];
    }
}

- (void)setImageName:(NSString *)imageName
{
    if ([imageName isEqual:_imageName])
    {
        return;
    }
    
    _imageName = imageName;
    
    [self setNeedsLayout];
}

- (void)setImageUrl:(NSString *)imageUrl
{
    if ([imageUrl isEqual:_imageUrl])
    {
        return;
    }
    
    _imageUrl = imageUrl;
    
    [self setNeedsLayout];
}

- (void)setPlaceholderImageName:(NSString *)placeholderImageName
{
    if ([placeholderImageName isEqual:_placeholderImageName])
    {
        return;
    }
    
    _placeholderImageName = placeholderImageName;
    
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text
{
    if ([text isEqual:_text])
    {
        return;
    }
    
    _text = text;
    //self.textLabel.text = text;
    
    [self setNeedsLayout];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    if ([attributedText isEqual:_attributedText])
    {
        return;
    }
    
    _attributedText = attributedText;
    //self.textLabel.attributedText = attributedText;
    
    [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)textColor
{
    if ([textColor isEqual:_textColor])
    {
        return;
    }
    if (!textColor)
    {
        textColor =  [UIColor grayColor];
    }
    _textColor = textColor;
    self.textLabel.textColor = textColor;
}

- (UIColor *)textColor
{
    if (!_textColor)
    {
        return [UIColor grayColor];
    }
    
    return _textColor;
}

- (void)setTextFont:(UIFont *)textFont
{
    if ([textFont isEqual:_textFont])
    {
        return;
    }
    if (!textFont)
    {
        textFont = [UIFont systemFontOfSize:14.0f];
    }
    _textFont = textFont;
    
    [self setNeedsLayout];
}

- (UIFont *)textFont
{
    if (!_textFont)
    {
        return [UIFont systemFontOfSize:12.0f];
    }
    
    return _textFont;
}

- (void)setImageSize:(CGSize)imageSize
{
    if (CGSizeEqualToSize(_imageSize, imageSize))
    {
        return;
    }
    
    _imageSize = imageSize;
    
    [self setNeedsLayout];
}

- (void)setCircleImage:(BOOL)circleImage
{
    _circleImage = circleImage;
    
    [self setNeedsLayout];
}

- (void)setImageTextGap:(CGFloat)imageTextGap
{
    if (imageTextGap == _imageTextGap)
    {
        return;
    }
    
    _imageTextGap = imageTextGap;
    
    [self setNeedsLayout];
}

- (void)setMaxWidth:(CGFloat)maxWidth
{
    if (maxWidth == _maxWidth)
    {
        return;
    }
    
    if (maxWidth < 0)
    {
        maxWidth = 0;
    }
    
    _maxWidth = maxWidth;
    
    [self setNeedsLayout];
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth
{
    self.textLabel.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
    self.textLabel.minimumScaleFactor = 0.3f;
    
    [self setNeedsLayout];
}

- (BOOL)adjustsFontSizeToFitWidth
{
    return self.textLabel.adjustsFontSizeToFitWidth;
}

@end

