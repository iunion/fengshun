//
//  UITextField+BMCategory.m
//  BMBasekit
//
//  Created by DennisDeng on 16/6/17.
//  Copyright © 2016年 DennisDeng. All rights reserved.
//

#import "UITextField+BMCategory.h"

/** 通过这个属性名，就可以修改textField内部的占位文字颜色 */
//static NSString * const TextFieldPlaceholderColorKeyPath = @"_placeholderLabel.textColor";
static NSString * const TextFieldPlaceholderColorKeyPath = @"placeholderLabel.textColor";

@implementation UITextField (BMCategory)

- (void)bm_setPlaceholderColor:(UIColor *)color
{
    if (!color)
    {
        color = [UIColor grayColor];
        color  = [color colorWithAlphaComponent:0.7f];
    }
    
    [self setValue:color forKeyPath:TextFieldPlaceholderColorKeyPath];
}

- (void)bm_selectAllText
{
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

- (void)bm_setSelectedRange:(NSRange)range
{
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

@end
