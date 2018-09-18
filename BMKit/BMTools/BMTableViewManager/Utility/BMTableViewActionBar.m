//
//  BMTableViewActionBar.m
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2017/8/7.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "BMTableViewActionBar.h"
#import "BMTableViewManager.h"

@interface BMTableViewActionBar ()

@property (strong, nonatomic) UISegmentedControl *navigationControl;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation BMTableViewActionBar

- (instancetype)initWithDelegate:(id<BMTableViewActionBarDelegate>)delegate
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    [self sizeToFit];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleActionBarDone:)];
    
    self.navigationControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Previous", @""), NSLocalizedString(@"Next", @""), nil]];
    self.navigationControl.momentary = YES;
    [self.navigationControl addTarget:self action:@selector(handleActionBarPreviousNext:) forControlEvents:UIControlEventValueChanged];
    
    [self.navigationControl setImage:[UIImage imageNamed:@"BMTableView_UIButtonBarArrowLeft"] forSegmentAtIndex:0];
    [self.navigationControl setImage:[UIImage imageNamed:@"BMTableView_UIButtonBarArrowRight"] forSegmentAtIndex:1];
    
    [self.navigationControl setDividerImage:[[UIImage alloc] init]
                        forLeftSegmentState:UIControlStateNormal
                          rightSegmentState:UIControlStateNormal
                                 barMetrics:UIBarMetricsDefault];
    
    [self.navigationControl setBackgroundImage:[UIImage imageNamed:@"BMTableView_Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self.navigationControl setWidth:40.0f forSegmentAtIndex:0];
    [self.navigationControl setWidth:40.0f forSegmentAtIndex:1];
    [self.navigationControl setContentOffset:CGSizeMake(-4, 0) forSegmentAtIndex:0];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, self.bm_width - 200, self.bm_height)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.titleLabel];
    
    UIBarButtonItem *prevNextWrapper = [[UIBarButtonItem alloc] initWithCustomView:self.navigationControl];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self setItems:[NSArray arrayWithObjects:prevNextWrapper, flexible, doneButton, nil]];
    self.actionBarDelegate = delegate;
    
    return self;
}

- (void)setActionBarTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)handleActionBarPreviousNext:(UISegmentedControl *)segmentedControl
{
    if ([self.actionBarDelegate respondsToSelector:@selector(actionBar:navigationControlValueChanged:)])
    {
        [self.actionBarDelegate actionBar:self navigationControlValueChanged:segmentedControl];
    }
}

- (void)handleActionBarDone:(UIBarButtonItem *)doneButtonItem
{
    if ([self.actionBarDelegate respondsToSelector:@selector(actionBar:doneButtonPressed:)])
    {
        [self.actionBarDelegate actionBar:self doneButtonPressed:doneButtonItem];
    }
}

@end
