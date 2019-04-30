//
//  BMVerifyField.m
//  fengshun
//
//  Created by jiang deng on 2018/8/28.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "BMVerifyField.h"
#import "BMVerifyFieldTextRange.h"

#define DEFAULT_CONTENT_SIZE_WITH_UNIT_COUNT(c) CGSizeMake(40 * c, 40)

@interface BMVerifyField ()

@property (nonatomic, assign) NSUInteger inputMaxCount;

@property (nonatomic, strong) NSMutableArray <NSString *> *characterArray;
@property (nonatomic, strong) CALayer *cursorLayer;

@property (nullable, nonatomic, strong) __kindof UIView *inputView;
@property (nullable, nonatomic, strong) __kindof UIView *inputAccessoryView;

@property (nonatomic, strong) NSString *markedText;


@end

@implementation BMVerifyField
{
    NSString *_markedText;
}

//@synthesize textContentType = _textContentType;
@synthesize secureTextEntry = _secureTextEntry;
@synthesize enablesReturnKeyAutomatically = _enablesReturnKeyAutomatically;
@synthesize keyboardType = _keyboardType;
@synthesize returnKeyType = _returnKeyType;

@synthesize autocapitalizationType = _autocapitalizationType;
@synthesize autocorrectionType = _autocorrectionType;

@synthesize inputDelegate = _inputDelegate;
@synthesize selectedTextRange = _selectedTextRange;
@synthesize markedTextStyle = _markedTextStyle;

- (void)dealloc
{
}

- (instancetype)initWithInputCount:(NSUInteger)count
{
    return [self initWithInputCount:count style:BMVerifyFieldStyle_Border];
}

- (instancetype)initWithInputCount:(NSUInteger)count style:(BMVerifyFieldStyle)style
{
    if (self = [super initWithFrame:CGRectZero])
    {
        NSCAssert(count <= 8, @"WLUnitField can not have more than 8 input units.");
        
        _inputMaxCount = count;
        _style = style;
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
    
    _itemAlignment = BMVerifyFieldAlignmentCenter;
    _squareBorder = YES;
    
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
    
    _secureStyle = BMVerifyFieldSecureStyle_Dot;
    //_secureImage = [UIImage imageNamed:@"navigationbar_help_icon"];
    //_secureSymbol = @"?";

    if (@available(iOS 12.0, *))
    {
        _textContentType = UITextContentTypeOneTimeCode;
    }
    else if (@available(iOS 10.0, *))
    {
        _textContentType = @"one-time-code";
    }

    [self.layer addSublayer:self.cursorLayer];
    [self setNeedsDisplay];
}


#pragma mark - Property

- (void)setFieldInputView:(UIView *)inputView
{
    self.inputView = inputView;
}

- (void)setFieldInputAccessoryView:(UIView *)inputAccessoryView
{
    self.inputAccessoryView = inputAccessoryView;
}

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

- (void)setText:(NSString *)text
{
    [self.characterArray removeAllObjects];
    
    [text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        if (self.characterArray.count < self.inputMaxCount)
        {
            [self.characterArray addObject:substring];
        }
        else
        {
            *stop = YES;
        }
    }];
    
    [self setNeedsDisplay];
    [self resetCursorLayerIfNeeded];

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
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry
{
    _secureTextEntry = secureTextEntry;
    
    [self setNeedsDisplay];
    [self resetCursorLayerIfNeeded];
}

- (void)setSecureStyle:(BMVerifyFieldSecureStyle)secureStyle
{
    _secureStyle = secureStyle;
    
    if (!self.secureTextEntry)
    {
        return;
    }
    
    [self setNeedsDisplay];
    [self resetCursorLayerIfNeeded];
}

- (void)setStyle:(BMVerifyFieldStyle)style
{
    _style = style;
    
    [self setNeedsDisplay];
    [self resetCursorLayerIfNeeded];
}

- (void)setItemAlignment:(BMVerifyFieldAlignment)itemAlignment
{
    _itemAlignment = itemAlignment;
    
    [self setNeedsDisplay];
    [self resetCursorLayerIfNeeded];
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

- (void)setSquareBorder:(BOOL)squareBorder
{
    _squareBorder = squareBorder;
    
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
    
    [self _resize];
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
    
    if (![self isFirstResponder])
    {
        [self becomeFirstResponder];
    }
}


#pragma mark - Override

- (CGSize)intrinsicContentSize
{
    CGSize size = self.bounds.size;
    size.width = MAX(size.width, DEFAULT_CONTENT_SIZE_WITH_UNIT_COUNT(self.inputMaxCount).width);
    CGFloat itemWidth = (size.width + self.itemSpace) / self.inputMaxCount - self.itemSpace;
    size.height = itemWidth;
    
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

- (void)_resize
{
    [self invalidateIntrinsicContentSize];
}

- (CGSize)getItemSize
{
    CGFloat width;
    CGFloat height;
    
    width = (self.bounds.size.width + self.itemSpace) / self.inputMaxCount - self.itemSpace;
    height = self.bounds.size.height;
    
    if (self.squareBorder)
    {
        CGFloat side = MIN(width, height);
        return CGSizeMake(side, side);
    }
    
    return CGSizeMake(width, height);
}

- (CGFloat)getStartXWithItemSize:(CGSize)itemSize
{
    CGFloat startX = 0;
    switch (self.itemAlignment)
    {
        case BMVerifyFieldAlignmentLeft:
            startX = self.itemSpace * 0.5;
            break;
            
        case BMVerifyFieldAlignmentCenter:
            startX = (self.bounds.size.width - self.inputMaxCount * (itemSize.width + self.itemSpace) + self.itemSpace) * 0.5;
            break;
            
        case BMVerifyFieldAlignmentRight:
            startX = self.bounds.size.width - self.inputMaxCount * (itemSize.width + self.itemSpace) + self.itemSpace * 0.5;
            break;
    }
    
    return startX;
}

- (void)resetCursorLayerIfNeeded
{
    self.cursorLayer.hidden = !self.isFirstResponder || self.cursorColor == nil || self.inputMaxCount == self.characterArray.count;
    
    if (self.cursorLayer.hidden)
    {
        return;
    }
    
    CGSize itemSize = [self getItemSize];
    CGFloat startX = [self getStartXWithItemSize:itemSize];
    //CGFloat startX = self.itemSpace * 0.5;//(self.bounds.size.width - self.inputMaxCount * (itemSize.width + self.itemSpace)) * 0.5;
    
    CGRect itemRect = CGRectMake(startX + self.characterArray.count * (itemSize.width + self.itemSpace),
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
    CGSize itemSize = [self getItemSize];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 已输入边框
    [self drawTrackBorder:ctx withRect:rect itemSize:itemSize];
    // 未输入边框
    [self drawBorder:ctx withRect:rect itemSize:itemSize];
    [self drawText:ctx withRect:rect itemSize:itemSize];
}

// 绘制边框
- (void)drawBorder:(CGContextRef)ctx withRect:(CGRect)rect itemSize:(CGSize)itemSize
{
    [self.borderColor setStroke];
    
    CGContextSetLineWidth(ctx, self.borderWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGRect bounds = CGRectInset(rect, self.borderWidth * 0.5, self.borderWidth * 0.5);
    
    CGFloat startX = [self getStartXWithItemSize:itemSize];
    //CGFloat startX = self.itemSpace * 0.5;//(self.bounds.size.width - self.inputMaxCount * (itemSize.width + self.itemSpace)) * 0.5;

    if (self.style == BMVerifyFieldStyle_Border)
    {
        if (self.itemSpace < 2)
        {
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:self.borderRadius];
            CGContextAddPath(ctx, bezierPath.CGPath);
            
            for (NSUInteger i = 1; i < self.inputMaxCount; ++i)
            {
                CGContextMoveToPoint(ctx, (startX + i * itemSize.width), 0);
                CGContextAddLineToPoint(ctx, (startX + i * itemSize.width), (itemSize.height));
            }
        }
        else
        {
            for (NSUInteger i = self.characterArray.count; i < self.inputMaxCount; i++)
            {
                CGRect itemRect = CGRectMake(startX + i * (itemSize.width + self.itemSpace),
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
    else
    {
        for (NSUInteger i = self.characterArray.count; i < self.inputMaxCount; i++)
        {
            CGRect unitLineRect = CGRectMake(startX + i * (itemSize.width + self.itemSpace),
                                             itemSize.height - self.borderWidth,
                                             itemSize.width,
                                             self.borderWidth);
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:unitLineRect cornerRadius:0];
            CGContextAddPath(ctx, bezierPath.CGPath);
        }
        
        CGContextDrawPath(ctx, kCGPathStroke);
    }
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
        CGFloat startX = [self getStartXWithItemSize:itemSize];

        CGRect itemRect = CGRectMake(startX + i * (itemSize.width + self.itemSpace),
                                     0,
                                     itemSize.width,
                                     itemSize.height);
        
        if (self.secureTextEntry == NO)
        {
            NSString *subString = [self.characterArray objectAtIndex:i];
            
            CGSize oneTextSize = [subString sizeWithAttributes:attr];
            CGRect drawRect = CGRectInset(itemRect,
                                          (itemRect.size.width - oneTextSize.width) * 0.5f,
                                          (itemRect.size.height - oneTextSize.height) * 0.5f);
            [subString drawInRect:drawRect withAttributes:attr];
        }
        else
        {
            BOOL showSecure = NO;
            if (self.secureStyle == BMVerifyFieldSecureStyle_Image)
            {
                if ([self.secureImage bm_isNotEmpty])
                {
                    CGSize imageSize = CGSizeMake(self.textFont.pointSize*2, self.textFont.pointSize*2);
                    UIImage *image = [self.secureImage bm_imageWithTintColor:self.textColor];
                    image = [image imageScaledToFitSize:imageSize];

                    CGSize secureImageSize = image.size;
                    CGRect drawRect = CGRectInset(itemRect,
                                                  (itemRect.size.width - secureImageSize.width) * 0.5f,
                                                  (itemRect.size.height - secureImageSize.height) * 0.5f);
                    [image drawInRect:drawRect];
                    showSecure = YES;
                }
            }
            else if (self.secureStyle == BMVerifyFieldSecureStyle_Symbol)
            {
                if ([self.secureSymbol bm_isNotEmpty])
                {
                    CGSize secureTextSize = [self.secureSymbol sizeWithAttributes:attr];
                    CGRect drawRect = CGRectInset(itemRect,
                                                  (itemRect.size.width - secureTextSize.width) * 0.5f,
                                                  (itemRect.size.height - secureTextSize.height) * 0.5f);
                    [self.secureSymbol drawInRect:drawRect withAttributes:attr];
                    showSecure = YES;
                }
            }
            
            if (!showSecure)
            {
                CGRect drawRect = CGRectInset(itemRect,
                                              (itemRect.size.width - self.textFont.pointSize * 0.5f) * 0.5f,
                                              (itemRect.size.height - self.textFont.pointSize * 0.5f) * 0.5f);
                [self.textColor setFill];
                CGContextAddEllipseInRect(ctx, drawRect);
                CGContextFillPath(ctx);
            }
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
    
    CGFloat startX = [self getStartXWithItemSize:itemSize];
    
    if (self.style == BMVerifyFieldStyle_Border)
    {
        for (NSUInteger i = 0; i < self.characterArray.count; i++)
        {
            CGRect itemRect = CGRectMake(startX + i * (itemSize.width + self.itemSpace),
                                         0,
                                         itemSize.width,
                                         itemSize.height);
            itemRect = CGRectInset(itemRect, self.borderWidth * 0.5, self.borderWidth * 0.5);
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:itemRect cornerRadius:self.borderRadius];
            CGContextAddPath(ctx, bezierPath.CGPath);
        }
    }
    else
    {
        for (NSUInteger i = 0; i < self.characterArray.count; i++)
        {
            CGRect unitLineRect = CGRectMake(startX + i * (itemSize.width + self.itemSpace),
                                             itemSize.height - self.borderWidth,
                                             itemSize.width,
                                             self.borderWidth);
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:unitLineRect cornerRadius:0];
            CGContextAddPath(ctx, bezierPath.CGPath);
        }
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
    
    if ([text isEqualToString:@" "])
    {
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

- (void)clear
{
    [self.characterArray removeAllObjects];

    [self setNeedsDisplay];
    [self resetCursorLayerIfNeeded];
}


// UITextInput implement.
#pragma mark - UITextInput

/* Methods for manipulating text. */
- (nullable NSString *)textInRange:(BMVerifyFieldTextRange *)range
{
    return nil;
}

- (void)replaceRange:(BMVerifyFieldTextRange *)range withText:(NSString *)text {}


// selectedRange is a range within the markedText
- (void)setMarkedText:(nullable NSString *)markedText selectedRange:(NSRange)selectedRange
{
    _markedText = [markedText copy];
}

- (void)unmarkText
{
    if (self.text.length >= self.inputMaxCount)
    {
        return;
    }
    
    if (_markedText == nil)
    {
        return;
    }
    
    [self insertText:_markedText];
}


/* The end and beginning of the the text document. */
- (UITextPosition *)beginningOfDocument
{
    return [BMVerifyFieldTextPosition positionWithOffset:0];
}

- (UITextPosition *)endOfDocument
{
    return [BMVerifyFieldTextPosition positionWithOffset:self.text.length - 1];
}


/* A tokenizer must be provided to inform the text input system about text units of varying granularity. */
- (id<UITextInputTokenizer>)tokenizer
{
    return [[UITextInputStringTokenizer alloc] initWithTextInput:self];
}


// Nil if no marked text.
- (UITextRange *)markedTextRange { return nil; }


/* Methods for creating ranges and positions. */
- (nullable UITextRange *)textRangeFromPosition:(BMVerifyFieldTextPosition *)fromPosition toPosition:(BMVerifyFieldTextPosition *)toPosition
{
    return [BMVerifyFieldTextRange rangeWithStart:fromPosition end:toPosition];
}

- (nullable UITextPosition *)positionFromPosition:(BMVerifyFieldTextPosition *)position offset:(NSInteger)offset
{
    return [BMVerifyFieldTextPosition positionWithOffset:position.offset + offset];
}

- (nullable UITextPosition *)positionFromPosition:(BMVerifyFieldTextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset
{
    return [BMVerifyFieldTextPosition positionWithOffset:position.offset + offset];
}


/* Simple evaluation of positions */
- (NSComparisonResult)comparePosition:(BMVerifyFieldTextPosition *)position toPosition:(BMVerifyFieldTextPosition *)other
{
    if (position.offset < other.offset) return NSOrderedAscending;
    if (position.offset > other.offset) return NSOrderedDescending;
    return NSOrderedSame;
}

- (NSInteger)offsetFromPosition:(BMVerifyFieldTextPosition *)from toPosition:(BMVerifyFieldTextPosition *)toPosition
{
    return toPosition.offset - from.offset;
}


/* Layout questions. */
- (nullable UITextPosition *)positionWithinRange:(UITextRange *)range farthestInDirection:(UITextLayoutDirection)direction { return nil; }
- (nullable UITextRange *)characterRangeByExtendingPosition:(BMVerifyFieldTextPosition *)position inDirection:(UITextLayoutDirection)direction { return nil; }


/* Writing direction */
- (UITextWritingDirection)baseWritingDirectionForPosition:(BMVerifyFieldTextPosition *)position inDirection:(UITextStorageDirection)direction { return UITextWritingDirectionNatural; }
- (void)setBaseWritingDirection:(UITextWritingDirection)writingDirection forRange:(UITextRange *)range {}


/* Geometry used to provide, for example, a correction rect. */
- (NSArray<UITextSelectionRect *> *)selectionRectsForRange:(BMVerifyFieldTextRange *)range { return nil; }
- (CGRect)firstRectForRange:(BMVerifyFieldTextRange *)range { return CGRectNull; }
- (CGRect)caretRectForPosition:(BMVerifyFieldTextPosition *)position { return CGRectNull; }


/* Hit testing. */
- (nullable UITextRange *)characterRangeAtPoint:(CGPoint)point { return nil; }
- (nullable UITextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(BMVerifyFieldTextRange *)range { return nil; }
- (nullable UITextPosition *)closestPositionToPoint:(CGPoint)point { return nil; }


@end
