//
//  ORDTextView.h
//  ODR
//
//  Created by lavine on 2017/9/13.
//  Copyright © 2017年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
@class ORDTextView;

typedef void(^ORDTextViewHandler)(ORDTextView *textView);

IB_DESIGNABLE

@interface ORDTextView : UITextView

/*! @brief 便利构造器创建FSTextView实例.
 */
+ (instancetype)textView;

/*! @brief 设定文本改变Block回调. (切记弱化引用, 以免造成内存泄露.)
 */
- (void)addTextDidChangeHandler:(ORDTextViewHandler)eventHandler;

/*! @brief 设定达到最大长度Block回调. (切记弱化引用, 以免造成内存泄露.)
 */
- (void)addTextLengthDidMaxHandler:(ORDTextViewHandler)maxHandler;

@property (nonatomic, assign) IBInspectable NSUInteger maxLength; ///< 最大限制文本长度, 默认为无穷大(即不限制).

@property (nonatomic, assign) IBInspectable CGFloat   cornerRadius; ///< 圆角半径.
@property (nonatomic, assign) IBInspectable CGFloat   borderWidth; ///< 边框宽度.
@property (nonatomic, strong) IBInspectable UIColor  *borderColor; ///< 边框颜色.

@property (nonatomic, copy)   IBInspectable NSString *placeholder; ///< placeholder, 会自适应TextView宽高以及横竖屏切换, 字体默认和TextView一致.
@property (nonatomic, strong) IBInspectable UIColor  *placeholderColor; ///< placeholder文本颜色, 默认为#C7C7CD.
@property (nonatomic, strong) UIFont *placeholderFont; ///< placeholder文本字体, 默认为UITextView的默认字体.

/// 是否允许长按弹出UIMenuController, 默认为YES.
@property (nonatomic, assign, getter=isCanPerformAction) BOOL canPerformAction;

/// 该属性返回一个经过处理的 `self.text` 的值, 去除了首位的空格和换行.
@property (nonatomic, readonly) NSString *formatText;

@end

