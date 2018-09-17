//
//  BMTableViewActionBar.h
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2017/8/7.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BMTableViewActionBarDelegate;

@interface BMTableViewActionBar : UIToolbar

@property (nonatomic, strong, readonly) UISegmentedControl *navigationControl;
@property (nonatomic, weak) id<BMTableViewActionBarDelegate> actionBarDelegate;

- (instancetype)initWithDelegate:(id<BMTableViewActionBarDelegate>)delegate;
- (void)setActionBarTitle:(NSString *)title;

@end

@protocol BMTableViewActionBarDelegate <NSObject>

- (void)actionBar:(BMTableViewActionBar *)actionBar navigationControlValueChanged:(UISegmentedControl *)navigationControl;
- (void)actionBar:(BMTableViewActionBar *)actionBar doneButtonPressed:(UIBarButtonItem *)doneButtonItem;

@end

NS_ASSUME_NONNULL_END
