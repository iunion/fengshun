//
//  BMInputItem.h
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2018/4/20.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "BMTableViewItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMInputItem : BMTableViewItem

// Data and values
//
@property (nullable, nonatomic, copy) NSString *value;
@property (nullable, nonatomic, copy) NSString *placeholder;

@property (nonatomic, assign) BOOL editable;

// default is NO
@property (nonatomic, assign) BOOL hideInputView;

// Keyboard
//
// default is UITextAutocapitalizationTypeSentences
@property (nonatomic, assign) UITextAutocapitalizationType autocapitalizationType;
// default is UITextAutocorrectionTypeDefault
@property (nonatomic, assign) UITextAutocorrectionType autocorrectionType;
// default is UITextSpellCheckingTypeDefault;
@property (nonatomic, assign) UITextSpellCheckingType spellCheckingType NS_AVAILABLE_IOS(5_0);
// default is UIKeyboardTypeDefault
@property (nonatomic, assign) UIKeyboardType keyboardType;
// default is UIKeyboardAppearanceDefault
@property (nonatomic, assign) UIKeyboardAppearance keyboardAppearance;
// default is UIReturnKeyDefault (See note under UIReturnKeyType enum)
@property (nonatomic, assign) UIReturnKeyType returnKeyType;
// default is NO (when YES, will automatically disable return key when text widget has zero-length contents, and will automatically enable when text widget has non-zero-length contents)
@property (nonatomic, assign) BOOL enablesReturnKeyAutomatically;
// default is NO
@property (nonatomic, assign) BOOL secureTextEntry;

@property (nullable, nonatomic, strong) UIView *inputView;

// 输入字符数限制 0: 不限制
@property (nonatomic, assign) NSUInteger charactersLimit;

@property (nullable, nonatomic, copy) void (^onBeginEditing)(BMInputItem *item);
@property (nullable, nonatomic, copy) void (^onEndEditing)(BMInputItem *item);
@property (nullable, nonatomic, copy) void (^onChange)(BMInputItem *item);
@property (nullable, nonatomic, copy) void (^onReturn)(BMInputItem *item);
@property (nullable, nonatomic, copy) BOOL (^onChangeCharacterInRange)(BMInputItem *item, NSRange range, NSString *replacementString);


+ (instancetype)itemWithTitle:(nullable NSString *)title value:(nullable NSString *)value;
+ (instancetype)itemWithTitle:(nullable NSString *)title value:(nullable NSString *)value  placeholder:(nullable NSString *)placeholder;
- (instancetype)initWithTitle:(nullable NSString *)title value:(nullable NSString *)value;
- (instancetype)initWithTitle:(nullable NSString *)title value:(nullable NSString *)value placeholder:(nullable NSString *)placeholder;

@end

NS_ASSUME_NONNULL_END

