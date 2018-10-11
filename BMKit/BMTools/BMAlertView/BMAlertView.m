//
//  BMAlertView.m
//  ODR
//
//  Created by jiang deng on 2018/7/10.
//  Copyright © 2018年 DJ. All rights reserved.
//
//  || https://github.com/alexanderjarvis/PXAlertView

#import "BMAlertView.h"


static const CGFloat BMAlertViewWidth = 270.0f;
static const CGFloat BMAlertViewContentMargin = 30.0f;
static const CGFloat BMAlertViewVerticalElementSpace = 12.0f;
static const CGFloat BMAlertViewIconWidth = 90.0f;
static const CGFloat BMAlertViewIconHeight = 90.0f;
static const CGFloat BMAlertViewButtonHeight = 40.0f;
static const CGFloat BMAlertViewLineLayerHeight = 1.0f;
static const CGFloat BMAlertViewVerticalEdgeMinMargin = 25.0f;

#define BMAlertViewMarkBgDefaultEffect  [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]

#define BMAlertViewMarkBgColor          [UIColor colorWithWhite:0 alpha:0.25]
#define BMAlertViewBgColor              [UIColor colorWithWhite:0.9 alpha:1]

#define BMAlertViewTitleColor           [UIColor colorWithWhite:0 alpha:1];
#define BMAlertViewTitleFont            [UIFont systemFontOfSize:16.0f];
#define BMAlertViewMessageColor         [UIColor colorWithWhite:0.2 alpha:1];
#define BMAlertViewMessageFont          [UIFont systemFontOfSize:14.0f];
#define BMAlertViewGapLineColor         [UIColor colorWithWhite:0.8 alpha:1];

#define BMAlertViewCancleBtnBgColor     BMAlertViewBgColor
#define BMAlertViewOtherBtnBgColor      BMAlertViewBgColor
#define BMAlertViewCancleBtnTextColor   [UIColor blueColor]
#define BMAlertViewOtherBtnTextColor    [UIColor blueColor]
#define BMAlertViewBtnFont              [UIFont systemFontOfSize:16.0f];

@interface BMAlertViewStack ()

@property (nonatomic) NSMutableArray *alertViews;

- (void)push:(BMAlertView *)alertView;
- (void)pop:(BMAlertView *)alertView;

@end

@interface BMAlertView ()
<
    UIScrollViewDelegate
>

@property (nonatomic, assign, getter=isVisible) BOOL visible;

@property (nonatomic, weak) UIWindow *mainWindow;

@property (nonatomic, strong) UIWindow *alertWindow;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIVisualEffectView *alertMarkBgEffectView;
@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, strong) UIButton *topRightCloseBtn;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *messageScrollView;
@property (nonatomic, strong) CAGradientLayer *messageScrollGradient;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIView *buttonBgView;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *lineLayerArray;

@property (nonatomic, assign) BOOL buttonsShouldStack;

@property (nonatomic) UITapGestureRecognizer *tapOutside;

@end

@implementation BMAlertView
@synthesize alertMarkBgColor = _alertMarkBgColor;
@synthesize alertBgColor = _alertBgColor;
@synthesize alertTitleColor = _alertTitleColor;
@synthesize alertTitleFont = _alertTitleFont;
@synthesize alertMessageColor = _alertMessageColor;
@synthesize alertMessageFont = _alertMessageFont;
@synthesize buttonHeight = _buttonHeight;
@synthesize alertGapLineColor = _alertGapLineColor;
@synthesize cancleBtnBgColor = _cancleBtnBgColor;
@synthesize otherBtnBgColor = _otherBtnBgColor;
@synthesize cancleBtnTextColor = _cancleBtnTextColor;
@synthesize otherBtnTextColor = _otherBtnTextColor;
@synthesize btnFont = _btnFont;

- (void)dealloc
{
    //NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //[center removeObserver:self];
}

- (UIWindow *)windowWithLevel:(UIWindowLevel)windowLevel
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows)
    {
        if (window.windowLevel == windowLevel)
        {
            return window;
        }
    }
    return nil;
}

- (instancetype)initWithIcon:(NSString *)iconName
                       title:(id)title
                     message:(id)message
                 contentView:(UIView *)contentView
                 cancelTitle:(nullable NSString *)cancelTitle
                 otherTitles:(NSArray<NSString *> *)otherTitles
          buttonsShouldStack:(BOOL)shouldStack
                  completion:(BMAlertViewCompletionBlock)completion
{
    self = [super init];
    if (self)
    {
        self.mainWindow = [self windowWithLevel:UIWindowLevelNormal];
        
        self.alertWindow = [self windowWithLevel:UIWindowLevelAlert];
        
        if (!self.alertWindow)
        {
            self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.alertWindow.windowLevel = UIWindowLevelAlert;
            self.alertWindow.backgroundColor = [UIColor clearColor];
        }
        
        self.shouldDismissOnTapOutside = YES;
        
        self.showAnimationType = BMAlertViewShowAnimationFadeIn;
        self.hideAnimationType = BMAlertViewHideAnimationFadeOut;
        
        CGRect frame = [self frameForOrientation];
        self.view.frame = frame;
        
        self.iconName = iconName;
        
        if ([title isKindOfClass:[NSString class]])
        {
            self.alertTitle = title;
        }
        else if ([title isKindOfClass:[NSMutableAttributedString class]])
        {
            self.alertTitleAttrStr = title;
        }
        
        if ([message isKindOfClass:[NSString class]])
        {
            self.alertMessage = message;
        }
        else if ([message isKindOfClass:[NSMutableAttributedString class]])
        {
            self.alertMessageAttrStr = message;
        }
        
        self.contentView = contentView;
        
        self.completion = completion;
        
        NSMutableArray *btnTitles = [NSMutableArray array];
        if (cancelTitle)
        {
            [btnTitles addObject:cancelTitle];
        }
        else
        {
            [btnTitles addObject:NSLocalizedString(@"确定", nil)];
        }
        if (otherTitles.count)
        {
            [btnTitles addObjectsFromArray:otherTitles];
        }
        
        self.buttonArray = [NSMutableArray arrayWithCapacity:btnTitles.count];
        self.lineLayerArray = [NSMutableArray arrayWithCapacity:btnTitles.count];
        
        self.alertMarkBgEffect = BMAlertViewMarkBgDefaultEffect;
        self.alertMarkBgEffectView = [[UIVisualEffectView alloc] initWithEffect:self.alertMarkBgEffect];
        self.alertMarkBgEffectView.alpha = 0.8f;
        self.alertMarkBgEffectView.backgroundColor = [UIColor clearColor];
        self.alertMarkBgEffectView.frame = self.view.bounds;
        [self.view addSubview:self.alertMarkBgEffectView];
        
        self.backgroundView = [[UIView alloc] initWithFrame:frame];
        self.backgroundView.backgroundColor = self.alertMarkBgColor;
        [self.view addSubview:self.backgroundView];
        
        //CGFloat space = (self.contentView == nil)? AlertViewVerticalElementSpace:0;
        CGFloat alertWidth = (self.contentView == nil) ? BMAlertViewWidth : self.contentView.bm_width;
        
        self.alertView = [[UIView alloc] init];
        self.alertView.bm_width = alertWidth;
        self.alertView.backgroundColor = self.alertBgColor;
        self.alertView.layer.cornerRadius = 8.0;
        self.alertView.layer.opacity = 0.95;
        self.alertView.clipsToBounds = YES;
        [self.view addSubview:self.alertView];

        self.topRightCloseBtn = [UIButton bm_buttonWithFrame:CGRectMake(alertWidth-40.0f, 6.0f, 40.0f, 40.0f) imageName:@"community_close"];
        self.topRightCloseBtn.bm_imageRect = CGRectMake(15.0f, 5.0f, 15.0f, 15.0f);
        [self.topRightCloseBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        self.topRightCloseBtn.enabled = self.shouldDismissOnTapOutside;
        [self.alertView addSubview:self.topRightCloseBtn];
        
        self.showClose = NO;
        
        // icon
        self.iconImageView = [[UIImageView alloc] init];
        [self.alertView addSubview:self.iconImageView];
        
        // Title
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(BMAlertViewContentMargin, 0, alertWidth - BMAlertViewContentMargin * 2, 10)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 0;
        [self.alertView addSubview:self.titleLabel];
        
        // Optional Content View
        if (contentView)
        {
            self.contentView = contentView;
            [self.alertView addSubview:self.contentView];
        }
        
        // Message
        self.messageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(BMAlertViewContentMargin, 0, alertWidth - BMAlertViewContentMargin * 2, 10)];
        self.messageScrollView.scrollEnabled = YES;
        self.messageScrollView.delegate = self;
        
        self.messageLabel = [[UILabel alloc] initWithFrame:(CGRect){0, 0, self.messageScrollView.frame.size}];
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.messageLabel.numberOfLines = 0;
        [self.messageScrollView addSubview:self.messageLabel];
        
        [self.alertView addSubview:self.messageScrollView];

        self.messageScrollGradient = [CAGradientLayer layer];
        self.messageScrollGradient.startPoint = CGPointMake(0, 1.0);
        self.messageScrollGradient.endPoint = CGPointMake(0, 0);
        [self.alertView.layer addSublayer:self.messageScrollGradient];
        
        // Buttons
        self.buttonsShouldStack = shouldStack;
        
        self.buttonBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertWidth, 10.0f)];
        self.buttonBgView.backgroundColor = [UIColor clearColor];
        [self.alertView addSubview:self.buttonBgView];
        
        [self addButtonWithTitles:btnTitles];
        
        [self setupGestures];
        
        //NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        //[center addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
        //[center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (CGPoint)centerWithFrame:(CGRect)frame
{
    return CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) - [self statusBarOffset]);
}

- (CGFloat)statusBarOffset
{
    CGFloat statusBarOffset = 0;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        statusBarOffset = 20.0f;
    }
    return statusBarOffset;
}

- (CGRect)frameForOrientation
{
    UIWindow *window = [[UIApplication sharedApplication].windows count] > 0 ? [[UIApplication sharedApplication].windows objectAtIndex:0] : nil;
    if (!window)
    {
        window = [UIApplication sharedApplication].keyWindow;
    }
    
    if (window)
    {
        return window.bounds;
    }
//    if ([[window subviews] count] > 0)
//    {
//        return [[[window subviews] objectAtIndex:0] bounds];
//    }

    return [[self windowWithLevel:UIWindowLevelNormal] bounds];
}

- (CGRect)adjustLabelFrameHeight:(UILabel *)label
{
    CGFloat height = [label bm_calculatedHeight];
    
    return CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, height);
}

- (void)setupGestures
{
    self.tapOutside = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [self.tapOutside setNumberOfTapsRequired:1];
    self.tapOutside.enabled = self.shouldDismissOnTapOutside;

    self.backgroundView.userInteractionEnabled = YES;
    self.backgroundView.multipleTouchEnabled = NO;
    self.backgroundView.exclusiveTouch = YES;
    [self.backgroundView addGestureRecognizer:self.tapOutside];
}

- (UIButton *)genericButton:(NSUInteger)btnIndex
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor blueColor] colorByDarkeningTo:0.8f] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(setBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(setBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragEnter];
    [button addTarget:self action:@selector(clearBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    button.exclusiveTouch = YES;
    button.tag = btnIndex;
    return button;
}

- (void)setBackgroundColorForButton:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        [sender setBackgroundColor:[self.cancleBtnBgColor colorByDarkeningTo:0.8f]];
    }
    else
    {
        [sender setBackgroundColor:[self.otherBtnBgColor colorByDarkeningTo:0.8f]];
    }
    sender.highlighted = YES;
}

- (void)clearBackgroundColorForButton:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        [sender setBackgroundColor:self.cancleBtnBgColor];
    }
    else
    {
        [sender setBackgroundColor:self.otherBtnBgColor];
    }
    sender.highlighted = NO;
}

- (CALayer *)addLineLayer
{
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = self.alertGapLineColor.CGColor;
    [self.lineLayerArray addObject:lineLayer];
    [self.buttonBgView.layer addSublayer:lineLayer];
    return lineLayer;
}

- (void)addButtonWithTitles:(NSArray *)titles
{
    NSUInteger index = 0;
    for (NSString *btnTitle in titles)
    {
        [self addLineLayer];
        
        UIButton *button = [self genericButton:index];
        [button setTitle:btnTitle forState:UIControlStateNormal];
        [self.buttonArray addObject:button];
        [self.buttonBgView addSubview:button];
        index++;
    }
}

- (CGFloat)freshButtons
{
    if (self.buttonArray.count == 1)
    {
        CALayer *lineLayer = self.lineLayerArray[0];
        lineLayer.frame = CGRectMake(0, 0, self.buttonBgView.bm_width, BMAlertViewLineLayerHeight);
        lineLayer.backgroundColor = self.alertGapLineColor.CGColor;
        UIButton *button = self.buttonArray[0];
        button.frame = CGRectMake(0, BMAlertViewLineLayerHeight, self.buttonBgView.bm_width, self.buttonHeight);
        button.backgroundColor = self.cancleBtnBgColor;
        button.titleLabel.font = self.btnFont;
        [button setTitleColor:self.cancleBtnTextColor forState:UIControlStateNormal];
        [button setTitleColor:[self.cancleBtnTextColor colorByDarkeningTo:0.8f] forState:UIControlStateHighlighted];
        
        return BMAlertViewLineLayerHeight + self.buttonHeight;
    }
    else if (!self.buttonsShouldStack && self.buttonArray.count == 2)
    {
        CALayer *lineLayer = self.lineLayerArray[0];
        lineLayer.frame = CGRectMake(0, 0, self.buttonBgView.bm_width, BMAlertViewLineLayerHeight);
        lineLayer.backgroundColor = self.alertGapLineColor.CGColor;
        
        CALayer *verticalLine = self.lineLayerArray[1];
        verticalLine.frame = CGRectMake((self.buttonBgView.bm_width - BMAlertViewLineLayerHeight) * 0.5, 0, BMAlertViewLineLayerHeight, self.buttonHeight);
        verticalLine.backgroundColor = self.alertGapLineColor.CGColor;
        
        UIButton *button = self.buttonArray[0];
        button.frame = CGRectMake(0, BMAlertViewLineLayerHeight, (self.buttonBgView.bm_width - BMAlertViewLineLayerHeight) * 0.5, self.buttonHeight);
        button.backgroundColor = self.cancleBtnBgColor;
        button.titleLabel.font = self.btnFont;
        [button setTitleColor:self.cancleBtnTextColor forState:UIControlStateNormal];
        [button setTitleColor:[self.cancleBtnTextColor colorByDarkeningTo:0.8f] forState:UIControlStateHighlighted];
        
        button = self.buttonArray[1];
        button.frame = CGRectMake((self.buttonBgView.bm_width + BMAlertViewLineLayerHeight) * 0.5, BMAlertViewLineLayerHeight, (self.buttonBgView.bm_width - BMAlertViewLineLayerHeight) * 0.5, self.buttonHeight);
        button.backgroundColor = self.otherBtnBgColor;
        button.titleLabel.font = self.btnFont;
        [button setTitleColor:self.otherBtnTextColor forState:UIControlStateNormal];
        [button setTitleColor:[self.otherBtnTextColor colorByDarkeningTo:0.8f] forState:UIControlStateHighlighted];
        
        return BMAlertViewLineLayerHeight + self.buttonHeight;
    }
    else if (self.buttonArray.count > 1)
    {
        NSUInteger index = 0;
        for (UIButton *button in self.buttonArray)
        {
            CGFloat top = (BMAlertViewLineLayerHeight + self.buttonHeight) * index;
            
            CALayer *lineLayer = self.lineLayerArray[index];
            lineLayer.frame = CGRectMake(0, top, self.buttonBgView.bm_width, BMAlertViewLineLayerHeight);
            lineLayer.backgroundColor = self.alertGapLineColor.CGColor;
            
            button.frame = CGRectMake(0, BMAlertViewLineLayerHeight + top, self.buttonBgView.bm_width, self.buttonHeight);
            if (index == 0)
            {
                button.backgroundColor = self.cancleBtnBgColor;
                button.titleLabel.font = self.btnFont;
                [button setTitleColor:self.cancleBtnTextColor forState:UIControlStateNormal];
                [button setTitleColor:[self.cancleBtnTextColor colorByDarkeningTo:0.8f] forState:UIControlStateHighlighted];
            }
            else
            {
                button.backgroundColor = self.otherBtnBgColor;
                button.titleLabel.font = self.btnFont;
                [button setTitleColor:self.otherBtnTextColor forState:UIControlStateNormal];
                [button setTitleColor:[self.otherBtnTextColor colorByDarkeningTo:0.8f] forState:UIControlStateHighlighted];
            }
            
            index++;
        }
        
        return (BMAlertViewLineLayerHeight + self.buttonHeight) * self.buttonArray.count;
    }
    
    return 0;
}

- (void)freshAlertView
{
    self.alertMarkBgEffectView.effect = self.alertMarkBgEffect;
    //self.alertMarkBgEffectView.backgroundColor = self.alertMarkBgColor;
    self.backgroundView.backgroundColor = self.alertMarkBgColor;
    self.alertView.backgroundColor = self.alertBgColor;
    
    CGFloat space = BMAlertViewVerticalElementSpace;
    CGFloat alertWidth = self.alertView.bm_width;
    
    self.topRightCloseBtn.bm_left = alertWidth-40.0f;
    
    CGFloat iconWidth = 0;
    CGFloat iconHeight = 0;
    
    if (self.iconName)
    {
        iconWidth = BMAlertViewIconWidth;
        iconHeight = BMAlertViewIconHeight;
        
        self.iconImageView.image = [UIImage imageNamed:self.iconName];
        self.iconImageView.frame = CGRectMake((alertWidth - iconWidth) * 0.5, space, iconWidth, iconHeight);
        self.titleLabel.bm_top = space + iconHeight + space;
    }
    else
    {
        self.iconImageView.image = nil;
        self.titleLabel.bm_top = space;
    }
    
    if (self.alertTitleAttrStr)
    {
        self.titleLabel.attributedText = self.alertTitleAttrStr;
    }
    else
    {
        self.titleLabel.text = self.alertTitle;
    }
    self.titleLabel.textColor = self.alertTitleColor;
    self.titleLabel.font = self.alertTitleFont;
    self.titleLabel.frame = [self adjustLabelFrameHeight:self.titleLabel];
    
    CGFloat messageLabelTop = self.titleLabel.bm_bottom + space;
    
    // Optional Content View
    if (self.contentView)
    {
        self.contentView.bm_top = messageLabelTop;
        messageLabelTop = self.contentView.bm_bottom + space;
    }
    
    // Message
    self.messageScrollView.bm_top = messageLabelTop;
    
    if (self.alertMessageAttrStr)
    {
        self.messageLabel.attributedText = self.alertMessageAttrStr;
    }
    else
    {
        self.messageLabel.text = self.alertMessage;
    }
    self.messageLabel.textColor = self.alertMessageColor;
    self.messageLabel.font = self.alertMessageFont;
    self.messageLabel.frame = [self adjustLabelFrameHeight:self.messageLabel];
    self.messageScrollView.contentSize = self.messageLabel.frame.size;
    
    // Get total button height
    self.tapOutside.enabled = self.shouldDismissOnTapOutside;
    
    CGFloat totalButonHeight = [self freshButtons];
    
    CGFloat margin = BMAlertViewVerticalEdgeMinMargin;
    if (IS_IPHONE5 || IS_IPHONE6 || IS_IPHONEX)
    {
        margin *= 2;
    }
    else if (IS_IPHONE6P || IS_IPHONEXP)
    {
        margin *= 3;
    }
    
    CGRect scrollViewFrame = (CGRect){
        self.messageScrollView.frame.origin,
        self.messageScrollView.frame.size.width,
        MIN(self.messageLabel.frame.size.height, self.alertWindow.frame.size.height - self.messageScrollView.frame.origin.y - totalButonHeight - margin * 2)};
    self.messageScrollView.frame = scrollViewFrame;
    if (self.messageScrollView.bm_height < self.messageLabel.bm_height)
    {
        self.messageScrollGradient.hidden = NO;
        self.messageScrollGradient.frame = CGRectMake(self.messageScrollView.bm_left, self.messageScrollView.bm_bottom-30.0f, self.messageScrollView.bm_width, 30.0f);
        UIColor *starColor = self.alertBgColor;
        UIColor *endColor = [self.alertBgColor changeAlpha:0.4f];
        self.messageScrollGradient.colors = [NSArray arrayWithObjects: (id)starColor.CGColor, (id)endColor.CGColor, nil];
    }
    else
    {
        self.messageScrollGradient.hidden = YES;
    }
    
    self.buttonBgView.bm_top = BMAlertViewVerticalElementSpace + self.messageScrollView.bm_bottom;
    self.buttonBgView.bm_height = totalButonHeight;
    
    self.alertView.bm_height = self.buttonBgView.bm_bottom;
    self.alertView.center = [self centerWithFrame:self.alertMarkBgEffectView.bounds];
}

- (void)centerAlertView
{
    CGRect frame = [self frameForOrientation];
    self.alertMarkBgEffectView.frame = frame;
    self.backgroundView.frame = frame;
    self.alertView.center = [self centerWithFrame:frame];
}


#pragma mark -
#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self freshAlertView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShown:(NSNotification *)notification
{
    //if (self.isVisible)
    {
        CGRect keyboardFrameBeginRect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8 && (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight))
        {
            keyboardFrameBeginRect = (CGRect){keyboardFrameBeginRect.origin.y, keyboardFrameBeginRect.origin.x, keyboardFrameBeginRect.size.height, keyboardFrameBeginRect.size.width};
        }
#pragma clang diagnostic pop
        CGRect interfaceFrame = [self frameForOrientation];
        
        if (interfaceFrame.size.height - keyboardFrameBeginRect.size.height <= self.alertView.frame.size.height + self.alertView.frame.origin.y)
        {
            [UIView animateWithDuration:.35
                                  delay:0
                                options:0x70000
                             animations:^(void) {
                                 self.alertView.frame = (CGRect){self.alertView.frame.origin.x, interfaceFrame.size.height - keyboardFrameBeginRect.size.height - self.alertView.frame.size.height - 20, self.alertView.frame.size};
                             }
                             completion:nil];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    //if (self.isVisible)
    {
        [UIView animateWithDuration:.35
                              delay:0
                            options:0x70000
                         animations:^(void) {
                             self.alertView.center = [self centerWithFrame:[self frameForOrientation]];
                             
                         }
                         completion:nil];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return [UIApplication sharedApplication].statusBarHidden;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;  //UIInterfaceOrientationMaskAll;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return YES;
//}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        BMLog(@"转屏前调入");
    }
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                                     BMLog(@"转屏后调入");
                                     
                                     [self centerAlertView];
                                     
                                 }];

    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
//{
//    [self centerAlertView];
//}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= self.messageScrollView.contentSize.height-self.messageScrollView.bm_height)
    {
        self.messageScrollGradient.hidden = YES;
    }
    else
    {
        self.messageScrollGradient.hidden = NO;
    }
}


#pragma mark -
#pragma mark property

- (void)setAlertMarkBgEffect:(UIVisualEffect *)alertMarkBgEffect
{
    _alertMarkBgEffect = alertMarkBgEffect;
    
    self.alertMarkBgEffectView.effect = alertMarkBgEffect;
}

- (void)setAlertTitle:(NSString *)alertTitle
{
    _alertTitle = alertTitle;
    _alertTitleAttrStr = nil;

    [self freshAlertView];
}

- (void)setAlertMessage:(NSString *)alertMessage
{
    _alertMessage = alertMessage;
    _alertMessageAttrStr = nil;

    [self freshAlertView];
}

- (void)setAlertTitleAttrStr:(NSMutableAttributedString *)alertTitleAttrStr
{
    _alertTitleAttrStr = alertTitleAttrStr;
    
    [self freshAlertView];
}

- (void)setAlertMessageAttrStr:(NSMutableAttributedString *)alertMessageAttrStr
{
    _alertMessageAttrStr = alertMessageAttrStr;
    
    [self freshAlertView];
}

- (void)setShowClose:(BOOL)showClose
{
    _showClose = showClose;
    
    self.topRightCloseBtn.hidden = !showClose;
}

- (void)setShouldDismissOnTapOutside:(BOOL)shouldDismissOnTapOutside
{
    _shouldDismissOnTapOutside = shouldDismissOnTapOutside;
    self.tapOutside.enabled = shouldDismissOnTapOutside;
    self.topRightCloseBtn.enabled = shouldDismissOnTapOutside;
}

- (UIColor *)alertMarkBgColor
{
    if (!_alertMarkBgColor)
    {
        return BMAlertViewMarkBgColor;
    }
    
    return _alertMarkBgColor;
}

- (void)setAlertMarkBgColor:(UIColor *)alertMarkBgColor
{
    alertMarkBgColor = _alertMarkBgColor;
    
    self.backgroundView.backgroundColor = alertMarkBgColor;
}

- (UIColor *)alertBgColor
{
    if (!_alertBgColor)
    {
        return BMAlertViewBgColor;
    }
    
    return _alertBgColor;
}

- (void)setAlertBgColor:(UIColor *)alertBgColor
{
    _alertBgColor = alertBgColor;
    
    self.alertView.backgroundColor = alertBgColor;
}

- (UIColor *)alertTitleColor
{
    if (!_alertTitleColor)
    {
        return BMAlertViewTitleColor;
    }
    
    return _alertTitleColor;
}

- (void)setAlertTitleColor:(UIColor *)alertTitleColor
{
    _alertTitleColor = alertTitleColor;
    
    self.titleLabel.textColor = alertTitleColor;
}

- (UIFont *)alertTitleFont
{
    if (!_alertTitleFont)
    {
        return BMAlertViewTitleFont;
    }
    
    return _alertTitleFont;
}

- (void)setAlertTitleFont:(UIFont *)alertTitleFont
{
    _alertTitleFont = alertTitleFont;
    
    [self freshAlertView];
}

- (UIColor *)alertMessageColor
{
    if (!_alertMessageColor)
    {
        return BMAlertViewMessageColor;
    }
    
    return _alertMessageColor;
}

- (void)setAlertMessageColor:(UIColor *)alertMessageColor
{
    _alertMessageColor = alertMessageColor;
    
    self.messageLabel.textColor = alertMessageColor;
}

- (UIFont *)alertMessageFont
{
    if (!_alertMessageFont)
    {
        return BMAlertViewMessageFont;
    }
    
    return _alertMessageFont;
}

- (void)setAlertMessageFont:(UIFont *)alertMessageFont
{
    _alertMessageFont = alertMessageFont;
    
    [self freshAlertView];
}

- (CGFloat)buttonHeight
{
    if (_buttonHeight < BMAlertViewButtonHeight)
    {
        _buttonHeight = BMAlertViewButtonHeight;
    }
    
    return _buttonHeight;
}

- (void)setButtonHeight:(CGFloat)buttonHeight
{
    _buttonHeight = buttonHeight;
 
    [self freshAlertView];
}

- (UIColor *)alertGapLineColor
{
    if (!_alertGapLineColor)
    {
        return BMAlertViewGapLineColor;
    }
    
    return _alertGapLineColor;
}

- (void)setAlertGapLineColor:(UIColor *)alertGapLineColor
{
    _alertGapLineColor = alertGapLineColor;
    
    for (CALayer *lineLayer in self.lineLayerArray)
    {
        lineLayer.backgroundColor = alertGapLineColor.CGColor;
    }
}

- (UIColor *)cancleBtnBgColor
{
    if (!_cancleBtnBgColor)
    {
        return BMAlertViewCancleBtnBgColor;
    }
    
    return _cancleBtnBgColor;
}

- (void)setCancleBtnBgColor:(UIColor *)cancleBtnBgColor
{
    _cancleBtnBgColor = cancleBtnBgColor;
    
    if (self.buttonArray.count)
    {
        UIButton *button = self.buttonArray[0];
        
        button.backgroundColor = cancleBtnBgColor;
    }
}

- (UIColor *)otherBtnBgColor
{
    if (!_otherBtnBgColor)
    {
        return BMAlertViewOtherBtnBgColor;
    }
    
    return _otherBtnBgColor;
}

- (void)setOtherBtnBgColor:(UIColor *)otherBtnBgColor
{
    _otherBtnBgColor = otherBtnBgColor;
    
    for (NSUInteger index=1; index<self.buttonArray.count; index++)
    {
        UIButton *button = self.buttonArray[index];
        
        button.backgroundColor = otherBtnBgColor;
    }
}

- (UIColor *)cancleBtnTextColor
{
    if (!_cancleBtnTextColor)
    {
        return BMAlertViewCancleBtnTextColor;
    }
    
    return _cancleBtnTextColor;
}

- (void)setCancleBtnTextColor:(UIColor *)cancleBtnTextColor
{
    _cancleBtnTextColor = cancleBtnTextColor;
    
    if (self.buttonArray.count)
    {
        UIButton *button = self.buttonArray[0];
        
        [button setTitleColor:cancleBtnTextColor forState:UIControlStateNormal];
        [button setTitleColor:[cancleBtnTextColor colorByDarkeningTo:0.8f] forState:UIControlStateHighlighted];
    }
}

- (UIColor *)otherBtnTextColor
{
    if (!_otherBtnTextColor)
    {
        return BMAlertViewOtherBtnTextColor;
    }
    
    return _otherBtnTextColor;
}

- (void)setOtherBtnTextColor:(UIColor *)otherBtnTextColor
{
    _otherBtnTextColor = otherBtnTextColor;
    
    for (NSUInteger index=1; index<self.buttonArray.count; index++)
    {
        UIButton *button = self.buttonArray[index];
        
        [button setTitleColor:otherBtnTextColor forState:UIControlStateNormal];
        [button setTitleColor:[otherBtnTextColor colorByDarkeningTo:0.8f] forState:UIControlStateHighlighted];
    }
}

- (UIFont *)btnFont
{
    if (!_btnFont)
    {
        return BMAlertViewBtnFont;
    }
    
    return _btnFont;
}

- (void)setBtnFont:(UIFont *)btnFont
{
    _btnFont = btnFont;
    
    for (UIButton *button in self.buttonArray)
    {
        button.titleLabel.font = btnFont;
    }
}


#pragma mark -
#pragma mark func

- (void)show
{
    [[BMAlertViewStack sharedInstance] push:self];
}

- (void)showInternal
{
    self.alertWindow.rootViewController = self;
    [self.alertWindow makeKeyAndVisible];
    
    switch (self.showAnimationType)
    {
        case BMAlertViewShowAnimationFadeIn:
            [self fadeIn];
            break;
            
        case BMAlertViewShowAnimationSlideInFromBottom:
            [self slideInFromBottom];
            break;
            
        case BMAlertViewShowAnimationSlideInFromTop:
            [self slideInFromTop];
            break;
            
        case BMAlertViewShowAnimationSlideInFromLeft:
            [self slideInFromLeft];
            break;
            
        case BMAlertViewShowAnimationSlideInFromRight:
            [self slideInFromRight];
            break;
            
        default:
            [self showCompletion];
            break;
    }
}

- (void)showCompletion
{
    self.alertWindow.alpha = 1;
    
    self.visible = YES;
    
    [self showAlertAnimation];
}

- (void)hide
{
    if (self.alertWindow.rootViewController == self)
    {
        self.alertWindow.rootViewController = nil;
    }
}

- (void)dismiss:(id)sender
{
    [self dismiss:sender animated:YES];
}

- (void)doCompletion:(id)sender
{
    BOOL cancelled = NO;
    if (sender == self.tapOutside || self.topRightCloseBtn || (self.buttonArray.count > 0 && sender == self.buttonArray[0]))
    {
        cancelled = YES;
    }
    NSInteger buttonIndex = -1;
    if (sender && sender != self.tapOutside && sender != self.topRightCloseBtn && self.buttonArray.count)
    {
        NSUInteger index = [self.buttonArray indexOfObject:sender];
        if (index != NSNotFound)
        {
            buttonIndex = index;
            [self clearBackgroundColorForButton:sender];
        }
    }
    self.completion(cancelled, buttonIndex);
}

- (void)dismissCompletion:(id)sender
{
    self.alertWindow.alpha = 0;
    
    if (self.completion)
    {
        [self doCompletion:sender];
    }
    
    if ([[BMAlertViewStack sharedInstance] getAlertViewCount] == 1)
    {
        //[self dismissAlertAnimation];
        
        self.alertWindow.rootViewController = nil;
        self.alertWindow = nil;
        
        [self.mainWindow makeKeyAndVisible];
    }
    
    [[BMAlertViewStack sharedInstance] pop:self];
}

- (void)dismiss:(id)sender animated:(BOOL)animated
{
    if (self.notDismissOnCancel)
    {
        self.visible = YES;
        
        if (self.completion)
        {
            [self doCompletion:sender];
        }
        
        return;
    }
    
    self.visible = NO;
    
    if (animated)
    {
        switch (self.hideAnimationType)
        {
            case BMAlertViewHideAnimationFadeOut:
                [self fadeOut:sender];
                break;
                
            case BMAlertViewHideAnimationSlideOutToBottom:
                [self slideOutToBottom:sender];
                break;
                
            case BMAlertViewHideAnimationSlideOutToTop:
                [self slideOutToTop:sender];
                break;
                
            case BMAlertViewHideAnimationSlideOutToLeft:
                [self slideOutToLeft:sender];
                break;
                
            case BMAlertViewHideAnimationSlideOutToRight:
                [self slideOutToRight:sender];
                break;
                
            default:
                [self dismissCompletion:sender];
                break;
        }
    }
    else
    {
        [self dismissCompletion:sender];
    }
}

- (void)showAlertAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[ [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)] ];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.3;
    
    [self.alertView.layer addAnimation:animation forKey:@"showAlert"];
}

- (void)dismissAlertAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[ [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)] ];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeRemoved;
    animation.duration = 0.2;
    
    [self.alertView.layer addAnimation:animation forKey:@"dismissAlert"];
}


#pragma mark -
#pragma mark Show Animations

- (void)fadeIn
{
    self.alertWindow.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.alertWindow.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         [self showCompletion];
                     }];
}

- (void)slideInFromBottom
{
    self.alertWindow.alpha = 1.0f;
    
    //From Frame
    CGRect frame = [self frameForOrientation];
    self.alertView.bm_top = frame.size.height;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         //To Frame
                         [self centerAlertView];
                         
                     }
                     completion:^(BOOL completed) {
                         [self showCompletion];
                     }];
}

- (void)slideInFromTop
{
    self.alertWindow.alpha = 1.0f;
    //From Frame
    self.alertView.bm_top = -self.alertView.bm_height;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         //To Frame
                         [self centerAlertView];
                         
                     }
                     completion:^(BOOL completed) {
                         [self showCompletion];
                     }];
}

- (void)slideInFromLeft
{
    self.alertWindow.alpha = 1.0f;
    //From Frame
    self.alertView.bm_left = -self.alertView.bm_width;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         //To Frame
                         [self centerAlertView];
                         
                     }
                     completion:^(BOOL completed) {
                         [self showCompletion];
                     }];
}

- (void)slideInFromRight
{
    self.alertWindow.alpha = 1.0f;
    
    //From Frame
    CGRect frame = [self frameForOrientation];
    self.alertView.bm_left = frame.size.width;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         //To Frame
                         [self centerAlertView];
                         
                     }
                     completion:^(BOOL completed) {
                         [self showCompletion];
                     }];
}


#pragma mark -
#pragma mark Hide Animations

- (void)fadeOut:(id)sender
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.alertWindow.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self dismissCompletion:sender];
                     }];
}

- (void)slideOutToBottom:(id)sender
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alertWindow.alpha = 0;
                         
                         CGRect frame = [self frameForOrientation];
                         self.alertView.bm_top = frame.size.height;
                         
                     }
                     completion:^(BOOL completed) {
                         [self dismissCompletion:sender];
                     }];
}

- (void)slideOutToTop:(id)sender
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alertWindow.alpha = 0;
                         
                         self.alertView.bm_top = -self.alertView.bm_height;
                         
                     }
                     completion:^(BOOL completed) {
                         [self dismissCompletion:sender];
                     }];
}

- (void)slideOutToLeft:(id)sender
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alertWindow.alpha = 0;
                         
                         self.alertView.bm_left = -self.alertView.bm_width;
                         
                     }
                     completion:^(BOOL completed) {
                         [self dismissCompletion:sender];
                     }];
}

- (void)slideOutToRight:(id)sender
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alertWindow.alpha = 0;
                         
                         CGRect frame = [self frameForOrientation];
                         self.alertView.bm_left = frame.size.width;
                         
                     }
                     completion:^(BOOL completed) {
                         [self dismissCompletion:sender];
                     }];
}


#pragma mark -
#pragma mark public func

+ (instancetype)showAlertWithTitle:(id)title
{
    return [self showAlertWithTitle:title message:nil];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
{
    return [self showAlertWithTitle:title message:message completion:nil];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
                        completion:(BMAlertViewCompletionBlock)completion
{
    return [self showAlertWithTitle:title message:message cancelTitle:nil completion:completion];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
                       cancelTitle:(NSString *)cancelTitle
                        completion:(BMAlertViewCompletionBlock)completion
{
    return [self showAlertWithTitle:title message:message cancelTitle:cancelTitle otherTitle:nil completion:completion];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
                       cancelTitle:(NSString *)cancelTitle
                        otherTitle:(NSString *)otherTitle
                        completion:(BMAlertViewCompletionBlock)completion
{
    return [self showAlertWithTitle:title message:message cancelTitle:cancelTitle otherTitle:otherTitle buttonsShouldStack:NO completion:completion];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
                       cancelTitle:(NSString *)cancelTitle
                        otherTitle:(NSString *)otherTitle
                buttonsShouldStack:(BOOL)shouldStack
                        completion:(BMAlertViewCompletionBlock)completion
{
    return [self showAlertWithTitle:title message:message contentView:nil cancelTitle:cancelTitle otherTitle:otherTitle buttonsShouldStack:shouldStack completion:completion];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
                       cancelTitle:(NSString *)cancelTitle
                       otherTitles:(NSArray<NSString *> *)otherTitles
                        completion:(BMAlertViewCompletionBlock)completion
{
    return [self showAlertWithTitle:title message:message contentView:nil cancelTitle:cancelTitle otherTitles:otherTitles completion:completion];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
                       contentView:(UIView *)contentView
                       cancelTitle:(NSString *)cancelTitle
                        otherTitle:(NSString *)otherTitle
                        completion:(BMAlertViewCompletionBlock)completion
{
    return [self showAlertWithTitle:title message:message contentView:contentView cancelTitle:cancelTitle otherTitles:otherTitle ? @[ otherTitle ] : nil completion:completion];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
                       contentView:(UIView *)contentView
                       cancelTitle:(NSString *)cancelTitle
                        otherTitle:(NSString *)otherTitle
                buttonsShouldStack:(BOOL)shouldStack
                        completion:(BMAlertViewCompletionBlock)completion
{
    return [self showAlertWithTitle:title message:message contentView:contentView cancelTitle:cancelTitle otherTitles:otherTitle ? @[ otherTitle ] : nil buttonsShouldStack:shouldStack completion:completion];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
                       contentView:(UIView *)contentView
                       cancelTitle:(NSString *)cancelTitle
                       otherTitles:(NSArray<NSString *> *)otherTitles
                        completion:(BMAlertViewCompletionBlock)completion
{
    return [self showAlertWithTitle:title message:message contentView:contentView cancelTitle:cancelTitle otherTitles:otherTitles buttonsShouldStack:NO completion:completion];
}

+ (instancetype)showAlertWithTitle:(id)title
                           message:(id)message
                       contentView:(UIView *)contentView
                       cancelTitle:(NSString *)cancelTitle
                       otherTitles:(NSArray<NSString *> *)otherTitles
                buttonsShouldStack:(BOOL)shouldStack
                        completion:(BMAlertViewCompletionBlock)completion
{
    BMAlertView *alertView = [self alertWithTitle:title
                                          message:message
                                      contentView:contentView
                                      cancelTitle:cancelTitle
                                      otherTitles:otherTitles
                               buttonsShouldStack:shouldStack
                                       completion:completion];
    
    [alertView show];
    return alertView;
}

+ (instancetype)alertWithTitle:(id)title
                       message:(id)message
                   contentView:(UIView *)contentView
                   cancelTitle:(NSString *)cancelTitle
                   otherTitles:(NSArray<NSString *> *)otherTitles
            buttonsShouldStack:(BOOL)shouldStack
                    completion:(BMAlertViewCompletionBlock)completion;
{
    NSUInteger alertViewCount = [[BMAlertViewStack sharedInstance] getAlertViewCount];
    if (alertViewCount >= BMALERTVIEW_MAXSHOWCOUNT)
    {
        return nil;
    }
    
    BMAlertView *alertView = [[self alloc] initWithIcon:nil
                                                  title:title
                                                message:message
                                            contentView:contentView
                                            cancelTitle:cancelTitle
                                            otherTitles:otherTitles
                                     buttonsShouldStack:shouldStack
                                             completion:completion];
    return alertView;
}

- (void)showAlertView
{
    [self show];
}

- (UIButton *)getButtonAtIndex:(NSUInteger)buttonIndex
{
    if (buttonIndex < self.buttonArray.count)
    {
        return self.buttonArray[buttonIndex];
    }
    else
    {
        return nil;
    }
}

- (void)dismiss
{
    [self dismiss:nil];
}

- (void)dismissWithIndex:(NSInteger)index animated:(BOOL)animated
{
    id sender = nil;
    
    if (index < 0)
    {
        sender = self.tapOutside;
    }
    else if (index == 0)
    {
        sender = self.buttonArray[0];
    }
    else if (index < self.buttonArray.count)
    {
        sender = self.buttonArray[index];
    }
    
    [self dismiss:sender animated:animated];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if (buttonIndex >= 0 && buttonIndex < self.buttonArray.count)
    {
        [self dismiss:self.buttonArray[buttonIndex] animated:animated];
    }
}

@end

@implementation BMAlertViewStack

+ (instancetype)sharedInstance
{
    static BMAlertViewStack *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[BMAlertViewStack alloc] init];
        _sharedInstance.alertViews = [NSMutableArray array];
    });
    
    return _sharedInstance;
}

- (void)push:(BMAlertView *)alertView
{
    @synchronized(self.alertViews)
    {
        for (BMAlertView *av in self.alertViews)
        {
            if (av != alertView)
            {
                [av hide];
            }
            else
            {
                [av freshAlertView];
                return;
            }
        }
        [self.alertViews addObject:alertView];
        [alertView showInternal];
    }
}

- (void)pop:(BMAlertView *)alertView
{
    @synchronized(self.alertViews)
    {
        [alertView hide];
        [self.alertViews removeObject:alertView];
        BMAlertView *last = [self.alertViews lastObject];
        if (last && !last.alertWindow.rootViewController)
        {
            [last showInternal];
        }
        else
        {
            // 公共alertWindow，hide时alertWindow.alpha变更为0
            last.alertWindow.alpha = 1;
        }
    }
}

- (void)closeAllAlertViews
{
    BMAlertView *last = [self.alertViews lastObject];
    while (last)
    {
        if (last.notDismissOnCancel)
        {
            break;
        }
        
        [self closeAlertView:last animated:NO];
        last = [self.alertViews lastObject];
    }
}

- (void)closeAlertView:(BMAlertView *)alertView
{
    [self closeAlertView:alertView animated:YES];
}

- (void)closeAlertView:(BMAlertView *)alertView animated:(BOOL)animated
{
    [alertView dismiss:nil animated:animated];
}

- (void)closeAlertView:(BMAlertView *)alertView dismissWithIndex:(NSInteger)index animated:(BOOL)animated
{
    [alertView dismissWithIndex:index animated:animated];
}

- (NSUInteger)getAlertViewCount
{
    return self.alertViews.count;
}

@end
