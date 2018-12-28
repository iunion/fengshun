//
//  BMConsole.m
//  fengshun
//
//  Created by jiang deng on 2018/11/23.
//  Copyright © 2018 FS. All rights reserved.
//

#import "BMConsole.h"
#include <asl.h>
#import "NSString+BMURLEncode.h"

#if ICONSOLE_USE_GOOGLE_STACK_TRACE
#import "GTMStackTrace.h"
#endif

#import "FLEX.h"

#import "BMTestAlignManager.h"
#import "BMTestColorPickerManager.h"
#import "BMCheckBoxLabel.h"

#import "BMTestGPSMockVC.h"
#import "BMTestAppInfoVC.h"

#import "BMTestNetFlowManager.h"
#import "BMTestNetFlowSummaryVC.h"


#define TOOLBAR_GAP 5.0f

#define EDITFIELD_HEIGHT 30.0f
#define ENVIRONMENT_BUTTON_WIDTH 60.0f
#define ACTION_BUTTON_WIDTH 30.0f

#define TOOL_BUTTON_WIDTH 50.0f
#define TOOL_BUTTON_HEIGHT EDITFIELD_HEIGHT

#define TOOLBAR_HEIGHT (EDITFIELD_HEIGHT+TOOL_BUTTON_HEIGHT+TOOLBAR_GAP*3)

@interface BMConsole ()
<
    UITextFieldDelegate,
    UIScrollViewDelegate
>
{
    BOOL animating;
}

@property (nonatomic, strong) NSMutableArray *log;

@property (nonatomic, strong) UITextView *consoleView;

@property (nonatomic, strong) UIView *toolBar;

@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, strong) UIButton *showEnvironmentButton;
@property (nonatomic, strong) UIView *environmentBgView;
@property (nonatomic, strong) UIView *environmentToolBar;
@property (nonatomic, strong) UIScrollView *environmentScrollView;

@property (nonatomic, strong) UIButton *FLEXButton;
@property (nonatomic, strong) UIButton *colorSetButton;

@property (nonatomic, strong) UIView *colorSetView;
@property (nonatomic, assign) BOOL colorSwicth;

@end


#pragma mark -
#pragma mark BMConsoleEnvironment

@implementation BMConsoleEnvironment

- (instancetype)initWithTitle:(NSString *)title command:(NSString *)command
{
    return [self initWithTitle:title command:command parameter:nil];
}

- (instancetype)initWithTitle:(NSString *)title command:(NSString *)command parameter:(id)parameter
{
    if (self = [super init])
    {
        self.title = title;
        self.command = command;
        self.parameter = parameter;
    }
    
    return self;
}

@end


#pragma mark -
#pragma mark BMConsole

@implementation BMConsole

static void exceptionHandler(NSException *exception)
{
    
#if ICONSOLE_USE_GOOGLE_STACK_TRACE
    
    extern NSString *GTMStackTraceFromException(NSException *e);
    [BMConsole crash:@"%@\n\nStack trace:\n%@)", exception, GTMStackTraceFromException(exception)];
    
#else
    
    [BMConsole crash:@"%@", exception];
    
#endif
    
    [[BMConsole sharedConsole] saveSettings];
}

- (void)dealloc
{
    
}

- (UIWindow *)mainWindow
{
    UIWindow *window = nil;
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        window = [app.delegate window];
    }
    else
    {
        window = [app keyWindow];
    }
    
    return window;
}

+ (BMConsole *)sharedConsole
{
    static BMConsole *sharedConsole = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedConsole = [[[self class] alloc] init];
    });
    
    return sharedConsole;
}

- (instancetype)init
{
    if (self = [super init])
    {
        
#if ICONSOLE_ADD_EXCEPTION_HANDLER
        
        NSSetUncaughtExceptionHandler(&exceptionHandler);
        
#endif
        
        self.enabled = YES;
        self.logLevel = BMConsoleLogLevel_Info;
        self.saveLogToDisk = YES;
        self.maxLogItems = 1000;
        self.delegate = nil;
        
        self.simulatorTouchesToShow = 2;
        self.deviceTouchesToShow = 3;
        self.simulatorShakeToShow = YES;
        self.deviceShakeToShow = YES;
        
        self.infoString = @"枫调理顺 APP测试控制平台：";
        self.inputPlaceholderString = @"输入命令...";
        self.logSubmissionEmail = @"";
        
        self.backgroundColor = [UIColor blackColor];
        self.textColor = [UIColor whiteColor];
        self.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.log = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"bmConsoleLog"]];
        
        if (UIApplicationDidEnterBackgroundNotification != nil)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(saveSettings)
                                                         name:UIApplicationDidEnterBackgroundNotification
                                                       object:nil];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(saveSettings)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(rotateView:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resizeView:)
                                                     name:UIApplicationWillChangeStatusBarFrameNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor bm_colorWithHex:0x999999 alpha:1];

    self.consoleView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-TOOLBAR_HEIGHT)];
    self.consoleView.font = [UIFont fontWithName:@"Courier" size:12];
    self.consoleView.textColor = [UIColor whiteColor];
    self.consoleView.backgroundColor = [UIColor blackColor];
    self.consoleView.indicatorStyle = self.indicatorStyle;
    self.consoleView.editable = NO;
    self.consoleView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.consoleView];

    [self setConsoleText];
    
    [self makeToolBar];
}

- (void)makeToolBar
{
    self.toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-TOOLBAR_HEIGHT, self.view.bounds.size.width, TOOLBAR_HEIGHT)];
    self.toolBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.toolBar];

    self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(TOOLBAR_GAP, TOOLBAR_GAP,
                                                                self.toolBar.bm_width - ACTION_BUTTON_WIDTH - ENVIRONMENT_BUTTON_WIDTH - TOOLBAR_GAP*4,
                                                                EDITFIELD_HEIGHT)];
    self.inputField.borderStyle = UITextBorderStyleRoundedRect;
    self.inputField.font = [UIFont fontWithName:@"Courier" size:12];
    self.inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.inputField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.inputField.returnKeyType = UIReturnKeyDone;
    self.inputField.enablesReturnKeyAutomatically = NO;
    self.inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.inputField.placeholder = self.inputPlaceholderString;
    self.inputField.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.inputField.delegate = self;
    [self.toolBar addSubview:self.inputField];

    self.showEnvironmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.showEnvironmentButton.exclusiveTouch = YES;
    [self.showEnvironmentButton setTitle:@"环境设置" forState:UIControlStateNormal];
    [self.showEnvironmentButton setTitleColor:self.textColor forState:UIControlStateNormal];
    [self.showEnvironmentButton setTitleColor:[self.textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    self.showEnvironmentButton.backgroundColor = [UIColor bm_colorWithHex:0x666666];
    self.showEnvironmentButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.showEnvironmentButton.frame = CGRectMake(self.inputField.bm_right + TOOLBAR_GAP,
                                             TOOLBAR_GAP,
                                             ENVIRONMENT_BUTTON_WIDTH, TOOL_BUTTON_HEIGHT);
    [self.showEnvironmentButton addTarget:self action:@selector(showEnvironmentAction:) forControlEvents:UIControlEventTouchUpInside];
    self.showEnvironmentButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.showEnvironmentButton bm_roundedRect:3.0f];
    [self.toolBar addSubview:self.showEnvironmentButton];

    self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.actionButton.exclusiveTouch = YES;
    [self.actionButton setTitle:@"⚙" forState:UIControlStateNormal];
    [self.actionButton setTitleColor:self.textColor forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[self.textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    self.actionButton.backgroundColor = [UIColor clearColor];
    self.actionButton.titleLabel.font = [self.actionButton.titleLabel.font fontWithSize:ACTION_BUTTON_WIDTH];
    self.actionButton.frame = CGRectMake(self.showEnvironmentButton.bm_right + TOOLBAR_GAP,
                                     TOOLBAR_GAP,
                                     ACTION_BUTTON_WIDTH, TOOL_BUTTON_HEIGHT);
    [self.actionButton addTarget:self action:@selector(infoAction) forControlEvents:UIControlEventTouchUpInside];
    self.actionButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.toolBar addSubview:self.actionButton];
    
    self.FLEXButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.FLEXButton.exclusiveTouch = YES;
    [self.FLEXButton setTitle:@"FLEX" forState:UIControlStateNormal];
    [self.FLEXButton setTitleColor:self.textColor forState:UIControlStateNormal];
    [self.FLEXButton setTitleColor:[self.textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    self.FLEXButton.backgroundColor = [UIColor bm_colorWithHex:0x666666];
    self.FLEXButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.FLEXButton.frame = CGRectMake(self.toolBar.bm_width-(TOOL_BUTTON_WIDTH+TOOLBAR_GAP)*2,
                                       self.inputField.bm_height+TOOLBAR_GAP*2,
                                       TOOL_BUTTON_WIDTH, TOOL_BUTTON_HEIGHT);
    [self.FLEXButton addTarget:self action:@selector(FLEXAction:) forControlEvents:UIControlEventTouchUpInside];
    self.FLEXButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.FLEXButton bm_roundedRect:3.0f];
    [self.toolBar addSubview:self.FLEXButton];
    
    self.colorSetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.colorSetButton.exclusiveTouch = YES;
    [self.colorSetButton setTitle:@"视觉" forState:UIControlStateNormal];
    [self.colorSetButton setTitleColor:self.textColor forState:UIControlStateNormal];
    [self.colorSetButton setTitleColor:[self.textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    self.colorSetButton.backgroundColor = [UIColor bm_colorWithHex:0x666666];
    self.colorSetButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.colorSetButton.frame = CGRectMake(self.toolBar.bm_width-TOOL_BUTTON_WIDTH-TOOLBAR_GAP,
                                       self.inputField.bm_height+TOOLBAR_GAP*2,
                                       TOOL_BUTTON_WIDTH, TOOL_BUTTON_HEIGHT);
    [self.colorSetButton addTarget:self action:@selector(colorSetAction:) forControlEvents:UIControlEventTouchUpInside];
    self.colorSetButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.colorSetButton bm_roundedRect:3.0f];
    [self.toolBar addSubview:self.colorSetButton];
    
    [self makeAdditionBtn];
}

- (void)makeAdditionBtn
{
    if (!self.commandArray)
    {
        self.commandArray = [[NSMutableArray alloc] initWithCapacity:4];
        [self.commandArray addObject:[[BMConsoleEnvironment alloc] initWithTitle:@"当前" command:@"api"]];
        [self.commandArray addObject:[[BMConsoleEnvironment alloc] initWithTitle:@"线上" command:@"on"]];
        [self.commandArray addObject:[[BMConsoleEnvironment alloc] initWithTitle:@"开发" command:@"dev"]];
        [self.commandArray addObject:[[BMConsoleEnvironment alloc] initWithTitle:@"测试" command:@"test"]];
        [self.commandArray addObject:[[BMConsoleEnvironment alloc] initWithTitle:@"GPS" command:@"gps"]];
    }

    for (NSInteger i=0; i<6 && i<self.commandArray.count; i++)
    {
        BMConsoleEnvironment *environment = self.commandArray[i];
        
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.exclusiveTouch = YES;
        itemButton.frame = CGRectMake(TOOLBAR_GAP+(i%6)*(TOOL_BUTTON_WIDTH+TOOLBAR_GAP), self.inputField.bm_height+TOOLBAR_GAP*2 , TOOL_BUTTON_WIDTH, TOOL_BUTTON_HEIGHT);
        
        [itemButton setTitle:environment.title forState:UIControlStateNormal];
        [itemButton setTitleColor:self.textColor forState:UIControlStateNormal];
        [itemButton setTitleColor:[self.textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
        itemButton.backgroundColor = [UIColor bm_colorWithHex:0x666666];
        itemButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        itemButton.tag = i;
        itemButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        [itemButton addTarget:self action:@selector(commandItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [itemButton bm_roundedRect:3.0f];
        [self.toolBar addSubview:itemButton];
    }
}

- (void)commandItemAction:(UIButton *)sender
{
    NSInteger index = sender.tag;
    
    BMConsoleEnvironment *environment = self.commandArray[index];
    
    [self handleConsoleCommand:environment.command withParameter:environment.parameter];
    
    [self environmentCloseAction:sender];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.delegate)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark -
#pragma mark NSNotification

- (void)rotateView:(NSNotification *)notification
{
    self.view.transform = [self viewTransform];
    self.view.frame = [self onscreenFrame];
    
    if (self.delegate != nil)
    {
        //workaround for autoresizeing glitch
        CGRect frame = self.view.bounds;
        frame.size.height -= EDITFIELD_HEIGHT + 10;
        self.consoleView.frame = frame;
    }
}

- (void)resizeView:(NSNotification *)notification
{
    CGRect frame = [[notification.userInfo valueForKey:UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
    CGRect bounds = [UIScreen mainScreen].bounds;
    switch ([UIApplication sharedApplication].statusBarOrientation)
    {
        case UIInterfaceOrientationPortrait:
#ifdef __IPHONE_8_0
        case UIInterfaceOrientationUnknown:
#endif
            bounds.origin.y += frame.size.height;
            bounds.size.height -= frame.size.height;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            bounds.size.height -= frame.size.height;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            bounds.origin.x += frame.size.width;
            bounds.size.width -= frame.size.width;
            break;
        case UIInterfaceOrientationLandscapeRight:
            bounds.size.width -= frame.size.width;
            break;
        default:
            NSLog(@"Unexpected case - will do nothing here");
            break;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.35];
    self.view.frame = bounds;
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect frame = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    
    CGRect bounds = [self onscreenFrame];
    switch ([UIApplication sharedApplication].statusBarOrientation)
    {
        case UIInterfaceOrientationPortrait:
#ifdef __IPHONE_8_0
        case UIInterfaceOrientationUnknown:
#endif
            bounds.size.height -= frame.size.height;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            bounds.origin.y += frame.size.height;
            bounds.size.height -= frame.size.height;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            bounds.size.width -= frame.size.width;
            break;
        case UIInterfaceOrientationLandscapeRight:
            bounds.origin.x += frame.size.width;
            bounds.size.width -= frame.size.width;
            break;
        default:
            NSLog(@"Unexpected case - will do nothing here");
            break;
    }
    self.view.frame = bounds;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGFloat duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    
    self.view.frame = [self onscreenFrame];
    if (self.colorSetView != nil)
    {
        self.colorSetView.bm_top =  [self onscreenFrame].size.height - (EDITFIELD_HEIGHT + 10 + TOOL_BUTTON_HEIGHT);
    }
    [UIView commitAnimations];
}


#pragma mark -
#pragma mark frame

- (CGAffineTransform)viewTransform
{
    CGFloat angle = 0;
    switch ([UIApplication sharedApplication].statusBarOrientation)
    {
        case UIInterfaceOrientationPortrait:
#ifdef __IPHONE_8_0
        case UIInterfaceOrientationUnknown:
#endif
            angle = 0;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = -M_PI_2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = M_PI_2;
            break;
        default:
            NSLog(@"Unexpected case - will do nothing here");
            break;
    }
    return CGAffineTransformMakeRotation(angle);
}

- (CGRect)onscreenFrame
{
    return [UIScreen mainScreen].bounds;
}

- (CGRect)offscreenFrame
{
    CGRect frame = [self onscreenFrame];
    switch ([UIApplication sharedApplication].statusBarOrientation)
    {
        case UIInterfaceOrientationPortrait:
#ifdef __IPHONE_8_0
        case UIInterfaceOrientationUnknown:
#endif
            frame.origin.y = frame.size.height;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            frame.origin.y = -frame.size.height;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            frame.origin.x = frame.size.width;
            break;
        case UIInterfaceOrientationLandscapeRight:
            frame.origin.x = -frame.size.width;
            break;
        default:
            NSLog(@"Unexpected case - will do nothing here");
            break;
    }
    return frame;
}


#pragma mark -
#pragma mark actions

- (void)showEnvironmentAction:(id)sender
{
    [self.inputField resignFirstResponder];
    
    if (!self.environmentBgView)
    {
        self.environmentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 300)];
        self.environmentBgView.backgroundColor = [UIColor bm_colorWithHex:0x333333];
        [self.view addSubview:self.environmentBgView];

        self.environmentToolBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.environmentBgView.bm_width, 30)];
        self.environmentToolBar.backgroundColor = [UIColor bm_colorWithHex:0x666666];
        [self.environmentBgView addSubview:self.environmentToolBar];

        self.environmentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, UI_SCREEN_WIDTH, 270)];
        self.environmentScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, 1);
        self.environmentScrollView.delegate = self;
        self.environmentScrollView.showsVerticalScrollIndicator = NO;
        [self.environmentBgView addSubview:self.environmentScrollView];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.exclusiveTouch = YES;
        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [closeButton setTitleColor:self.textColor forState:UIControlStateNormal];
        [closeButton setTitleColor:[self.textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
        closeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        closeButton.frame = CGRectMake(self.environmentToolBar.bm_width-40, 0, 40, 30);
        [closeButton addTarget:self action:@selector(environmentCloseAction:) forControlEvents:UIControlEventTouchUpInside];
        closeButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self.environmentToolBar addSubview:closeButton];
    }
    
    if (!self.environmentArray)
    {
        self.environmentArray = [[NSMutableArray alloc] initWithCapacity:3];
        [self.environmentArray addObject:[[BMConsoleEnvironment alloc] initWithTitle:@"线上" command:@"on"]];
        [self.environmentArray addObject:[[BMConsoleEnvironment alloc] initWithTitle:@"开发" command:@"dev"]];
        [self.environmentArray addObject:[[BMConsoleEnvironment alloc] initWithTitle:@"测试" command:@"test"]];
    }
    
    for (NSInteger i=0; i<self.environmentArray.count; i++)
    {
        BMConsoleEnvironment *environment = self.environmentArray[i];
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.exclusiveTouch = YES;
        itemButton.frame = CGRectMake(15+(i%3)*100, 10+(i/3)*36 , 90, 24);
        itemButton.backgroundColor = [UIColor blackColor];

        [itemButton setTitleColor:[UIColor bm_colorWithHex:0x666666] forState:UIControlStateHighlighted];
        [itemButton setTitle:environment.title forState:UIControlStateNormal];
        itemButton.titleLabel.font = [UIFont systemFontOfSize:12];
        itemButton.tag = i;
        [itemButton addTarget:self action:@selector(environmentItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.environmentScrollView addSubview:itemButton];
    }
    
    NSInteger k = self.environmentArray.count % 3 ? 1 : 0;
    CGFloat contentHeight = (self.environmentArray.count/3+k)*36+10;
    
    // fps设置
    UILabel *label = [UILabel bm_labelWithFrame:CGRectMake(10.0f, contentHeight+6.0f, 200.0f, 30.0f) text:@"FPS监测" fontSize:14.0f color:[UIColor whiteColor] alignment:NSTextAlignmentLeft lines:1];
    [self.environmentScrollView addSubview:label];

    UISwitch *switchView = [[UISwitch alloc] init];
    switchView.exclusiveTouch = YES;
    [switchView addTarget:self action:@selector(fpsSwitchValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.environmentScrollView addSubview:switchView];
    switchView.bm_top = contentHeight + 6.0f;
    switchView.bm_left = label.bm_right+10.0f;
    switchView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    YYFPSLabel *fpsLabel = nil;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if ([window isKindOfClass:[BMConsoleWindow class]])
    {
        BMConsoleWindow *consoleWindow = (BMConsoleWindow *)window;
        fpsLabel = consoleWindow.fpsLabel;
        [fpsLabel bm_bringToFront];
        switchView.on = !fpsLabel.hidden;
    }
    
    // CPU
    BMCheckBoxLabel *checkBoxLabel1 = [[BMCheckBoxLabel alloc] initWithFrame:CGRectMake(15.0f, label.bm_bottom, 100, 30) checkWidth:0 labelText:@"监测CPU" useGesture:NO];
    checkBoxLabel1.labelTextCheckedColor = [UIColor whiteColor];
    checkBoxLabel1.labelTextUnCheckedColor = [UIColor whiteColor];
    checkBoxLabel1.boxUnCheckedStrokeColor = [UIColor lightGrayColor];
    checkBoxLabel1.boxCheckedStrokeColor = [UIColor whiteColor];
    checkBoxLabel1.markCheckedStrokeColor = [UIColor whiteColor];
    checkBoxLabel1.verticallyType = BMCheckBoxVerticallyType_Center;
    checkBoxLabel1.tag = 1;
    [checkBoxLabel1 addTarget:self action:@selector(fpsTypeValueDidChange:) forControlEvents:UIControlEventValueChanged];
    checkBoxLabel1.enabled = NO;
    [self.environmentScrollView addSubview:checkBoxLabel1];
    
    // Mem
    BMCheckBoxLabel *checkBoxLabel2 = [[BMCheckBoxLabel alloc] initWithFrame:CGRectMake(125.0f, label.bm_bottom, 100, 30) checkWidth:0 labelText:@"监测内存" useGesture:NO];
    checkBoxLabel2.labelTextCheckedColor = [UIColor whiteColor];
    checkBoxLabel2.labelTextUnCheckedColor = [UIColor whiteColor];
    checkBoxLabel2.boxUnCheckedStrokeColor = [UIColor lightGrayColor];
    checkBoxLabel2.boxCheckedStrokeColor = [UIColor whiteColor];
    checkBoxLabel2.markCheckedStrokeColor = [UIColor whiteColor];
    checkBoxLabel2.verticallyType = BMCheckBoxVerticallyType_Center;
    checkBoxLabel2.tag = 2;
    [checkBoxLabel2 addTarget:self action:@selector(fpsTypeValueDidChange:) forControlEvents:UIControlEventValueChanged];
    checkBoxLabel2.enabled = NO;
    [self.environmentScrollView addSubview:checkBoxLabel2];
    
    if (fpsLabel && !fpsLabel.hidden)
    {
        checkBoxLabel1.enabled = YES;
        checkBoxLabel1.checkState = (fpsLabel.type & YYFPSLabelType_CPU) > 0;

        checkBoxLabel2.enabled = YES;
        checkBoxLabel2.checkState = (fpsLabel.type & YYFPSLabelType_MEM) > 0;
    }
    
    // 标尺设置
    UILabel *alignLabel = [UILabel bm_labelWithFrame:CGRectMake(10.0f, checkBoxLabel1.bm_bottom+6.0f, 200.0f, 30.0f) text:@"测量标尺" fontSize:14.0f color:[UIColor whiteColor] alignment:NSTextAlignmentLeft lines:1];
    [self.environmentScrollView addSubview:alignLabel];
    
    switchView = [[UISwitch alloc] init];
    switchView.exclusiveTouch = YES;
    [switchView addTarget:self action:@selector(alignSwitchValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.environmentScrollView addSubview:switchView];
    switchView.bm_top = checkBoxLabel1.bm_bottom + 6.0f;
    switchView.bm_left = alignLabel.bm_right+10.0f;
    switchView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    switchView.on = [BMConsole isShowAlign];

    // 颜色提取设置
    UILabel *colorLabel = [UILabel bm_labelWithFrame:CGRectMake(10.0f, alignLabel.bm_bottom+12.0f, 200.0f, 30.0f) text:@"颜色提取" fontSize:14.0f color:[UIColor whiteColor] alignment:NSTextAlignmentLeft lines:1];
    [self.environmentScrollView addSubview:colorLabel];
    
    switchView = [[UISwitch alloc] init];
    switchView.exclusiveTouch = YES;
    [switchView addTarget:self action:@selector(colorPickerSwitchValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.environmentScrollView addSubview:switchView];
    switchView.bm_top = alignLabel.bm_bottom + 12.0f;
    switchView.bm_left = colorLabel.bm_right+10.0f;
    switchView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    switchView.on = [BMConsole isShowColorPicker];

    // 网络监控开关
    UILabel *netLabel = [UILabel bm_labelWithFrame:CGRectMake(10.0f, colorLabel.bm_bottom+12.0f, 200.0f, 30.0f) text:@"网络监控" fontSize:14.0f color:[UIColor whiteColor] alignment:NSTextAlignmentLeft lines:1];
    [self.environmentScrollView addSubview:netLabel];
    
    switchView = [[UISwitch alloc] init];
    switchView.exclusiveTouch = YES;
    [switchView addTarget:self action:@selector(netSwitchValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.environmentScrollView addSubview:switchView];
    switchView.bm_top = colorLabel.bm_bottom + 12.0f;
    switchView.bm_left = netLabel.bm_right+10.0f;
    switchView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    switchView.on = [BMConsole isMonitorNet];

    self.environmentScrollView.contentSize =  CGSizeMake(UI_SCREEN_WIDTH, netLabel.bm_bottom+10.0f);
                                                         
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25f];
    self.environmentBgView.bm_top = UI_SCREEN_HEIGHT-300;
    [UIView commitAnimations];
}

- (void)environmentCloseAction:(id)sender
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
        self.environmentBgView.bm_top = UI_SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self.environmentScrollView bm_removeAllSubviews];
    }];
}

- (void)environmentItemAction:(UIButton *)sender
{
    NSInteger index = sender.tag;
    
    BMConsoleEnvironment *environment = self.environmentArray[index];

    [self handleConsoleCommand:environment.command withParameter:environment.parameter];
    
    [self environmentCloseAction:sender];
}

- (void)fpsSwitchValueDidChange:(UISwitch *)switchView
{
    [self handleConsoleCommand:@"fps"];
}

- (void)fpsTypeValueDidChange:(BMCheckBoxLabel *)checkBoxLabel
{
    YYFPSLabel *fpsLabel = nil;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if ([window isKindOfClass:[BMConsoleWindow class]])
    {
        BMConsoleWindow *consoleWindow = (BMConsoleWindow *)window;
        fpsLabel = consoleWindow.fpsLabel;
    }
    
    if (checkBoxLabel.tag == 1)
    {
        if (checkBoxLabel.checkState)
        {
            fpsLabel.type |= YYFPSLabelType_CPU;
        }
        else
        {
            fpsLabel.type &= ~YYFPSLabelType_CPU;
        }
    }
    else if (checkBoxLabel.tag == 2)
    {
        if (checkBoxLabel.checkState)
        {
            fpsLabel.type |= YYFPSLabelType_MEM;
        }
        else
        {
            fpsLabel.type &= ~YYFPSLabelType_MEM;
        }
    }
}

- (void)alignSwitchValueDidChange:(UISwitch *)switchView
{
    [self handleConsoleCommand:@"align"];
}

- (void)colorPickerSwitchValueDidChange:(UISwitch *)switchView
{
    [self handleConsoleCommand:@"cp"];
}

- (void)netSwitchValueDidChange:(UISwitch *)switchView
{
    [self handleConsoleCommand:@"mn"];
}

- (void)infoAction
{
    [self findAndResignFirstResponder:[self mainWindow]];
    
    //note: we can't use UIAlertController because we don't have a UIViewController
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"清除信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [BMConsole clear];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"发送Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 发邮件
        NSString *URLSafeName = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] bm_URLEncode];
        NSString *URLSafeLog = [[self.log componentsJoinedByString:@"\n"] bm_URLEncode];
        NSMutableString *URLString = [NSMutableString stringWithFormat:@"mailto:%@?subject=%@%%20Console%%20Log&body=%@",
                                      self.logSubmissionEmail ?: @"", URLSafeName, URLSafeLog];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"帮助" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self handleConsoleCommand:@"help"];
    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    [actionSheet addAction:action4];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)FLEXAction:(UIButton *)sender
{
    [[FLEXManager sharedManager] showExplorer];
    [self performSelector:@selector(hideConsole) withObject:nil afterDelay:0.5];
}

- (void)colorSetAction:(UIButton *)sender
{
//    [self.inputField resignFirstResponder];
    
    self.colorSetView = [[UIView alloc]initWithFrame:CGRectMake(-UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-(EDITFIELD_HEIGHT + 10 + TOOL_BUTTON_HEIGHT), UI_SCREEN_WIDTH, EDITFIELD_HEIGHT + 10 + TOOL_BUTTON_HEIGHT)];
    self.colorSetView.backgroundColor =  [UIColor bm_colorWithHex:0x999999];
    [self.view addSubview:self.colorSetView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.exclusiveTouch = YES;
    [closeButton setTitle:@"╳" forState:UIControlStateNormal];
    [closeButton setTitleColor:_textColor forState:UIControlStateNormal];
    [closeButton setTitleColor:[_textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];;
    closeButton.frame = CGRectMake(self.colorSetView.frame.size.width-30,0,30, 30);
    [closeButton addTarget:self action:@selector(closeSetColorAction:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.colorSetView addSubview:closeButton];
    
    UIButton *textButton = [UIButton buttonWithType:UIButtonTypeCustom];
    textButton.exclusiveTouch = YES;
    textButton.tag = 2000;
    [textButton setTitle:@"文字颜色-开启" forState:UIControlStateNormal];
    [textButton setTitleColor:_textColor forState:UIControlStateNormal];
    [textButton setTitleColor:[_textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    textButton.backgroundColor = [UIColor bm_colorWithHex:0x333333];
    textButton.titleLabel.font = [textButton.titleLabel.font fontWithSize:12];
    textButton.frame = CGRectMake(5,2,90, 30);
    [textButton addTarget:self action:@selector(colorSwicthAction:) forControlEvents:UIControlEventTouchUpInside];
    textButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    textButton.layer.borderWidth=2;
    textButton.layer.borderColor=[[UIColor greenColor] CGColor];
    [self.colorSetView addSubview:textButton];
    
    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.exclusiveTouch = YES;
    bgButton.tag = 2001;
    [bgButton setTitle:@"背景颜色-关闭" forState:UIControlStateNormal];
    [bgButton setTitleColor:_textColor forState:UIControlStateNormal];
    [bgButton setTitleColor:[_textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    bgButton.backgroundColor = [UIColor bm_colorWithHex:0x555555];
    bgButton.titleLabel.font = [bgButton.titleLabel.font fontWithSize:12];
    bgButton.frame = CGRectMake(97,2,90, 30);
    [bgButton addTarget:self action:@selector(colorSwicthAction:) forControlEvents:UIControlEventTouchUpInside];
    bgButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.colorSetView addSubview:bgButton];
    
    NSArray *colorNames = [NSArray arrayWithObjects:@"blackColor",@"grayColor",@"whiteColor",@"redColor",@"magentaColor",@"blueColor",@"orangeColor",@"purpleColor",@"brownColor", nil];
    for (NSUInteger i=0; i<colorNames.count; i++)
    {
        UIButton *colorButtons = [UIButton buttonWithType:UIButtonTypeCustom];
        colorButtons.exclusiveTouch = YES;
        colorButtons.tag = 3000+i;
        [colorButtons setTitle:colorNames[i] forState:UIControlStateNormal];
        [colorButtons setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        SEL selecter = NSSelectorFromString(colorNames[i]);
        colorButtons.backgroundColor = [UIColor performSelector:selecter];
        colorButtons.frame = CGRectMake(9 + (22 + 13)*i,44, 24, 24);
        [colorButtons addTarget:self action:@selector(selectColorAction:) forControlEvents:UIControlEventTouchUpInside];
        colorButtons.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self.colorSetView addSubview:colorButtons];
    }
    
    [self checkAndChangeColorsList:_consoleView.backgroundColor andCurrentColor:_consoleView.textColor];
    
    UISlider *textFontSlider = [[UISlider alloc]initWithFrame:CGRectMake(195, 6, 90, 22)];
    textFontSlider.exclusiveTouch = YES;
    textFontSlider.minimumValue = 8;
    textFontSlider.maximumValue = 16;
    textFontSlider.value =  _consoleView.font.pointSize;
    [textFontSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.colorSetView addSubview:textFontSlider];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    CGRect  rect = self.colorSetView.frame;
    rect.origin.x += UI_SCREEN_WIDTH;
    self.colorSetView.frame = rect;
    [UIView commitAnimations];
}

- (void)closeSetColorAction:(id)sender
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
        CGRect  rect = self.colorSetView.frame;
        rect.origin.x -= UI_SCREEN_WIDTH;
        self.colorSetView.frame = rect;
    } completion:^(BOOL finished) {
        [self.colorSetView removeFromSuperview];
    }];
    self.colorSwicth = NO;
}

- (void)colorSwicthAction:(UIButton *)sender
{
    UIButton *tmpBt;
    if ([sender.titleLabel.text isEqualToString:@"文字颜色-关闭"])
    {
        [sender setTitle:@"文字颜色-开启" forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor bm_colorWithHex:0x333333];
        tmpBt = (UIButton *)[self.colorSetView viewWithTag:2001];
        [tmpBt setTitle:@"背景颜色-关闭" forState:UIControlStateNormal];
        tmpBt.backgroundColor = [UIColor bm_colorWithHex:0x555555];
        self.colorSwicth = NO;
        [self checkAndChangeColorsList:_consoleView.backgroundColor andCurrentColor:_consoleView.textColor];
    }
    else if([sender.titleLabel.text isEqualToString:@"背景颜色-关闭"])
    {
        [sender setTitle:@"背景颜色-开启" forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor bm_colorWithHex:0x333333];
        tmpBt = (UIButton *)[self.colorSetView viewWithTag:2000];
        [tmpBt setTitle:@"文字颜色-关闭" forState:UIControlStateNormal];
        tmpBt.backgroundColor = [UIColor bm_colorWithHex:0x555555];
        self.colorSwicth = YES;
        [self checkAndChangeColorsList:_consoleView.textColor andCurrentColor:_consoleView.backgroundColor];
    }
    sender.layer.borderWidth=2;
    sender.layer.borderColor=[[UIColor greenColor] CGColor];
    tmpBt.layer.borderWidth=0;
}

- (void)selectColorAction:(UIButton *)sender
{
    [self checkColorBorder:sender];
    
    SEL selecter = NSSelectorFromString(sender.titleLabel.text);
    if (self.colorSwicth)
    {
        self.consoleView.backgroundColor =  [UIColor performSelector:selecter];
    }
    else
    {
        self.consoleView.textColor =  [UIColor performSelector:selecter];
    }
}

- (void)checkAndChangeColorsList:(UIColor *)theColor andCurrentColor:(UIColor *)theCurrentColor
{
    UIButton *tmpBt;
    for (NSInteger i=0; i<9; i++)
    {
        tmpBt = (UIButton *)[self.colorSetView viewWithTag:3000+i];
        if (tmpBt.backgroundColor ==theColor)
        {
            [tmpBt setEnabled:NO];
            tmpBt.bm_width=12;
            tmpBt.bm_height=12;
            tmpBt.bm_top +=6;
            tmpBt.bm_left +=6;
            tmpBt.layer.borderWidth=0;
        }
        else if(tmpBt.backgroundColor == theCurrentColor)
        {
            if (tmpBt.bm_width != 24)
            {
                [tmpBt setEnabled:YES];
                tmpBt.bm_width = 24;
                tmpBt.bm_height = 24;
                tmpBt.bm_top -= 6;
                tmpBt.bm_left -= 6;
            }
            tmpBt.layer.borderWidth=2;
            tmpBt.layer.borderColor=[[UIColor greenColor] CGColor];
        }
    }
}

-(void)checkColorBorder:(UIButton *)theButton
{
    UIButton *tmpBt;
    for (NSInteger i=0; i<9; i++)
    {
        tmpBt = (UIButton *)[self.colorSetView viewWithTag:3000+i];
        if (tmpBt == theButton)
        {
            tmpBt.layer.borderWidth=2;
            tmpBt.layer.borderColor=[[UIColor greenColor] CGColor];
        }
        else
        {
            tmpBt.layer.borderWidth=0;
        }
    }
}


#pragma mark - UISlider

- (void)sliderAction:(UISlider *)slider
{
    self.consoleView.font = [UIFont fontWithName:@"Courier" size:slider.value];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text bm_isNotEmpty])
    {
        NSArray *strArray = [textField.text componentsSeparatedByString:@"&"];
        for (NSString *str in strArray)
        {
            [BMConsole log:@"%@", str];
            [self handleConsoleCommand:str];
        }
        textField.text = @"";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}


#pragma mark -
#pragma mark methods

- (BOOL)findAndResignFirstResponder:(UIView *)view
{
    if ([view isFirstResponder])
    {
        [view resignFirstResponder];
        return YES;
    }
    for (UIView *subview in view.subviews)
    {
        if ([self findAndResignFirstResponder:subview])
        {
            return YES;
        }
    }
    return NO;
}

- (void)setConsoleText
{
    NSString *text = self.infoString;
    text = [text stringByAppendingString:@"\n"];
    NSUInteger touches = (TARGET_IPHONE_SIMULATOR ? self.simulatorTouchesToShow : self.deviceTouchesToShow);
    if (touches > 0 && touches < 11)
    {
        text = [text stringByAppendingFormat:@"\n说明：屏幕上滑动%zd根手指控制台界面的显示/隐藏", touches];
    }
    else if (TARGET_IPHONE_SIMULATOR ? self.simulatorShakeToShow : self.deviceShakeToShow)
    {
        text = [text stringByAppendingString:@"\n晃动设备显示/隐藏控制台界面"];
    }
    text = [text stringByAppendingString:@"\n-------------------------------------------"];
    text = [text stringByAppendingString:@"\n提示：执行“help”命令可获取使用帮助"];
    text = [text stringByAppendingString:[[self.log arrayByAddingObject:@">"] componentsJoinedByString:@"\n"]];

    self.consoleView.text = text;
    
    [self.consoleView scrollRangeToVisible:NSMakeRange(text.length, 0)];
}

- (void)resetLog
{
    self.log = [NSMutableArray array];
    [self setConsoleText];
}

- (void)saveSettings
{
    if (_saveLogToDisk)
    {
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)clearSettings
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bmConsoleLog"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)logOnMainThread:(NSString *)message
{
    [self.log addObject:[@"> " stringByAppendingString:message]];
    if ([self.log count] > self.maxLogItems)
    {
        [self.log removeObjectAtIndex:0];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.log forKey:@"bmConsoleLog"];
    if (self.view.superview)
    {
        [self setConsoleText];
    }
}

- (void)showConsole
{
    if (!animating && self.view.superview == nil)
    {
        [self setConsoleText];
        
        [self findAndResignFirstResponder:[self mainWindow]];
        
        [BMConsole sharedConsole].view.frame = [self offscreenFrame];
        [[self mainWindow] addSubview:[BMConsole sharedConsole].view];
        
        animating = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(consoleShown)];
        [BMConsole sharedConsole].view.frame = [self onscreenFrame];
        [BMConsole sharedConsole].view.transform = [self viewTransform];
        [UIView commitAnimations];
    }
}

- (void)consoleShown
{
    animating = NO;
    [self findAndResignFirstResponder:[self mainWindow]];
}

- (void)hideConsole
{
    if (!animating && self.view.superview != nil)
    {
        [self findAndResignFirstResponder:[self mainWindow]];
        
        animating = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(consoleHidden)];
        [BMConsole sharedConsole].view.frame = [self offscreenFrame];
        [UIView commitAnimations];
    }
}

- (void)consoleHidden
{
    animating = NO;
    [[[BMConsole sharedConsole] view] removeFromSuperview];
    
    [self environmentCloseAction:nil];
}


#pragma mark -
#pragma mark Public methods

+ (void)log:(NSString *)format, ...
{
    va_list argList;
    va_start(argList, format);
    [self log:format args:argList];
    va_end(argList);
}

+ (void)info:(NSString *)format, ...
{
    va_list argList;
    va_start(argList, format);
    [self info:format args:argList];
    va_end(argList);
}

+ (void)warn:(NSString *)format, ...
{
    va_list argList;
    va_start(argList, format);
    [self warn:format args:argList];
    va_end(argList);
}

+ (void)error:(NSString *)format, ...
{
    va_list argList;
    va_start(argList, format);
    [self error:format args:argList];
    va_end(argList);
}

+ (void)crash:(NSString *)format, ...
{
    va_list argList;
    va_start(argList, format);
    [self crash:format args:argList];
    va_end(argList);
}

+ (void)log:(NSString *)format args:(va_list)argList
{
    if ([self sharedConsole].logLevel > BMConsoleLogLevel_None)
    {
        NSString *message = [(NSString *)[NSString alloc] initWithFormat:format arguments:argList];
        
        NSLog(@"%@", message);
        
        if ([self sharedConsole].enabled)
        {
            if ([NSThread currentThread] == [NSThread mainThread])
            {
                [[self sharedConsole] logOnMainThread:message];
            }
            else
            {
                [[self sharedConsole] performSelectorOnMainThread:@selector(logOnMainThread:)
                                                       withObject:message waitUntilDone:NO];
            }
        }
    }
}

+ (void)info:(NSString *)format args:(va_list)argList
{
    if ([self sharedConsole].logLevel >= BMConsoleLogLevel_Info)
    {
        [self log:[@"INFO: " stringByAppendingString:format] args:argList];
    }
}

+ (void)warn:(NSString *)format args:(va_list)argList
{
    if ([self sharedConsole].logLevel >= BMConsoleLogLevel_Warning)
    {
        [self log:[@"WARNING: " stringByAppendingString:format] args:argList];
    }
}

+ (void)error:(NSString *)format args:(va_list)argList
{
    if ([self sharedConsole].logLevel >= BMConsoleLogLevel_Error)
    {
        [self log:[@"ERROR: " stringByAppendingString:format] args:argList];
    }
}

+ (void)crash:(NSString *)format args:(va_list)argList
{
    if ([self sharedConsole].logLevel >= BMConsoleLogLevel_Crash)
    {
        [self log:[@"CRASH: " stringByAppendingString:format] args:argList];
    }
}

+ (void)clean
{
    [[BMConsole sharedConsole] clearSettings];
    [[BMConsole sharedConsole] resetLog];
}

+ (void)clear
{
    [[BMConsole sharedConsole] resetLog];
}

+ (void)show
{
    [[BMConsole sharedConsole] showConsole];
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if ([window isKindOfClass:[BMConsoleWindow class]])
    {
        BMConsoleWindow *consoleWindow = (BMConsoleWindow *)window;
        [consoleWindow.fpsLabel bm_bringToFront];
    }
    
    if ([BMConsole isShowAlign])
    {
        [[BMTestAlignManager sharedInstance] show];
    }

    if ([BMConsole isShowColorPicker])
    {
        [[BMTestColorPickerManager sharedInstance] show];
    }
}

+ (void)hide
{
    [[BMConsole sharedConsole] hideConsole];
}

+ (void)showAlign
{
    [[BMTestAlignManager sharedInstance] show];
}

+ (void)closeAlign
{
    [[BMTestAlignManager sharedInstance] close];
}

+ (BOOL)isShowAlign
{
    return [[BMTestAlignManager sharedInstance] isShow];
}

+ (void)showColorPicker
{
    [[BMTestColorPickerManager sharedInstance] show];
}

+ (void)closeColorPicker
{
    [[BMTestColorPickerManager sharedInstance] close];
}

+ (BOOL)isShowColorPicker
{
    return [[BMTestColorPickerManager sharedInstance] isShow];
}

+ (BOOL)isMonitorNet
{
    return [BMTestNetFlowManager sharedInstance].canIntercept;
}

+ (void)startMonitorNet
{
    if (![BMTestNetFlowManager sharedInstance].canIntercept)
    {
        [[BMTestNetFlowManager sharedInstance] canInterceptNetFlow:YES];
    }
}

+ (void)stopMonitorNet
{
    [[BMTestNetFlowManager sharedInstance] canInterceptNetFlow:NO];
}


#pragma mark -
#pragma mark handleConsole

// 按键事件
- (void)handleConsoleButton:(UIButton *)sender
{
    [self.delegate handleConsoleButton:sender];
}

- (void)handleConsoleCommand:(NSString *)command
{
    [self handleConsoleCommand:command withParameter:nil];
}

- (void)handleConsoleCommand:(NSString *)command withParameter:(id)parameter
{
    if (![command bm_isNotEmpty])
    {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(handleConsoleCommand:withParameter:)])
    {
        if ([self.delegate handleConsoleCommand:command withParameter:parameter])
        {
            return;
        }
    }
    else
    {
        if ([self.delegate handleConsoleCommand:command])
        {
            return;
        }
    }

    [BMConsole log:@"\n==========================================="];
    
    BOOL ret = NO;
    
    if ([command isEqualToString:@"version"])   // 显示app版本信息
    {
        ret = YES;
        [BMConsole log:@"%@ version %@ - build %@",
         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"],
         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    }
    else if ([command isEqualToString:@"cl"])   //清除存储并刷新屏幕
    {
        ret = YES;
        [BMConsole clean];
    }
    else if ([command isEqualToString:@"clear"])    // 清除屏幕
    {
        ret = YES;
        [BMConsole clear];
    }
    else if ([command isEqualToString:@"log"])  // 打印所有log
    {
        ret = YES;
        static NSString *pidString = nil;
        if (!pidString) {
            pidString = @([[NSProcessInfo processInfo] processIdentifier]).stringValue;
        }
        
        asl_object_t query, m;
        query = asl_new(ASL_TYPE_QUERY);
        asl_set_query(query, ASL_KEY_PID, pidString.UTF8String, ASL_QUERY_OP_EQUAL);
        
        aslresponse response = asl_search(NULL, query);
        while (NULL != (m = asl_next(response)))
        {
            const char *messageText = asl_get(m, ASL_KEY_MSG);
            if (messageText)
            {
                NSString *text = [NSString stringWithUTF8String:messageText];
                text = [NSString bm_convertUnicode:text];
                
                [BMConsole log:@"%@", [self getObjectDescription:text andIndent:0]];
            }
        }
        
        asl_release(response);
    }
    else if ([command isEqualToString:@"fps"]) // help命令
    {
        ret = YES;
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        if ([window isKindOfClass:[BMConsoleWindow class]])
        {
            BMConsoleWindow *consoleWindow = (BMConsoleWindow *)window;
            [consoleWindow.fpsLabel bm_bringToFront];
            consoleWindow.fpsLabel.hidden = !consoleWindow.fpsLabel.hidden;
            if (consoleWindow.fpsLabel.hidden)
            {
                [BMConsole log:@"fps监测关闭"];
            }
            else
            {
                [BMConsole log:@"fps监测打开"];
            }
        }
    }
    else if ([command rangeOfString:@"email:"].length > 0)  // 设置反馈邮件
    {
        ret = YES;
        [BMConsole sharedConsole].logSubmissionEmail = [command stringByReplacingCharactersInRange:[command rangeOfString:@"email:"] withString:@""];
        [BMConsole log:@"变更email: %@", [BMConsole sharedConsole].logSubmissionEmail];
    }
    // 标尺
    else if ([command isEqualToString:@"al"] || [command isEqualToString:@"align"])
    {
        ret = YES;
        [BMConsole hide];
        if ([BMConsole isShowAlign])
        {
            [BMConsole closeAlign];
        }
        else
        {
            [BMConsole showAlign];
        }
    }
    // 颜色提取
    else if ([command isEqualToString:@"cp"] || [command isEqualToString:@"color"])
    {
        ret = YES;
        [BMConsole hide];
        if ([BMConsole isShowColorPicker])
        {
            [BMConsole closeColorPicker];
        }
        else
        {
            [BMConsole showColorPicker];
        }
    }
    else if ([command isEqualToString:@"gps"])
    {
        ret = YES;
        BMTestGPSMockVC *vc = [[BMTestGPSMockVC alloc] init];
        BMNavigationController *nav = [[BMNavigationController alloc] initWithRootViewController:vc];
        [[BMConsole sharedConsole] presentViewController:nav animated:YES completion:^{
        }];
    }
    else if ([command isEqualToString:@"app"])
    {
        ret = YES;
        BMTestAppInfoVC *vc = [[BMTestAppInfoVC alloc] init];
        BMNavigationController *nav = [[BMNavigationController alloc] initWithRootViewController:vc];
        [[BMConsole sharedConsole] presentViewController:nav animated:YES completion:^{
            [BMConsole hide];
        }];
    }
    // 网络监控开关
    else if ([command isEqualToString:@"mn"])
    {
        ret = YES;
        if ([BMConsole isMonitorNet])
        {
            [BMConsole stopMonitorNet];
        }
        else
        {
            [BMConsole startMonitorNet];
        }
    }
    // 网络监控表
    else if ([command isEqualToString:@"nf"])
    {
        ret = YES;
        BMTestNetFlowSummaryVC *vc = [[BMTestNetFlowSummaryVC alloc] init];
        BMNavigationController *nav = [[BMNavigationController alloc] initWithRootViewController:vc];
        [[BMConsole sharedConsole] presentViewController:nav animated:YES completion:^{
            [BMConsole hide];
        }];
    }
    else if ([command isEqualToString:@"h"] || [command isEqualToString:@"help"]) // help命令
    {
        ret = YES;
        NSMutableString *helpStr = [[NSMutableString alloc] init];
        [helpStr appendString:@"\n(01) 'help' 显示命令帮助文档\n"];
        [helpStr appendString:@"(02) 'version' 显示app版本\n"];
        [helpStr appendString:@"(03) 'clear' 清除控制台信息\n"];
        [helpStr appendString:@"(04) 'log' 打印所有NSLog\n"];
        [helpStr appendString:@"(05) 'fps' 显示隐藏FPS监测\n"];
        [helpStr appendString:@"(06) 'al' 显示隐藏标尺\n"];
        [helpStr appendString:@"(07) 'cp' 显示隐藏颜色提取\n"];
        [helpStr appendString:@"(08) 'gps' 模拟GPS定位数据\n"];
        [helpStr appendString:@"(09) 'mn' 网络监控开关\n"];
        [helpStr appendString:@"(10) 'nf' 网络监控表\n"];

        [BMConsole log:@"%@", helpStr];
    }
    
    if (!ret)
    {
        if (![command containsString:@"://"])
        {
            NSString *newcommand = [NSString stringWithFormat:@"http://%@", command];
            if ([self.delegate respondsToSelector:@selector(handleConsoleCommand:withParameter:)])
            {
                [self.delegate handleConsoleCommand:newcommand withParameter:parameter];
            }
            else
            {
                [self.delegate handleConsoleCommand:newcommand];
            }
        }
    }
}

/*
 该函数用于解析中文log，也可以提取出来作为工具使用
 */
- (NSMutableString*)getObjectDescription:(NSObject*)obj andIndent:(NSUInteger)level
{
    NSMutableString *str = [NSMutableString string];
    NSString * strIndent = @"";
    if (level>0)
    {
        NSArray *indentAry = [self generateArrayWithFillItem:@"\t" andArrayLength:level];
        strIndent = [indentAry componentsJoinedByString:@""];
    }
    
    if ([obj isKindOfClass:NSString.class])
    {
        [str appendFormat:@"\n%@%@", strIndent, obj];
    }
    else if([obj isKindOfClass:NSArray.class])
    {
        [str appendFormat:@"\n%@(", strIndent];
        NSArray *ary = (NSArray *)obj;
        for (NSUInteger i=0; i<ary.count; i++)
        {
            NSString *s = [self getObjectDescription:ary[i] andIndent:level+1];
            [str appendFormat:@"%@ ,", s];
        }
        [str appendFormat:@"\n%@)", strIndent];
    }
    else if([obj isKindOfClass:NSDictionary.class])
    {
        [str appendFormat:@"\n%@{",strIndent];
        NSDictionary *dict = (NSDictionary *)obj;
        for (NSString *key in dict)
        {
            NSObject *val = dict[key];
            [str appendFormat:@"\n\t%@%@=",strIndent,key];
            NSString *s = [self getObjectDescription:val andIndent:level+2];
            [str appendFormat:@"%@ ;", s];
        }
        [str appendFormat:@"\n%@}",strIndent];
        
    }
    else
    {
        [str appendFormat:@"\n%@%@", strIndent, [obj debugDescription]];
    }
    
    return str;
}

- (NSMutableArray*)generateArrayWithFillItem:(NSObject*)fillItem andArrayLength:(NSInteger)length
{
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:length];
    for (NSInteger i=0; i<length; i++)
    {
        [ary addObject:fillItem];
    }
    
    return ary;
}

@end


#pragma mark -
#pragma mark BMConsoleWindow

@interface BMConsoleWindow ()

@property (nonatomic, strong) YYFPSLabel *fpsLabel;

@end

@implementation BMConsoleWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        YYFPSLabel *fpsLabel = [[YYFPSLabel alloc] init];
        fpsLabel.type = YYFPSLabelType_ALL;
        [self addSubview:fpsLabel];
        
        fpsLabel.bm_left = self.bm_left + 6;
        fpsLabel.bm_top = self.bm_top + 6 + UI_NAVIGATION_BAR_HEIGHT + UI_STATUS_BAR_HEIGHT;
        //fpsLabel.center = self.center;
        self.fpsLabel = fpsLabel;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(fpsPanGestureAction:)];
        [fpsLabel addGestureRecognizer:pan];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(windowDidBecomeVisibleNotification:) name:UIWindowDidBecomeVisibleNotification object:nil];
    
    return self;
}

- (void)windowDidBecomeVisibleNotification:(NSNotification *)notification
{
    [self bringSubviews];
}

- (void)bringSubviews
{
    [self.fpsLabel bm_bringToFront];
}

- (void)fpsPanGestureAction:(UIPanGestureRecognizer *)panGesture
{
    NSLog(@"fpsPanGestureAction");
    UIView *panView = panGesture.view;
    
    //1、获得拖动位移
    CGPoint offsetPoint = [panGesture translationInView:panView];
    //2、清空拖动位移
    [panGesture setTranslation:CGPointZero inView:panView];
    //3、重新设置控件位置
    CGFloat newX = panView.bm_centerX+offsetPoint.x;
    CGFloat newY = panView.bm_centerY+offsetPoint.y;
    CGPoint centerPoint = CGPointMake(newX, newY);
    panView.center = centerPoint;
}

- (void)sendEvent:(UIEvent *)event
{
    if ([BMConsole sharedConsole].enabled && event.type == UIEventTypeTouches)
    {
        NSSet *touches = [event allTouches];
        if ([touches count] == (TARGET_IPHONE_SIMULATOR ? [BMConsole sharedConsole].simulatorTouchesToShow: [BMConsole sharedConsole].deviceTouchesToShow))
        {
            BOOL allUp = YES;
            BOOL allDown = YES;
            BOOL allLeft = YES;
            BOOL allRight = YES;
            
            for (UITouch *touch in touches)
            {
                if ([touch locationInView:self].y <= [touch previousLocationInView:self].y)
                {
                    allDown = NO;
                }
                if ([touch locationInView:self].y >= [touch previousLocationInView:self].y)
                {
                    allUp = NO;
                }
                if ([touch locationInView:self].x <= [touch previousLocationInView:self].x)
                {
                    allLeft = NO;
                }
                if ([touch locationInView:self].x >= [touch previousLocationInView:self].x)
                {
                    allRight = NO;
                }
            }
            
            switch ([UIApplication sharedApplication].statusBarOrientation)
            {
                case UIInterfaceOrientationPortrait:
#ifdef __IPHONE_8_0
                case UIInterfaceOrientationUnknown:
#endif
                {
                    if (allUp)
                    {
                        [BMConsole show];
                    }
                    else if (allDown)
                    {
                        [BMConsole hide];
                    }
                    break;
                }
                case UIInterfaceOrientationPortraitUpsideDown:
                {
                    if (allDown)
                    {
                        [BMConsole show];
                    }
                    else if (allUp)
                    {
                        [BMConsole hide];
                    }
                    break;
                }
                case UIInterfaceOrientationLandscapeLeft:
                {
                    if (allRight)
                    {
                        [BMConsole show];
                    }
                    else if (allLeft)
                    {
                        [BMConsole hide];
                    }
                    break;
                }
                case UIInterfaceOrientationLandscapeRight:
                {
                    if (allLeft)
                    {
                        [BMConsole show];
                    }
                    else if (allRight)
                    {
                        [BMConsole hide];
                    }
                    break;
                }
                default:
                    NSLog(@"Unexpected case - will do nothing here");
                    break;
            }
        }
    }
    return [super sendEvent:event];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ([BMConsole sharedConsole].enabled &&
        (TARGET_IPHONE_SIMULATOR ? [BMConsole sharedConsole].simulatorShakeToShow: [BMConsole sharedConsole].deviceShakeToShow))
    {
        if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake)
        {
            if ([BMConsole sharedConsole].view.superview == nil)
            {
                [BMConsole show];
            }
            else
            {
                [BMConsole hide];
            }
        }
    }
    [super motionEnded:motion withEvent:event];
}

- (BOOL)checkCanUserShake
{
    UIViewController *vc = self.rootViewController;
    
    if (vc)
    {
        return YES;
    }
    
    return YES;
}

- (void)setRootViewController:(UIViewController *)rootViewController
{
    [super setRootViewController:rootViewController];
    
    [self bringSubviews];
}

@end
