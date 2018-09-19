//
//  FSEditVideoMediateView.h
//  fengshun
//
//  Created by ILLA on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORDTextView.h"

@class FSEditVideoMediateBaseView;
@class FSEditVideoMediateTextView;

typedef void(^FSEditVideoViewTapHandler)(FSEditVideoMediateBaseView *editView);
typedef void(^FSEditVideoViewTextChangeHandler)(FSEditVideoMediateTextView *editView);

@interface FSEditVideoMediateBaseView : UIView
@property (nonatomic, copy) FSEditVideoViewTapHandler tapHandle;

- (void)setEditEnabled:(BOOL)enable;

- (NSAttributedString *)placeHolderAttributedWithString:(NSString *)string;

@end

// 左侧显示title
@interface FSEditVideoMediateTitleView : FSEditVideoMediateBaseView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;
@end

// 右侧输入单行文本 51
@interface FSEditVideoMediateTextView : FSEditVideoMediateTitleView
//@property (nonatomic, strong) ORDTextView *desLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, copy) FSEditVideoViewTextChangeHandler textChangeHandle;
@end

// 右侧带图标
@interface FSEditVideoMediateImageView : FSEditVideoMediateTextView
@property (nonatomic, strong) UIImageView *imgView;

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)name;

@end

// 输入多行内容 128
@interface FSEditVideoMediateContentView : FSEditVideoMediateTitleView
@property (nonatomic, strong) ORDTextView *contentText;
@end

// 右侧view自定义
@interface FSEditVideoMediateCustomerView : FSEditVideoMediateTextView
@property (nonatomic, strong) UIView *customerView;
@end
