//
//  UILabel+BMCategory.m
//  BMBasekit
//
//  Created by DennisDeng on 15/7/20.
//  Copyright (c) 2015年 DennisDeng. All rights reserved.
//

#import "UILabel+BMCategory.h"
#import "NSString+BMCategory.h"
//#import <CoreText/CoreText.h>

@implementation UILabel (BMCategory)

+ (instancetype)bm_labelWithFrame:(CGRect)frame text:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color alignment:(NSTextAlignment)alignment lines:(NSInteger)lines
{
    return [UILabel bm_labelWithFrame:frame text:text fontSize:fontSize color:color alignment:alignment lines:lines shadowColor:[UIColor clearColor]];
}

+ (instancetype)bm_labelWithFrame:(CGRect)frame text:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color alignment:(NSTextAlignment)alignment lines:(NSInteger)lines shadowColor:(UIColor *)txtShadowColor
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = lines;

    label.font = [UIFont systemFontOfSize:fontSize];
    
    label.text = text;
    if (color)
    {
        label.textColor = color;
    }
    if (txtShadowColor)
    {
        label.shadowColor = txtShadowColor;
    }
    label.textAlignment = alignment;
    
    return label;
}

- (CGSize)bm_attribSizeToFitWidth:(CGFloat)width
{
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    return [self bm_attribSizeToFit:maxSize];
}

- (CGSize)bm_attribSizeToFitHeight:(CGFloat)height
{
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, height);
    return [self bm_attribSizeToFit:maxSize];
}

- (CGSize)bm_attribSizeToFit:(CGSize)maxSize
{
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    if (self.lineBreakMode ==  NSLineBreakByTruncatingHead ||
        self.lineBreakMode ==  NSLineBreakByTruncatingTail ||
        self.lineBreakMode ==  NSLineBreakByTruncatingMiddle )
    {
        options |= NSStringDrawingTruncatesLastVisibleLine;
    }
    //NSLineBreakMode mode  = self.lineBreakMode;
    //self.lineBreakMode = NSLineBreakByCharWrapping;
    
    CGRect textRect  = [self.attributedText boundingRectWithSize:maxSize options:options context:NULL];
    //self.lineBreakMode = mode;
    
    return textRect.size;
}

- (CGSize)bm_labelSizeToFitWidth:(CGFloat)width
{
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    return [self bm_labelSizeToFit:maxSize];
}

- (CGSize)bm_labelSizeToFitHeight:(CGFloat)height
{
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, height);
    return [self bm_labelSizeToFit:maxSize];
}

- (CGSize)bm_labelSizeToFit:(CGSize)maxSize
{
#if 0
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    if (self.lineBreakMode ==  NSLineBreakByTruncatingHead ||
        self.lineBreakMode ==  NSLineBreakByTruncatingTail ||
        self.lineBreakMode ==  NSLineBreakByTruncatingMiddle )
    {
        options |= NSStringDrawingTruncatesLastVisibleLine;
    }
    //NSLineBreakMode mode  = self.lineBreakMode;
    //self.lineBreakMode = NSLineBreakByCharWrapping;
    
//    if (self.numberOfLines > 0)
//    {
//        maxSize = CGSizeMake(maxSize.width, self.font.lineHeight * self.numberOfLines);
//    }
    
    NSDictionary *attributes = @{NSFontAttributeName:self.font};
    CGRect textRect  = [self.text boundingRectWithSize:maxSize options:options attributes:attributes context:NULL];
    
//    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
//    [as removeAttribute:NSParagraphStyleAttributeName range:NSMakeRange(0, [self.attributedText length])];
//    CGRect textRect  = [as boundingRectWithSize:maxSize options:options context:NULL];
    //self.lineBreakMode = mode;
    
    return textRect.size;
#else
    CGSize size = [self.text bm_sizeToFit:maxSize withFont:self.font lineBreakMode:self.lineBreakMode];
    
    return size;
#endif
}

- (CGFloat)bm_calculatedHeight
{
    if (self.attributedText)
    {
        return [self bm_attribSizeToFitWidth:self.bm_width].height;
    }
    else
    {
        return [self bm_labelSizeToFitWidth:self.bm_width].height;
    }
}

@end
