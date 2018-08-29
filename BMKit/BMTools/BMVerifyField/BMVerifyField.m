//
//  BMVerifyField.m
//  fengshun
//
//  Created by jiang deng on 2018/8/28.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "BMVerifyField.h"

#define DEFAULT_CONTENT_SIZE_WITH_UNIT_COUNT(c) CGSizeMake(40 * c, 40)

@interface BMVerifyField ()

@property (nonatomic, assign) NSUInteger inputMaxCount;

@property (nonatomic, strong) NSMutableArray <NSString *> *characterArray;
@property (nonatomic, strong) CALayer *cursorLayer;

@end

@implementation BMVerifyField
@synthesize secureTextEntry = _secureTextEntry;
@synthesize enablesReturnKeyAutomatically = _enablesReturnKeyAutomatically;
@synthesize keyboardType = _keyboardType;
@synthesize returnKeyType = _returnKeyType;

@synthesize autocapitalizationType = _autocapitalizationType;
@synthesize autocorrectionType = _autocorrectionType;

- (instancetype)initWithInputCount:(NSUInteger)count
{
    if (self = [super initWithFrame:CGRectZero])
    {
        NSCAssert(count <= 8, @"WLUnitField can not have more than 8 input units.");
        
        _inputMaxCount = count;
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _inputMaxCount = 4;
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    [self setBackgroundColor:[UIColor clearColor]];
    self.opaque = NO;
    
    _secureTextEntry = NO;
    _keyboardType = UIKeyboardTypeNumberPad;
    _returnKeyType = UIReturnKeyDone;
    _enablesReturnKeyAutomatically = YES;
    _autocorrectionType = UITextAutocorrectionTypeNo;
    _autocapitalizationType = UITextAutocapitalizationTypeNone;

    _characterArray = [NSMutableArray array];
    
    _itemSpace = 12.0f;
    _borderRadius = 4.0f;
    _borderWidth = 1.0f;
    _borderColor = [UIColor lightGrayColor];
    _trackBorderColor = [UIColor orangeColor];

    _textFont = [UIFont systemFontOfSize:24];
    _textColor = [UIColor darkGrayColor];

    _cursorColor = [UIColor orangeColor];

    self.cursorLayer.backgroundColor = _cursorColor.CGColor;
    
    _autoResignFirstResponderWhenInputFinished = YES;

    [self.layer addSublayer:self.cursorLayer];
    [self setNeedsDisplay];
}


#pragma mark - Property

- (CALayer *)cursorLayer
{
    if (!_cursorLayer)
    {
        _cursorLayer = [CALayer layer];
        _cursorLayer.hidden = YES;
        _cursorLayer.opacity = 1;
        
        CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animate.fromValue = @(0);
        animate.toValue = @(1.5);
        animate.duration = 0.5;
        animate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animate.autoreverses = YES;
        animate.removedOnCompletion = NO;
        animate.fillMode = kCAFillModeForwards;
        animate.repeatCount = HUGE_VALF;
        
        [_cursorLayer addAnimation:animate forKey:nil];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self layoutIfNeeded];
            self.cursorLayer.position = CGPointMake(CGRectGetWidth(self.bounds) / self.inputMaxCount * 0.5, CGRectGetHeight(self.bounds) * 0.5);
        }];
    }
    
    return _cursorLayer;
}

- (NSString *)text
{
    if ([self.characterArray bm_isNotEmpty])
    {
        return [self.characterArray componentsJoinedByString:@""];
    }
    else
    {
        return nil;
    }
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry
{
    _secureTextEntry = secureTextEntry;
    
    [self setNeedsDisplay];
    [self resetCursorLayerIfNeeded];
}

/// 在 iOS 11 及 iOS 12 beta 测试版系统中，对于实现了 UIKeyInput 协议的自定义控件，系统键盘的输入预测 pannel
/// 极大概率会错位，键盘高度异常。猜测也许是系统 bug，如果你知道解决版办法，我很期待你的解答:)。
/// 禁用大小写。感谢 jixiang0903 [https://github.com/jixiang0903] 提供的建议
- (void)setAutocapitalizationType:(UITextAutocapitalizationType)autocapitalizationType
{
    _autocapitalizationType = UITextAutocapitalizationTypeNone;
}

/// 在 iOS 11 及 iOS 12 beta 测试版系统中，对于实现了 UIKeyInput 协议的自定义控件，系统键盘的输入预测 pannel
/// 极大概率会错位，键盘高度异常。猜测也许是系统 bug，如果你知道解决版办法，我很期待你的解答:)。
/// 禁用输入预测修正。感谢 jixiang0903 [https://github.com/jixiang0903] 提供的建议
- (void)setAutocorrectionType:(UITextAutocorrectionType)autocorrectionType
{
    _autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)setInputMaxCount:(NSUInteger)inputMaxCount
{
    if (inputMaxCount > 8)
    {
        inputMaxCount = 8;
    }
    
    _inputMaxCount = inputMaxCount;
    
    [self setNeedsDisplay];
    [self resetCursorLayerIfNeeded];
}

- (void)setItemSpace:(CGFloat)itemSpace
{
    if (itemSpace < 2)
    {
        itemSpace = 0;
    }
    
    _itemSpace = itemSpace;
    
    [self setNeedsDisplay];
    [self resetCursorLayerIfNeeded];
}

- (void)setBorderRadius:(CGFloat)borderRadius
{
    if (borderRadius < 0)
    {
        return;
    }
    
    _borderRadius = borderRadius;
    [self setNeedsDisplay];
    [self resetCursorLayerIfNeeded];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    if (borderWidth < 0)
    {
        return;
    }

    _borderWidth = borderWidth;
    [self setNeedsDisplay];
    [self resetCursorLayerIfNeeded];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    if (borderColor == nil)
    {
        borderColor = [UIColor lightGrayColor];
    }
    
    _borderColor = borderColor;
    
    [self setNeedsDisplay];
    [self resetCursorLayerIfNeeded];
}

- (void)setTrackBorderColor:(UIColor *)trackBorderColor
{
    _trackBorderColor = trackBorderColor;
    
    [self setNeedsDisplay];
    [self resetCursorLayerIfNeeded];
}

- (void)setTextFont:(UIFont *)textFont
{
    if (textFont == nil)
    {
        textFont = [UIFont systemFontOfSize:24];
    }

    _textFont = textFont;
    
    [self setNeedsDisplay];
    [self resetCursorLayerIfNeeded];
}

- (void)setTextColor:(UIColor *)textColor
{
    if (textColor == nil)
    {
        textColor = [UIColor blackColor];
    }

    _textColor = textColor;
    
    [self setNeedsDisplay];
    [self resetCursorLayerIfNeeded];
}

- (void)setCursorColor:(UIColor *)cursorColor
{
    _cursorColor = cursorColor;
    _cursorLayer.backgroundColor = _cursorColor.CGColor;
    
    [self resetCursorLayerIfNeeded];
}


#pragma mark- Event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self becomeFirstResponder];
}


#pragma mark - Override

- (CGSize)intrinsicContentSize
{
    CGSize size = self.bounds.size;
    size.width = MAX(size.width, DEFAULT_CONTENT_SIZE_WITH_UNIT_COUNT(self.inputMaxCount).width);
    CGFloat unitWidth = (size.width + self.itemSpace) / self.inputMaxCount - self.itemSpace;
    size.height = unitWidth;
    
    return size;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return [self intrinsicContentSize];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
    [self resetCursorLayerIfNeeded];
    
    if (result ==  YES)
    {
        [self sendActionsForControlEvents:UIControlEventEditingDidBegin];
    }
    
    return result;
}

- (BOOL)canResignFirstResponder
{
    return YES;
}

- (BOOL)resignFirstResponder
{
    BOOL result = [super resignFirstResponder];
    [self resetCursorLayerIfNeeded];
    
    if (result)
    {
        [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
    }
    
    return result;
}


#pragma mark - drawUI

- (void)resetCursorLayerIfNeeded
{
    self.cursorLayer.hidden = !self.isFirstResponder || self.cursorColor == nil || self.inputMaxCount == self.characterArray.count;
    
    if (self.cursorLayer.hidden)
    {
        return;
    }
    
    CGSize itemSize = CGSizeMake((self.bounds.size.width + self.itemSpace) / self.inputMaxCount - self.itemSpace, self.bounds.size.height);
    
    CGRect itemRect = CGRectMake(self.characterArray.count * (itemSize.width + self.itemSpace),
                                 0,
                                 itemSize.width,
                                 itemSize.height);
    itemRect = CGRectInset(itemRect,
                           itemRect.size.width * 0.5 - 1,
                           (itemRect.size.height - self.textFont.pointSize) * 0.5);
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationDuration:0];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    self.cursorLayer.frame = itemRect;
    [CATransaction commit];
}

- (void)drawRect:(CGRect)rect
{
    CGSize itemSize = CGSizeMake((rect.size.width + self.itemSpace) / self.inputMaxCount - self.itemSpace, rect.size.height);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self drawBorder:ctx withRect:rect itemSize:itemSize];
    [self drawText:ctx withRect:rect itemSize:itemSize];
    [self drawTrackBorder:ctx withRect:rect itemSize:itemSize];
}

// 绘制边框
- (void)drawBorder:(CGContextRef)ctx withRect:(CGRect)rect itemSize:(CGSize)itemSize
{
    [self.borderColor setStroke];
    
    CGContextSetLineWidth(ctx, self.borderWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGRect bounds = CGRectInset(rect, self.borderWidth * 0.5, self.borderWidth * 0.5);
    
    if (self.itemSpace < 2)
    {
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:self.borderRadius];
        CGContextAddPath(ctx, bezierPath.CGPath);
        
        for (NSUInteger i = 1; i < self.inputMaxCount; ++i)
        {
            CGContextMoveToPoint(ctx, (i * itemSize.width), 0);
            CGContextAddLineToPoint(ctx, (i * itemSize.width), (itemSize.height));
        }
    }
    else
    {
        for (NSUInteger i = self.characterArray.count; i < self.inputMaxCount; i++)
        {
            CGRect itemRect = CGRectMake(i * (itemSize.width + self.itemSpace),
                                         0,
                                         itemSize.width,
                                         itemSize.height);
            itemRect = CGRectInset(itemRect, self.borderWidth * 0.5, self.borderWidth * 0.5);
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:itemRect cornerRadius:self.borderRadius];
            CGContextAddPath(ctx, bezierPath.CGPath);
        }
    }
    
    CGContextDrawPath(ctx, kCGPathStroke);
}

// 绘制文本
- (void)drawText:(CGContextRef)ctx withRect:(CGRect)rect itemSize:(CGSize)itemSize
{
    if ([self hasText] == NO)
    {
        return;
    }
    
    NSDictionary *attr = @{NSForegroundColorAttributeName: self.textColor,
                           NSFontAttributeName: self.textFont};
    for (NSUInteger i = 0; i < self.characterArray.count; i++)
    {
        CGRect itemRect = CGRectMake(i * (itemSize.width + self.itemSpace),
                                     0,
                                     itemSize.width,
                                     itemSize.height);
        
        if (self.secureTextEntry == NO)
        {
            NSString *subString = [self.characterArray objectAtIndex:i];
            
            CGSize oneTextSize = [subString sizeWithAttributes:attr];
            CGRect drawRect = CGRectInset(itemRect,
                                          (itemRect.size.width - oneTextSize.width) / 2,
                                          (itemRect.size.height - oneTextSize.height) / 2);
            [subString drawInRect:drawRect withAttributes:attr];
        }
        else
        {
            CGRect drawRect = CGRectInset(itemRect,
                                          (itemRect.size.width - self.textFont.pointSize / 2) / 2,
                                          (itemRect.size.height - self.textFont.pointSize / 2) / 2);
            [self.textColor setFill];
            CGContextAddEllipseInRect(ctx, drawRect);
            CGContextFillPath(ctx);
        }
    }
}

// 绘制跟踪框
- (void)drawTrackBorder:(CGContextRef)ctx withRect:(CGRect)rect itemSize:(CGSize)itemSize
{
    if (self.trackBorderColor == nil || self.itemSpace < 2)
    {
        return;
    }
    
    [self.trackBorderColor setStroke];
    CGContextSetLineWidth(ctx, self.borderWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    for (NSUInteger i = 0; i < self.characterArray.count; i++)
    {
        CGRect itemRect = CGRectMake(i * (itemSize.width + self.itemSpace),
                                     0,
                                     itemSize.width,
                                     itemSize.height);
        itemRect = CGRectInset(itemRect, self.borderWidth * 0.5, self.borderWidth * 0.5);
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:itemRect cornerRadius:self.borderRadius];
        CGContextAddPath(ctx, bezierPath.CGPath);
    }
    
    CGContextDrawPath(ctx, kCGPathStroke);
}


#pragma mark - UIKeyInput

- (BOOL)hasText
{
    return [self.characterArray bm_isNotEmpty];
}

- (void)insertText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self resignFirstResponder];
        }];
        
        return;
    }
    
    if (self.characterArray.count >= self.inputMaxCount)
    {
        if (self.autoResignFirstResponderWhenInputFinished == YES)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self resignFirstResponder];
                
                if ([self.delegate respondsToSelector:@selector(verifyFieldInputFinished:)])
                {
                    [self.delegate verifyFieldInputFinished:self];
                }
            }];
        }
        
        return;
    }
    
    if ([text isEqualToString:@" "])
    {
        return;
    }
    
    NSUInteger addCount = self.inputMaxCount - self.characterArray.count;
    for (NSUInteger i = 0; i<addCount && i<text.length; i++)
    {
        NSString *subText = [text substringWithRange:NSMakeRange(i, 1)];
        if ([self.delegate respondsToSelector:@selector(verifyField:shouldChangeCharacterAtIndex:replacementString:)])
        {
            if ([self.delegate verifyField:self shouldChangeCharacterAtIndex:self.characterArray.count replacementString:subText] == NO)
            {
                return;
            }
        }
        
        [self.characterArray addObject:subText];
    }
    
    if (self.characterArray.count >= self.inputMaxCount)
    {
        if (self.autoResignFirstResponderWhenInputFinished == YES)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self resignFirstResponder];
                
                if ([self.delegate respondsToSelector:@selector(verifyFieldInputFinished:)])
                {
                    [self.delegate verifyFieldInputFinished:self];
                }
            }];
        }
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];

    [self setNeedsDisplay];
    [self resetCursorLayerIfNeeded];
}

- (void)deleteBackward
{
    if ([self hasText] == NO)
    {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(verifyField:shouldChangeCharacterAtIndex:replacementString:)])
    {
        if ([self.delegate verifyField:self shouldChangeCharacterAtIndex:self.characterArray.count replacementString:@""] == NO)
        {
            return;
        }
    }

    [self.characterArray removeLastObject];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    [self setNeedsDisplay];
    [self resetCursorLayerIfNeeded];
}


@end
