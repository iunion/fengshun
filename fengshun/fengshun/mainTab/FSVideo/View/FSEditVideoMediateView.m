//
//  FSEditVideoMediateView.m
//  fengshun
//
//  Created by ILLA on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSEditVideoMediateView.h"

#define kMarginLeft 16
#define kTextViewHeight 51


@implementation FSEditVideoMediateBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setEditEnabled:(BOOL)enable {

}

- (void)tapAction
{
    if (self.tapHandle) {
        self.tapHandle(self);
    }
}

- (NSAttributedString *)placeHolderAttributedWithString:(NSString *)string
{
    return [[NSAttributedString alloc] initWithString:string
                                           attributes:@{NSForegroundColorAttributeName:UI_COLOR_B10,
                                                        NSFontAttributeName:UI_FONT_16
                                                        }];
}

@end

// 左侧显示title
@implementation FSEditVideoMediateTitleView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if (self.bm_height == 0) {
            self.bm_height = kTextViewHeight;
        }
        self.backgroundColor = [UIColor whiteColor];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft, 0, 80, self.bm_height)];
        _titleLabel.textColor = UI_COLOR_B1;
        _titleLabel.font = UI_FONT_16;
        [self addSubview:_titleLabel];
        _titleLabel.bm_left = kMarginLeft;
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(kMarginLeft, self.bm_height - 0.5, self.bm_width - kMarginLeft, 0.5)];
        _line.backgroundColor = UI_COLOR_B6;
        [self addSubview:_line];
    }
    return self;
}

@end


// 右侧输入单行文本
@implementation FSEditVideoMediateTextView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, (self.bm_height - 18)/2, self.bm_width - 100 - kMarginLeft, 18)];
        _desLabel.font = UI_FONT_16;
        _desLabel.textColor = UI_COLOR_B1;
        _desLabel.backgroundColor = [UIColor clearColor];
        _desLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_desLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textFieldTextDidChange:(NSNotification *)notify
{
    if ([self.desLabel isEqual:notify.object]) {
        if (self.textChangeHandle) {
            self.textChangeHandle(self);
        }
    }
}

- (void)setEditEnabled:(BOOL)enable {
    [super setEditEnabled:enable];
    _desLabel.userInteractionEnabled = enable;
}

@end

// 右侧带图标
@implementation FSEditVideoMediateImageView
- (instancetype)initWithFrame:(CGRect)frame   imageName:(NSString *)name{
    if (self = [super initWithFrame:frame]) {
        
        if ([name bm_isNotEmpty]) {
            UIImage *image = [UIImage imageNamed:name];
            if (image) {
                self.imgView = [[UIImageView alloc] initWithImage:image];
                _imgView.frame = CGRectMake(self.bm_width - image.size.width - kMarginLeft, (self.bm_height - image.size.height)/2, image.size.width, image.size.height);
                [self addSubview:_imgView];

                self.desLabel.frame = CGRectMake(100, 0, _imgView.bm_left - 100 - 12, self.bm_height);
            }
        }
    }
    return self;
}

@end


// 输入多行内容
@implementation FSEditVideoMediateContentView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.bm_height = 128;
        ORDTextView *contentLabel = [[ORDTextView alloc] initWithFrame:CGRectMake(kMarginLeft - 6, 40, self.bm_width - kMarginLeft*2 + 12, self.bm_height - 40 - 12)];
        self.contentText = contentLabel;
        contentLabel.font = UI_FONT_16;
        contentLabel.textColor = UI_COLOR_B1;
        contentLabel.placeholderColor = UI_COLOR_B10;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.editable = YES;//可以编辑
        [self addSubview:contentLabel];
    }
    return self;
}

- (void)setEditEnabled:(BOOL)enable {
    [super setEditEnabled:enable];
    _contentText.userInteractionEnabled = enable;
}

@end

// 右侧view自定义
@implementation FSEditVideoMediateCustomerView

- (void)setCustomerView:(UIView *)customerView
{
    _customerView = customerView;
    [self addSubview:customerView];
}

@end
