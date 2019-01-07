//
//  BMTableViewPickerCell.m
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2018/1/15.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "BMTableViewPickerCell.h"
#import "BMTableViewManager.h"
#import "BMPickerItem.h"

@interface BMTableViewPickerCell ()
<
    UITextFieldDelegate,
    UIPickerViewDataSource,
    UIPickerViewDelegate
>

@property (nonatomic, assign) BOOL enabled;

@property (nonatomic, strong) UITextField *hidenTextField;
@property (nonatomic, strong) UILabel *pickerTextLabel;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) BMPickerItem *item;

@end

@implementation BMTableViewPickerCell
@synthesize item = _item;

+ (BOOL)canFocusWithItem:(BMPickerItem *)item
{
    if (item.enabled)
    {
        return YES;
    }
    
    return NO;
}

- (void)dealloc
{
    if (_item != nil)
    {
        [_item removeObserver:self forKeyPath:@"enabled"];
    }
}

- (UIResponder *)responder
{
    return self.hidenTextField;
}

- (void)cellDidLoad
{
    [super cellDidLoad];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.hidenTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.hidenTextField.inputAccessoryView = self.actionBar;
    self.hidenTextField.delegate = self;
    [self addSubview:self.hidenTextField];
    
    self.pickerTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.pickerTextLabel.backgroundColor = [UIColor clearColor];
    self.pickerTextLabel.textAlignment = NSTextAlignmentRight;
    //self.pickerTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [self.contentView addSubview:self.pickerTextLabel];
    
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    self.placeholderLabel.textAlignment = NSTextAlignmentRight;
    self.placeholderLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.placeholderLabel];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.hidenTextField.inputView = self.pickerView;
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.pickerTextLabel.textColor = self.item.pickerValueColor;
    self.pickerTextLabel.font = self.item.pickerValueFont;
    self.pickerTextLabel.textAlignment = self.item.pickerTextAlignment;

    self.placeholderLabel.textColor = self.item.pickerPlaceholderColor;
    self.placeholderLabel.font = self.item.pickerValueFont;
    self.placeholderLabel.textAlignment = self.item.pickerTextAlignment;

    [self showPickerText];

    self.enabled = self.item.enabled;
    
    for (NSUInteger component = 0; component < self.item.pickerSelectedRowInComponent.count; component++)
    {
        NSNumber *row = self.item.pickerSelectedRowInComponent[component];
        [self.pickerView selectRow:row.integerValue inComponent:component animated:NO];
    }
}

- (void)layoutDetailView:(UIView *)view minimumWidth:(CGFloat)minimumWidth
{
    [super layoutDetailView:view minimumWidth:minimumWidth];
    
    self.placeholderLabel.frame = view.frame;
}

- (void)cellLayoutSubviews
{
    [super cellLayoutSubviews];
    
    [self layoutDetailView:self.pickerTextLabel minimumWidth:0];
}

- (void)setItem:(BMPickerItem *)item
{
    if (_item != nil)
    {
        [_item removeObserver:self forKeyPath:@"enabled"];
    }
    
    _item = item;
    
    [_item addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    self.userInteractionEnabled = _enabled;
    
    self.textLabel.enabled = _enabled;
    self.pickerTextLabel.enabled = _enabled;
    self.placeholderLabel.enabled = _enabled;
    self.pickerView.userInteractionEnabled = _enabled;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[BMPickerItem class]] && [keyPath isEqualToString:@"enabled"])
    {
        BOOL newValue = [[change objectForKey: NSKeyValueChangeNewKey] boolValue];
        
        self.enabled = newValue;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected)
    {
        [self.hidenTextField becomeFirstResponder];
    }
}

- (void)shouldUpdatePickerText
{
    NSMutableArray *values = [NSMutableArray array];
    NSMutableArray *selectedRowInComponent = [NSMutableArray array];
    [self.item.components enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray *componentList = self.item.components[idx];
        NSString *valueText = [componentList objectAtIndex:[self.pickerView selectedRowInComponent:idx]];
        [values addObject:valueText];
        [selectedRowInComponent addObject:@([self.pickerView selectedRowInComponent:idx])];
    }];
    self.item.values = [values copy];
    self.item.pickerSelectedRowInComponent = [selectedRowInComponent copy];

    [self showPickerText];
}

- (void)showPickerText
{
    if ([self.item.values bm_isNotEmpty])
    {
        if (self.item.formatPickerText)
        {
            self.pickerTextLabel.text = self.item.formatPickerText(self.item);
        }
        else
        {
            self.pickerTextLabel.text = self.item.values ? [self.item.values componentsJoinedByString:@""] : @"";
        }
    }
    else
    {
        self.pickerTextLabel.text = self.item.defaultPickerText;
    }
    self.placeholderLabel.text = self.item.placeholder;
    self.placeholderLabel.hidden = [self.pickerTextLabel.text bm_isNotEmpty];
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSIndexPath *indexPath = [self indexPathForNextResponder];
    if (indexPath)
    {
        textField.returnKeyType = UIReturnKeyNext;
    }
    else
    {
        textField.returnKeyType = UIReturnKeyDefault;
    }
    [self updateActionBarNavigationControl];
    [self.parentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.rowIndex inSection:self.sectionIndex] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self shouldUpdatePickerText];

    return YES;
}


#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.item.components.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.item.components[component] count];
}


#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *items = self.item.components[component];
    return items[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [pickerView reloadAllComponents];
    
    [self shouldUpdatePickerText];
    
    if (self.item.onChange)
    {
        self.item.onChange(self.item);
    }
}

@end
