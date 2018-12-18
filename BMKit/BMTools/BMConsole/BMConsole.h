//
//  BMConsole.h
//  fengshun
//
//  Created by jiang deng on 2018/11/23.
//  Copyright © 2018 FS. All rights reserved.
//

#if USE_TEST_HELP

#import <UIKit/UIKit.h>
#import "YYFPSLabel.h"
#import "BMTestColorPickerView.h"


#define ICONSOLE_ADD_EXCEPTION_HANDLER 1 //add automatic crash logging
#define ICONSOLE_USE_GOOGLE_STACK_TRACE 1 //use GTM functions to improve stack trace

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BMConsoleLogLevel)
{
    BMConsoleLogLevel_None = 0,
    BMConsoleLogLevel_Crash,
    BMConsoleLogLevel_Error,
    BMConsoleLogLevel_Warning,
    BMConsoleLogLevel_Info
};

@interface BMConsoleEnvironment : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *command;
@property (nullable, nonatomic, strong) id parameter;

- (instancetype)initWithTitle:(NSString *)title command:(NSString *)command;
- (instancetype)initWithTitle:(NSString *)title command:(NSString *)command parameter:(nullable id)parameter;

@end

#pragma mark -
#pragma mark BMConsole

@protocol BMConsoleDelegate;

@interface BMConsole : UIViewController

@property (nonatomic, weak) id <BMConsoleDelegate> delegate;

//enabled/disable console features
// 是否可用，默认：YES
@property (nonatomic, assign) BOOL enabled;
// 是否保存Log，默认：YES
@property (nonatomic, assign) BOOL saveLogToDisk;
// Log最大行数，默认：1000
@property (nonatomic, assign) NSUInteger maxLogItems;
@property (nonatomic, assign) BMConsoleLogLevel logLevel;

// console activation
// 模拟器打开console，触点个数，默认：2
@property (nonatomic, assign) NSUInteger simulatorTouchesToShow;
// 真机打开console，触点个数，默认：3
@property (nonatomic, assign) NSUInteger deviceTouchesToShow;
// 模拟器支持摇一摇打开console，默认：YES
@property (nonatomic, assign) BOOL simulatorShakeToShow;
// 真机支持摇一摇打开console，默认：YES
@property (nonatomic, assign) BOOL deviceShakeToShow;

// branding and feedback
// 说明文档
@property (nonatomic, copy) NSString *infoString;
// 输入提示
@property (nonatomic, copy) NSString *inputPlaceholderString;

// styling
// console背景色
@property (nonatomic, strong) UIColor *backgroundColor;
// 文本色
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) UIScrollViewIndicatorStyle indicatorStyle;

// email
@property (nonatomic, copy) NSString *logSubmissionEmail;

// 环境设置列表，命令组(on,dev,test)
@property (nonatomic, strong) NSMutableArray <BMConsoleEnvironment *> *environmentArray;

// 扩展命令button
@property (nonatomic, strong) NSMutableArray <BMConsoleEnvironment *> *commandArray;


// methods

+ (BMConsole *)sharedConsole;

+ (void)log:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+ (void)info:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+ (void)warn:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+ (void)error:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+ (void)crash:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

+ (void)log:(NSString *)format args:(va_list)argList;
+ (void)info:(NSString *)format args:(va_list)argList;
+ (void)warn:(NSString *)format args:(va_list)argList;
+ (void)error:(NSString *)format args:(va_list)argList;
+ (void)crash:(NSString *)format args:(va_list)argList;

+ (void)clean;
+ (void)clear;

+ (void)show;
+ (void)hide;

+ (void)showAlign;
+ (void)closeAlign;
+ (BOOL)isShowAlign;

+ (void)showColorPicker;
+ (void)closeColorPicker;
+ (BOOL)isShowColorPicker;

+ (BOOL)isMonitorNet;
+ (void)startMonitorNet;
+ (void)stopMonitorNet;

- (void)handleConsoleCommand:(NSString *)command;
- (void)handleConsoleCommand:(NSString *)command withParameter:(nullable id)parameter;

@end


#pragma mark -
#pragma mark BMConsoleDelegate

@protocol BMConsoleDelegate <NSObject>

// 命令行命令事件
- (BOOL)handleConsoleCommand:(NSString *)command;
// 按键事件
- (void)handleConsoleButton:(UIButton *)sender;

@optional
// 带参数的命令行命令事件
- (BOOL)handleConsoleCommand:(NSString *)command withParameter:(nullable id)parameter;

@end


#pragma mark -
#pragma mark BMConsoleWindow

@interface BMConsoleWindow : UIWindow

@property (nonatomic, strong, readonly) YYFPSLabel *fpsLabel;

@end

NS_ASSUME_NONNULL_END

#endif
