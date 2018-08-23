//
//  BMTableViewMaskTextCell.m
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2017/8/23.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "BMTableViewMaskTextCell.h"
#import "BMTableViewManager.h"
#import "BMMaskTextItem.h"

#import "NSString+BMFormat.h"


@interface BMTableViewMaskTextCell ()

/**
 *  The user defined `UITextFieldDelegate`.
 */
@property (nonatomic, strong) id<UITextFieldDelegate> _extension;

@property (nonatomic, strong) BMMaskTextItem *item;
@property (nonatomic, strong) NSRegularExpression *regex;

@end


@implementation BMTableViewMaskTextCell
@synthesize item = _item;

- (void)cellDidLoad
{
    [super cellDidLoad];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    
    if ([self.item.maskPattern bm_isNotEmpty])
    {
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.item.maskPattern
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        self.regex = regex;
    }

    [self formatTextFieldDidEndEditing:self.textField];
}

- (BOOL)formatTextFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 0)
    {
        textField.text = [textField.text bm_formatWithRegex:self.regex placeholder:self.item.maskPlaceholder errorContinue:NO];
    }
    
    return YES;
}


#pragma mark - UITextFieldDelegate

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
    NSString *mutableString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // source string
    NSString *clean = [mutableString bm_validCharactersWithRegex:self.regex errorContinue:NO];
    
    // mask string
    mutableString = [mutableString bm_formatWithRegex:self.regex placeholder:self.item.maskPlaceholder errorContinue:NO];
    
    NSRange newRange = NSMakeRange(0, 0);
    
    if (clean.length > 0)
    {
        newRange = [mutableString rangeOfString:[clean substringFromIndex:clean.length-1] options:NSBackwardsSearch];
        if (newRange.location == NSNotFound)
        {
            newRange.location = mutableString.length;
        }
        else
        {
            newRange.location += newRange.length;
        }
        
        newRange.length = 0;
    }
    
    textField.text = mutableString;
    [textField setValue:[NSValue valueWithRange:newRange] forKey:@"selectionRange"];
    
    return NO;
}

@end
