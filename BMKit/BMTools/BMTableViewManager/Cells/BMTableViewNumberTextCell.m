//
//  BMTableViewNumberTextCell.m
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2017/8/23.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "BMTableViewNumberTextCell.h"
#import "BMNumberTextItem.h"


@interface BMTableViewNumberTextCell ()
{
    NSString *numberPattern;
}

@property (nonatomic, strong) BMNumberTextItem *item;

@end

@implementation BMTableViewNumberTextCell
@synthesize item = _item;

- (void)cellDidLoad
{
    [super cellDidLoad];
    
    numberPattern = [NSString stringWithFormat:@"^\\.\\d{0,%@}|^0\\.\\d{0,%@}|^\\d{1,%@}\\.\\d{0,%@}|^\\d{0,%@}", @(BMNumberText_MaxDecimalPlaces), @(BMNumberText_MaxDecimalPlaces), @(BMNumberText_MaxNumberDigits), @(BMNumberText_MaxDecimalPlaces), @(BMNumberText_MaxNumberDigits)];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    
    [self formatTextFieldDidEndEditing:self.textField];
}

- (BOOL)formatTextFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 0)
    {
        NSDecimalNumber *num = [[NSDecimalNumber alloc] initWithString:textField.text];
        
        // 比较大小
        if (self.item.minNumberValue)
        {
            if ([num compare:self.item.minNumberValue] == NSOrderedAscending)
            {
                num = self.item.minNumberValue;
            }
        }
        if (self.item.maxNumberValue)
        {
            if ([num compare:self.item.maxNumberValue] == NSOrderedDescending)
            {
                num = self.item.maxNumberValue;
            }
        }
        
        if ([num compare:[NSDecimalNumber zero]] != NSOrderedAscending)
        {
            if (self.item.showWithDecimalStyle)
            {
                textField.text = [num bm_stringWithNormalDecimalStyle];
            }
            else
            {
                textField.text = [num bm_stringWithNoStyleDecimalScale:BMNumberText_MaxDecimalPlaces];
            }
        }
        else
        {
            textField.text = @"0.00";
        }
    }
    
    return YES;
}

#pragma mark -
#pragma mark Text field events

- (void)textFieldDidChanged:(UITextField *)textField
{
    [super textFieldDidChanged:textField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([super textFieldShouldBeginEditing:textField])
    {
        NSString *text = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
        textField.text = text;
        return YES;
    }
    
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([super textFieldShouldEndEditing:textField])
    {
        return [self formatTextFieldDidEndEditing:textField];
    }
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL shouldChange = YES;
    
    NSString *text = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    text = [text stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSString *newStringBack = [textField.text stringByReplacingCharactersInRange:range withString:text];
    if ([newStringBack bm_isNotEmpty])
    {
        NSString *newString = [newStringBack copy];
        // 删除起始无用的0
        NSRange zeroRang = [newString bm_rangOfFirstMatchWithPattern:@"^0+"];
        if (zeroRang.location != NSNotFound)
        {
            NSString *replaceString = @"";
            if ([newString bm_isMatchWithPattern:@"^0+$"] || [newString bm_isMatchWithPattern:@"^0+."])
            {
                replaceString = @"0";
            }
            newString = [newString stringByReplacingCharactersInRange:zeroRang withString:replaceString];
        }
        
        // 校验格式XXX.XX
        // ^\d{1,7}\.\d{0,2}|^\d{0,7}|^0\.\d{0,2}|^\.\d{0,2}
        //NSString *pattern = @"^\\d{0,7}|^\\.\\d{0,2}|^0\\.\\d{0,2}|^\\d{1,7}\\.\\d{0,2}";
        NSString *matchStr = [newString bm_firstMatchWithPattern:numberPattern];
        if (matchStr)
        {
            if ([matchStr hasPrefix:@"."])
            {
                matchStr = [NSString stringWithFormat:@"0%@", matchStr];
            }
            
            if (![matchStr isEqualToString:newStringBack])
            {
                textField.text = matchStr;
                shouldChange = NO;
            }
        }
        else
        {
            shouldChange = NO;
        }
    }
    
    if (shouldChange)
    {
        if (self.item.charactersLimit)
        {
            NSUInteger newLength = textField.text.length + string.length - range.length;
            shouldChange = newLength <= self.item.charactersLimit;
        }
        
        if (self.item.onChangeCharacterInRange && shouldChange)
        {
            shouldChange = self.item.onChangeCharacterInRange(self.item, range, string);
        }
        
//        shouldChange = [super textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return shouldChange;
}

@end
