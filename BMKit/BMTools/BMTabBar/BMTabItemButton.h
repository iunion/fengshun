//
//  BMTabItemButton.h
//  BMBaseKit
//
//  Created by DennisDeng on 15/8/19.
//  Copyright (c) 2015年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMTabItemClass : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, strong) NSString *normalIcon;
@property (nonatomic, strong) NSString *selectedIcon;

@property (nonatomic, strong) NSString *normalIconUrl;
@property (nonatomic, strong) NSString *selectedIconUrl;

@end

@interface BMTabItemButton : UIButton

// icon在正常、选中、高亮三种状态的时候对应的图片名
@property (nonatomic, strong) NSString *normalIcon;
@property (nonatomic, strong) NSString *highlightIcon;
@property (nonatomic, strong) NSString *selectedIcon;

@property (nonatomic, strong) NSString *normalIconUrl;
@property (nonatomic, strong) NSString *highlightIconUrl;
@property (nonatomic, strong) NSString *selectedIconUrl;

@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleHighlightColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;

- (void)setNormalIconName:(NSString *)normal
        highLightIconName:(NSString *)high
         selectedIconName:(NSString *)selected;

- (void)setNormalIconUrl:(NSString *)normal
        highLightIconUrl:(NSString *)high
         selectedIconUrl:(NSString *)selected;

- (void)setTitle:(NSString *)title
     normalColor:(UIColor *)normalColor
  highLightColor:(UIColor *)highLightColor
   selectedColor:(UIColor *)selectedColor;

- (void)freshWithTabItem:(BMTabItemClass *)tabItem;

@end
