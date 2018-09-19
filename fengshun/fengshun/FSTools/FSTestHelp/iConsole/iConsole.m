//
//  iConsole.m
//
//  Version 1.5.3
//
//  Created by Nick Lockwood on 20/12/2010.
//  Copyright 2010 Charcoal Design
//  Modify by heyanyang 2014-07-25.

//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/iConsole
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//
#if USE_TEST_HELP


#import "iConsole.h"
#import <stdarg.h>
#import <string.h> 
#import <TargetConditionals.h>


#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif


#if ICONSOLE_USE_GOOGLE_STACK_TRACE
#import "GTMStackTrace.h"
#endif

#import "FLEX.h"

#import "NSString+BMURLEncode.h"

#define EDITFIELD_HEIGHT 28
#define ACTION_BUTTON_WIDTH 28

#define TOOL_BUTTON_HEIGHT 40


@interface iConsole() <UITextFieldDelegate, UIActionSheetDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITextView *consoleView;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, strong) UIButton *showCommonButton;
@property (nonatomic, strong) UIScrollView *commonInfoScrollView;
@property (nonatomic, strong) NSMutableArray *commonInfoArray;

@property (nonatomic, strong) UIButton *FLEXButton;
@property (nonatomic, strong) UIButton *colorSetButton;
@property (nonatomic, strong) UIView *colorSetView;
@property (nonatomic, assign) BOOL colorSwicth;

@property (nonatomic, strong) NSMutableArray *log;
@property (nonatomic, assign) BOOL animating;

- (void)saveSettings;

@end


@implementation iConsole

#pragma mark -
#pragma mark Private methods

static void exceptionHandler(NSException *exception)
{
	
#if ICONSOLE_USE_GOOGLE_STACK_TRACE
	
    extern NSString *GTMStackTraceFromException(NSException *e);
    [iConsole crash:@"%@\n\nStack trace:\n%@)", exception, GTMStackTraceFromException(exception)];
	
#else
	
	[iConsole crash:@"%@", exception];
	 
#endif

	[[iConsole sharedConsole] saveSettings];
}

+ (void)load
{
    //initialise the console
    [iConsole performSelectorOnMainThread:@selector(sharedConsole) withObject:nil waitUntilDone:NO];
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}

- (void)setConsoleText
{
	NSString *text = _infoString;
	NSUInteger touches = (TARGET_IPHONE_SIMULATOR ? _simulatorTouchesToShow: _deviceTouchesToShow);
	if (touches > 0 && touches < 11)
	{
//		text = [text stringByAppendingFormat:@"\nSwipe down with %zd finger%@ to hide console", touches, (touches != 1)? @"s": @""];
		text = [text stringByAppendingFormat:@"\n说明：摇晃或上下滑动%zd根手指控制平台界面的显示/隐藏", touches];
	}
	else if (TARGET_IPHONE_SIMULATOR ? _simulatorShakeToShow: _deviceShakeToShow)
	{
//		text = [text stringByAppendingString:@"\nShake device to hide console"];
		text = [text stringByAppendingString:@"\n晃动设备隐藏界面"];
	}
	text = [text stringByAppendingString:@"\n-------------------------------------------\n"];
	text = [text stringByAppendingString:@"提示：执行“help”命令可获取使用帮助"];
	text = [text stringByAppendingString:[[_log arrayByAddingObject:@">"] componentsJoinedByString:@"\n"]];
	_consoleView.text = text;
	
	[_consoleView scrollRangeToVisible:NSMakeRange(_consoleView.text.length, 0)];
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
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"iConsoleLog"];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

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

- (void)infoAction
{
	[self findAndResignFirstResponder:[self mainWindow]];
	
    //note: we can't use UIAlertController because we don't have a UIViewController
    
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@""
//                                                       delegate:self
//                                              cancelButtonTitle:@"取消"
//                                         destructiveButtonTitle:@"清除信息"
//                                              otherButtonTitles:@"发送Email", @"帮助", nil];
//
//    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//    [sheet showInView:self.view];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"清除信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [iConsole clear];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"发送Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 发邮件
        NSString *URLSafeName = [self URLEncodedString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]];
        NSString *URLSafeLog = [self URLEncodedString:[_log componentsJoinedByString:@"\n"]];
        NSMutableString *URLString = [NSMutableString stringWithFormat:@"mailto:%@?subject=%@%%20Console%%20Log&body=%@",
                                      _logSubmissionEmail ?: @"", URLSafeName, URLSafeLog];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"帮助" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_delegate handleConsoleCommand:@"help"];
    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    [actionSheet addAction:action4];
    [self presentViewController:actionSheet animated:YES completion:nil];

}

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
	//return [UIScreen mainScreen].applicationFrame;
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

- (void)showConsole
{	
	if (!_animating && self.view.superview == nil)
	{
        [self setConsoleText];
        
		[self findAndResignFirstResponder:[self mainWindow]];
		
		[iConsole sharedConsole].view.frame = [self offscreenFrame];
		[[self mainWindow] addSubview:[iConsole sharedConsole].view];
		
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(consoleShown)];
		[iConsole sharedConsole].view.frame = [self onscreenFrame];
        [iConsole sharedConsole].view.transform = [self viewTransform];
		[UIView commitAnimations];
	}
}

- (void)consoleShown
{
	_animating = NO;
	[self findAndResignFirstResponder:[self mainWindow]];
}

- (void)hideConsole
{
	if (!_animating && self.view.superview != nil)
	{
		[self findAndResignFirstResponder:[self mainWindow]];
		
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(consoleHidden)];
		[iConsole sharedConsole].view.frame = [self offscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)consoleHidden
{
	_animating = NO;
	[[[iConsole sharedConsole] view] removeFromSuperview];
}

- (void)rotateView:(NSNotification *)notification
{
	self.view.transform = [self viewTransform];
	self.view.frame = [self onscreenFrame];
	
	if (_delegate != nil)
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

- (void)logOnMainThread:(NSString *)message
{
	[_log addObject:[@"> " stringByAppendingString:message]];
	if ([_log count] > _maxLogItems)
	{
		[_log removeObjectAtIndex:0];
	}
    [[NSUserDefaults standardUserDefaults] setObject:_log forKey:@"iConsoleLog"];
    if (self.view.superview)
    {
        [self setConsoleText];
    }
}

#pragma mark -
#pragma mark custom Actions

- (void)showCommonAction:(id)sender
{
    [_delegate handleConsoleCommand:@"umengconfig"];

#if 0
        [self.inputField resignFirstResponder];
    
        self.commonInfoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, UI_SCREEN_WIDTH, 300)];
        self.commonInfoScrollView.contentSize =  CGSizeMake(UI_SCREEN_WIDTH, 1*5);
        self.commonInfoScrollView.delegate = self;
        self.commonInfoScrollView.showsVerticalScrollIndicator = NO;
        self.commonInfoScrollView.backgroundColor = [UIColor colorWithHex:0x333333];
        [self.view addSubview:self.commonInfoScrollView];
        
        UIView *topToolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.commonInfoScrollView.frame.size.width, 32)];
        topToolView.backgroundColor = [UIColor colorWithHex:0x666666];
        topToolView.tag = 5000;
        [self.commonInfoScrollView addSubview:topToolView];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.exclusiveTouch = YES;
        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [closeButton setTitleColor:_textColor forState:UIControlStateNormal];
        [closeButton setTitleColor:[_textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
//        closeButton.backgroundColor = [UIColor colorWithHex:0x999999];
        closeButton.titleLabel.font = [closeButton.titleLabel.font fontWithSize:14];
        closeButton.frame = CGRectMake(topToolView.frame.size.width-40,0,40, 32);
        [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        closeButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [topToolView addSubview:closeButton];
    
        NSMutableString* testEvmtStr = [[NSMutableString alloc]init];
        if ([DEV_SERVER isEqualToString:@"-dev"])
        {
            NSString *test_server_id = [[NSUserDefaults standardUserDefaults]objectForKey:DEBUG_TEST_SERVER_KEY];
            if (test_server_id != nil || [test_server_id length] != 0)
            {
                [testEvmtStr appendString:TEST_SERVER];
            }
            [testEvmtStr appendString:@"&dev"];
        }
        else
        {
            @try{
                     [testEvmtStr appendString:TEST_SERVER];
            }
            @catch(NSException *exception) {
                NSLog(@"exception:%@", exception);
            }  
            @finally {  
                
            }
        }
    
        NSRange range=[testEvmtStr rangeOfString:@"@"];
        if(range.location!=NSNotFound)
        {
            testEvmtStr = (NSMutableString *)[testEvmtStr substringFromIndex:range.location+1];
        }
    
        self.commonInfoArray = [[NSMutableArray alloc]initWithCapacity:0];

        for (NSInteger n = 1; n<=30; n++)
        {
            NSString *testStrDev = [NSString stringWithFormat:@"test%ld&dev", (long)n];
            [self.commonInfoArray addObject:testStrDev];
        }
        for (NSInteger n = 1; n<=30; n++)
        {
            NSString *testStr = [NSString stringWithFormat:@"%ld.test", (long)n];
            [self.commonInfoArray addObject:testStr];
        }
    
        for (NSInteger i=0; i<self.commonInfoArray.count; i++)
        {
            UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
            itemButton.exclusiveTouch = YES;
            itemButton.frame = CGRectMake(15+(i%3)*100,40+(i/3)*26 , 90, 18);
            itemButton.backgroundColor = [UIColor blackColor];
            if ([testEvmtStr isEqualToString:self.commonInfoArray[i]])
            {
                itemButton.layer.borderColor = [[UIColor greenColor] CGColor];
                itemButton.layer.borderWidth = 2;
            }
            [itemButton setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateHighlighted];
            [itemButton setTitle:self.commonInfoArray[i] forState:UIControlStateNormal];
            itemButton.titleLabel.font = [UIFont systemFontOfSize:12];
            [itemButton addTarget:self action:@selector(itemButtonActions:) forControlEvents:UIControlEventTouchUpInside];
            [self.commonInfoScrollView addSubview:itemButton];
        }
        NSInteger k = self.commonInfoArray.count % 3 ? 1 : 0;
        self.commonInfoScrollView.contentSize =  CGSizeMake(UI_SCREEN_WIDTH, 32+(self.commonInfoArray.count/3+k)*26);

        [topToolView bringToFront];

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        CGRect  rect = self.commonInfoScrollView.frame;
        rect.origin.y -= 300;
        self.commonInfoScrollView.frame = rect;
        [UIView commitAnimations];
#endif
}

- (void)closeAction:(id)sender
{
    __strong iConsole *_self = self;
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
        CGRect  rect = _self.commonInfoScrollView.frame;
        rect.origin.y += 300;
        _self.commonInfoScrollView.frame = rect;
    } completion:^(BOOL finished) {
        [_self.commonInfoScrollView removeFromSuperview];
    }];
}

- (void)itemButtonActions:(UIButton *)sender
{
//    NSLog(@"====%@",sender.titleLabel.text);
    NSArray *strArray = [sender.titleLabel.text  componentsSeparatedByString:@"&"];
//    NSLog(@"%@",[strArray description]);
    if (strArray.count == 1)
    {
        [_delegate handleConsoleCommand:@"on"];
    }
    for (NSString *str in strArray)
    {
        [_delegate handleConsoleCommand:str];
    }
    
    [self closeAction:sender];
}

- (void)shortcutAction:(UIButton *)sender
{
#if MAA_OPEN
    [_delegate handleConsoleButton:sender];
#else
    [_delegate handleConsoleCommand:sender.titleLabel.text];
#endif
}

- (void)FLEXAction:(UIButton *)sender
{
    [[FLEXManager sharedManager] showExplorer];
    [self performSelector:@selector(hideConsole) withObject:nil afterDelay:0.5];
}

- (void)colorSetAction:(UIButton *)sender
{
//    [self.inputField resignFirstResponder];
    
    self.colorSetView = [[UIView alloc]initWithFrame:CGRectMake(-320, self.view.bounds.size.height-(EDITFIELD_HEIGHT + 10 + TOOL_BUTTON_HEIGHT), UI_SCREEN_WIDTH, EDITFIELD_HEIGHT + 10 + TOOL_BUTTON_HEIGHT)];
    self.colorSetView.backgroundColor =  [UIColor bm_colorWithHex:0x999999];
    [self.view addSubview:self.colorSetView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.exclusiveTouch = YES;
    [closeButton setTitle:@"╳" forState:UIControlStateNormal];
    [closeButton setTitleColor:_textColor forState:UIControlStateNormal];
    [closeButton setTitleColor:[_textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    closeButton.titleLabel.font = [closeButton.titleLabel.font fontWithSize:14];
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
    rect.origin.x += 320;
    self.colorSetView.frame = rect;
    [UIView commitAnimations];
}

- (void)closeSetColorAction:(id)sender
{
    __strong iConsole *_self = self;
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
        CGRect  rect = _self.colorSetView.frame;
        rect.origin.x -= UI_SCREEN_WIDTH;
        _self.colorSetView.frame = rect;
    } completion:^(BOOL finished) {
        [_self.colorSetView removeFromSuperview];
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
        _consoleView.backgroundColor =  [UIColor performSelector:selecter];
    }
    else
    {
        _consoleView.textColor =  [UIColor performSelector:selecter];
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

-(void)sliderAction:(UISlider *)slider
{
//    NSLog(@"%f",slider.value);
    _consoleView.font = [UIFont fontWithName:@"Courier" size:slider.value];
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if (![textField.text isEqualToString:@""])
	{
//		[iConsole log:@"%@", textField.text];
//		[_delegate handleConsoleCommand:textField.text];

        NSArray *strArray = [textField.text componentsSeparatedByString:@"&"];
        for (NSString *str in strArray)
        {
            [iConsole log:@"%@", str];
            [_delegate handleConsoleCommand:str];
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

#pragma mark - scrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIView * topToolView = [self.commonInfoScrollView viewWithTag:5000];
    topToolView.bm_top = self.commonInfoScrollView.contentOffset.y;
}

#pragma mark -
#pragma mark UIActionSheetDelegate methods

- (NSString *)URLEncodedString:(NSString *)string
{
    //return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, CFSTR("!*'\"();:@&=+$,/?%#[]% "), kCFStringEncodingUTF8));
    
    return [string bm_URLEncode];
}

//- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == actionSheet.destructiveButtonIndex)
//    {
//        [iConsole clear];
//    }
//    else if (buttonIndex != actionSheet.cancelButtonIndex)
//    {
//        if (buttonIndex == 1)
//        {
//            // 发邮件
//            NSString *URLSafeName = [self URLEncodedString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]];
//            NSString *URLSafeLog = [self URLEncodedString:[_log componentsJoinedByString:@"\n"]];
//            NSMutableString *URLString = [NSMutableString stringWithFormat:@"mailto:%@?subject=%@%%20Console%%20Log&body=%@",
//                                          _logSubmissionEmail ?: @"", URLSafeName, URLSafeLog];
//
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
//        }
//        else if (buttonIndex == 2)
//        {
//            [_delegate handleConsoleCommand:@"help"];
//        }
//    }
//}


#pragma mark -
#pragma mark Life cycle

+ (iConsole *)sharedConsole
{
    @synchronized(self)
    {
        static iConsole *sharedConsole = nil;
        if (sharedConsole == nil)
        {
            sharedConsole = [[self alloc] init];
        }
        return sharedConsole; 
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
	{
        
#if ICONSOLE_ADD_EXCEPTION_HANDLER
        
        NSSetUncaughtExceptionHandler(&exceptionHandler);
        
#endif
        
        _enabled = YES;
        _logLevel = iConsoleLogLevelInfo;
        _saveLogToDisk = YES;
        _maxLogItems = 1000;
        _delegate = nil;
        
        _simulatorTouchesToShow = 2;
        _deviceTouchesToShow = 3;
        _simulatorShakeToShow = YES;
        _deviceShakeToShow = YES;
        
        self.infoString = @"秒钱 APP测试控制平台：";
        self.inputPlaceholderString = @"输入命令...";
        self.logSubmissionEmail = nil;
        
        self.backgroundColor = [UIColor blackColor];
        self.textColor = [UIColor whiteColor];
        self.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.log = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"iConsoleLog"]];
        
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
    
    self.view.clipsToBounds = YES;
    self.backgroundColor = [UIColor bm_colorWithHex:0x999999 alpha:1];
	self.view.backgroundColor = _backgroundColor;
	self.view.autoresizesSubviews = YES;

	_consoleView = [[UITextView alloc] initWithFrame:self.view.bounds];
	_consoleView.font = [UIFont fontWithName:@"Courier" size:12];
	_consoleView.textColor = [UIColor whiteColor];
	_consoleView.backgroundColor = [UIColor blackColor];
    _consoleView.indicatorStyle = _indicatorStyle;
	_consoleView.editable = NO;
	_consoleView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[self setConsoleText];
	[self.view addSubview:_consoleView];
	
	self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.actionButton.exclusiveTouch = YES;
    [_actionButton setTitle:@"⚙" forState:UIControlStateNormal];
    [_actionButton setTitleColor:_textColor forState:UIControlStateNormal];
    [_actionButton setTitleColor:[_textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    _actionButton.titleLabel.font = [_actionButton.titleLabel.font fontWithSize:ACTION_BUTTON_WIDTH];
	_actionButton.frame = CGRectMake(self.view.frame.size.width - ACTION_BUTTON_WIDTH - 5,
                                   self.view.frame.size.height - EDITFIELD_HEIGHT - 5-TOOL_BUTTON_HEIGHT,
                                   ACTION_BUTTON_WIDTH, EDITFIELD_HEIGHT);
	[_actionButton addTarget:self action:@selector(infoAction) forControlEvents:UIControlEventTouchUpInside];
	_actionButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[self.view addSubview:_actionButton];
	
	if (_delegate)
	{
		_inputField = [[UITextField alloc] initWithFrame:CGRectMake(5, self.view.frame.size.height - EDITFIELD_HEIGHT - 5-TOOL_BUTTON_HEIGHT,
                                                                    self.view.frame.size.width - 15 - ACTION_BUTTON_WIDTH-120,
                                                                    EDITFIELD_HEIGHT)];
		_inputField.borderStyle = UITextBorderStyleRoundedRect;
		_inputField.font = [UIFont fontWithName:@"Courier" size:12];
		_inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		_inputField.autocorrectionType = UITextAutocorrectionTypeNo;
		_inputField.returnKeyType = UIReturnKeyDone;
		_inputField.enablesReturnKeyAutomatically = NO;
		_inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
		_inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		_inputField.placeholder = _inputPlaceholderString;
		_inputField.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
		_inputField.delegate = self;
        //resetFrame
		CGRect frame = self.view.bounds;
		frame.size.height -= EDITFIELD_HEIGHT + 10 + TOOL_BUTTON_HEIGHT;
		_consoleView.frame = frame;
		[self.view addSubview:_inputField];
		
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardWillShow:)
//                                                     name:UIKeyboardWillShowNotification
//                                                   object:nil];
//
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardWillHide:)
//                                                     name:UIKeyboardWillHideNotification
//                                                   object:nil];
	}

	[self.consoleView scrollRangeToVisible:NSMakeRange(self.consoleView.text.length, 0)];
    
    //add custom button
#if MAA_OPEN
    NSArray *shortcutNames = [NSArray arrayWithObjects:@"api", @"on", @"dev", @"mo", @"help", @"M:on",nil];
#else
    //NSArray *shortcutNames = [NSArray arrayWithObjects:@"api", @"on", @"dev", @"mo", @"help", nil];
    NSArray *shortcutNames = [NSArray arrayWithObjects:@"api", @"on", @"dev", @"test", @"fps", @"help", nil];
#endif
    for (NSUInteger i=0; i<shortcutNames.count; i++)
    {
        UIButton *shortcutButtons = [UIButton buttonWithType:UIButtonTypeCustom];
        shortcutButtons.exclusiveTouch = YES;
        [shortcutButtons setTitle:shortcutNames[i] forState:UIControlStateNormal];
        [shortcutButtons setTitleColor:_textColor forState:UIControlStateNormal];
        [shortcutButtons setTitleColor:[_textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
        shortcutButtons.backgroundColor = [UIColor bm_colorWithHex:0x666666];
        shortcutButtons.titleLabel.font = [shortcutButtons.titleLabel.font fontWithSize:12];
        shortcutButtons.frame = CGRectMake(6 + (30 + 6)*i,
                                           self.view.frame.size.height - EDITFIELD_HEIGHT - 7,
                                           30, EDITFIELD_HEIGHT);
        [shortcutButtons addTarget:self action:@selector(shortcutAction:) forControlEvents:UIControlEventTouchUpInside];
        shortcutButtons.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self.view addSubview:shortcutButtons];
    }
    
    self.showCommonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.showCommonButton.exclusiveTouch = YES;
    [self.showCommonButton setTitle:@"Umeng环境变量" forState:UIControlStateNormal];
    [self.showCommonButton setTitleColor:_textColor forState:UIControlStateNormal];
    [self.showCommonButton setTitleColor:[_textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    self.showCommonButton.backgroundColor = [UIColor bm_colorWithHex:0x666666];
    self.showCommonButton.titleLabel.font = [self.showCommonButton.titleLabel.font fontWithSize:14];
	self.showCommonButton.frame = CGRectMake(self.inputField.bm_right + 6,
                                              self.view.frame.size.height - EDITFIELD_HEIGHT - 5-TOOL_BUTTON_HEIGHT,
                                              110, EDITFIELD_HEIGHT);
	[self.showCommonButton addTarget:self action:@selector(showCommonAction:) forControlEvents:UIControlEventTouchUpInside];
	self.showCommonButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[self.view addSubview:self.showCommonButton];
    
    self.FLEXButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.FLEXButton.exclusiveTouch = YES;
    [self.FLEXButton setTitle:@"FLEX" forState:UIControlStateNormal];
    [self.FLEXButton setTitleColor:_textColor forState:UIControlStateNormal];
    [self.FLEXButton setTitleColor:[_textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    self.FLEXButton.backgroundColor = [UIColor bm_colorWithHex:0x666666];
#if MAA_OPEN
    self.FLEXButton.titleLabel.font = [self.FLEXButton.titleLabel.font fontWithSize:12];
	self.FLEXButton.frame = CGRectMake(214 + 6,
                                              self.view.frame.size.height - EDITFIELD_HEIGHT - 7,
                                             40, EDITFIELD_HEIGHT);
#else
    self.FLEXButton.titleLabel.font = [self.FLEXButton.titleLabel.font fontWithSize:14];
	self.FLEXButton.frame = CGRectMake(182 + 6,
                                       self.view.frame.size.height - EDITFIELD_HEIGHT - 7,
                                       60, EDITFIELD_HEIGHT);
#endif
	[self.FLEXButton addTarget:self action:@selector(FLEXAction:) forControlEvents:UIControlEventTouchUpInside];
	self.FLEXButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[self.view addSubview:self.FLEXButton];

    self.colorSetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.colorSetButton.exclusiveTouch = YES;
    [self.colorSetButton setTitle:@"视觉" forState:UIControlStateNormal];
    [self.colorSetButton setTitleColor:_textColor forState:UIControlStateNormal];
    [self.colorSetButton setTitleColor:[_textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    self.colorSetButton.backgroundColor = [UIColor bm_colorWithHex:0x666666];
#if MAA_OPEN
    self.colorSetButton.titleLabel.font = [self.colorSetButton.titleLabel.font fontWithSize:12];
	self.colorSetButton.frame = CGRectMake(self.FLEXButton.right + 6,
                                           self.view.frame.size.height - EDITFIELD_HEIGHT - 7,
                                           45, EDITFIELD_HEIGHT);
#else
    self.colorSetButton.titleLabel.font = [self.colorSetButton.titleLabel.font fontWithSize:14];
	self.colorSetButton.frame = CGRectMake(self.FLEXButton.bm_right + 6,
                                           self.view.frame.size.height - EDITFIELD_HEIGHT - 7,
                                           60, EDITFIELD_HEIGHT);
#endif
	[self.colorSetButton addTarget:self action:@selector(colorSetAction:) forControlEvents:UIControlEventTouchUpInside];
	self.colorSetButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[self.view addSubview:self.colorSetButton];
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

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//- (void)viewDidUnload
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//    
//    self.consoleView = nil;
//    self.inputField = nil;
//    self.actionButton = nil;
//    
//    [super viewDidUnload];
//}


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
    if ([self sharedConsole].logLevel > iConsoleLogLevelNone)
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
    if ([self sharedConsole].logLevel >= iConsoleLogLevelInfo)
    {
        [self log:[@"INFO: " stringByAppendingString:format] args:argList];
    }
}

+ (void)warn:(NSString *)format args:(va_list)argList
{
	if ([self sharedConsole].logLevel >= iConsoleLogLevelWarning)
    {
        [self log:[@"WARNING: " stringByAppendingString:format] args:argList];
    }
}

+ (void)error:(NSString *)format args:(va_list)argList
{
    if ([self sharedConsole].logLevel >= iConsoleLogLevelError)
    {
        [self log:[@"ERROR: " stringByAppendingString:format] args:argList];
    }
}

+ (void)crash:(NSString *)format args:(va_list)argList
{
    if ([self sharedConsole].logLevel >= iConsoleLogLevelCrash)
    {
        [self log:[@"CRASH: " stringByAppendingString:format] args:argList];
    }
}

+ (void)clean
{
	[[iConsole sharedConsole] clearSettings];
	[[iConsole sharedConsole] resetLog];
}

+ (void)clear
{
	[[iConsole sharedConsole] resetLog];
}

+ (void)show
{
	[[iConsole sharedConsole] showConsole];
}

+ (void)hide
{
	[[iConsole sharedConsole] hideConsole];
}

@end


@implementation iConsoleWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        YYFPSLabel *fpsLabel = [[YYFPSLabel alloc] init];
        [self addSubview:fpsLabel];
        fpsLabel.bm_left = self.bm_left+6;
        fpsLabel.bm_top = self.bm_top+6+UI_NAVIGATION_BAR_HEIGHT+UI_STATUS_BAR_HEIGHT;
        //fpsLabel.center = self.center;
        self.fpsLabel = fpsLabel;
    }
    return self;
}

- (void)sendEvent:(UIEvent *)event
{
	if ([iConsole sharedConsole].enabled && event.type == UIEventTypeTouches)
	{
		NSSet *touches = [event allTouches];
		if ([touches count] == (TARGET_IPHONE_SIMULATOR ? [iConsole sharedConsole].simulatorTouchesToShow: [iConsole sharedConsole].deviceTouchesToShow))
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
						[iConsole show];
					}
					else if (allDown)
					{
						[iConsole hide];
					}
					break;
                }
				case UIInterfaceOrientationPortraitUpsideDown:
                {
					if (allDown)
					{
						[iConsole show];
					}
					else if (allUp)
					{
						[iConsole hide];
					}
					break;
                }
				case UIInterfaceOrientationLandscapeLeft:
                {
					if (allRight)
					{
						[iConsole show];
					}
					else if (allLeft)
					{
						[iConsole hide];
					}
					break;
                }
				case UIInterfaceOrientationLandscapeRight:
                {
					if (allLeft)
					{
						[iConsole show];
					}
					else if (allRight)
					{
						[iConsole hide];
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

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if ([iConsole sharedConsole].enabled &&
        (TARGET_IPHONE_SIMULATOR ? [iConsole sharedConsole].simulatorShakeToShow: [iConsole sharedConsole].deviceShakeToShow))
    {
        if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake)
        {
            if ([iConsole sharedConsole].view.superview == nil)
            {
                [iConsole show];
            }
            else
            {
                [iConsole hide];
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

@end

#endif

