//
//  ChatTextView.m
//  ODR
//
//  Created by DH on 2017/9/12.
//  Copyright © 2017年 DH. All rights reserved.
//

#import "ChatTextView.h"
#import "ChatTextModel.h"
//#import "PlaceHolderTextView.h"
//#import <YYTextView.h>


#define NameLabelLeftOffset 10
#define IconImgViewLeftOffset 15
#define YuyinViewLeftOffset 8
#define BgViewLeftOffset 5
#define ArticleLabelLeftOffset 19
#define ArticleLabelRightOffset 14


@implementation ChatTimeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}


- (void)initUI {
    _timeLabel = [UILabel new];
    _timeLabel.font = UI_FONT_13;
    _timeLabel.textColor = UI_COLOR_B4;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(10);
        make.bottom.right.equalTo(self.contentView).offset(-10);
    }];
}

- (void)setModel:(ChatTextModel *)model
{
    _timeLabel.text = [NSDate bm_stringFromTs:model.createTime formatter:@"yyyy-MM-dd HH:mm"];
}

@end;

@implementation ChatTextViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}
- (void)initUI {
    
    _iconImgView = [UIImageView new];
    _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImgView.clipsToBounds = YES;
    [_iconImgView bm_roundedRect:2.0];
    [self.contentView addSubview:_iconImgView];
    [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.iconImgViewLeftConstraint = make.left.equalTo(self.contentView).offset(IconImgViewLeftOffset);
        make.top.equalTo(self.contentView).offset(10);
        make.height.width.offset(35).with.priorityHigh();
    }];

    _nameLabel = [UILabel new];
    _nameLabel.textColor = UI_COLOR_B4;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = UI_FONT_12;
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        self.nameLabelLeftConstraint = make.left.equalTo(self.iconImgView.mas_right).offset(NameLabelLeftOffset);
        make.top.equalTo(self.iconImgView);
    }];

    _yuyinView = [messageTypeView new];
    [self.contentView addSubview:_yuyinView];
    [_yuyinView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.yuyinViewLeftConstraint = make.left.equalTo(self.nameLabel.mas_right).offset(YuyinViewLeftOffset);
        make.top.equalTo(self.iconImgView).offset(-2);
        make.size.mas_equalTo(CGSizeMake(65, 18));
    }];

    _bgView = [UIImageView new];
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.bgViewLeftConstraint = make.left.equalTo(self.iconImgView.mas_right).offset(BgViewLeftOffset);
        make.top.equalTo(self.iconImgView).offset(20);
    }];

    _articleLabel = [UILabel new];
    _articleLabel.font = UI_BM_FONT(kArticleLabelFontSize);
    _articleLabel.numberOfLines = 0;
    _articleLabel.preferredMaxLayoutWidth = UI_SCREEN_WIDTH - 150;
    [self.contentView addSubview:_articleLabel];
    [_articleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        self.articleLabelLeftConstraint = make.left.equalTo(self.bgView).offset(ArticleLabelLeftOffset);
        make.top.equalTo(self.bgView).offset(13);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.bgViewRightConstraint = make.right.equalTo(self.articleLabel).offset(ArticleLabelRightOffset);
        make.bottom.equalTo(self.articleLabel).offset(13);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}

- (void)setModel:(ChatTextModel *)model {
    _model = model;
    _articleLabel.text = model.messageContent;
    _nameLabel.text = model.sender.memberName;

    if (model.showMessageType) {
        _yuyinView.hidden = YES;
    } else  {
        [_yuyinView setMessageType:model.isVoice];
        [_yuyinViewLeftConstraint uninstall];
    }

    [_iconImgViewLeftConstraint uninstall];
    [_bgViewLeftConstraint uninstall];
    [_nameLabelLeftConstraint uninstall];
    [_articleLabelLeftConstraint uninstall];
    [_bgViewRightConstraint uninstall];
    if (model.isMe) {
        _iconImgView.image = [UIImage imageNamed:@"chat_head_mediator"];
        _bgView.image = [UIImage strethImageWith:@"chat_right_bg"];
        _articleLabel.textColor = [UIColor whiteColor];

        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.iconImgViewLeftConstraint = make.right.equalTo(self.contentView).offset(-IconImgViewLeftOffset);
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          self.nameLabelLeftConstraint = make.right.equalTo(self.iconImgView.mas_left).offset(-NameLabelLeftOffset);
        }];
        if (!model.showMessageType) {
            [_yuyinView mas_makeConstraints:^(MASConstraintMaker *make) {
                self.yuyinViewLeftConstraint = make.right.equalTo(self.nameLabel.mas_left).offset(-YuyinViewLeftOffset);
            }];
        }
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.bgViewRightConstraint = make.right.equalTo(self.articleLabel).offset(ArticleLabelLeftOffset);
            self.bgViewLeftConstraint = make.right.equalTo(self.iconImgView.mas_left).offset(-BgViewLeftOffset);
        }];
        [_articleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            self.articleLabelLeftConstraint = make.left.equalTo(self.bgView).offset(ArticleLabelRightOffset);
        }];

    } else {
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.iconImgViewLeftConstraint = make.left.equalTo(self.contentView).offset(IconImgViewLeftOffset);
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            self.nameLabelLeftConstraint = make.left.equalTo(self.iconImgView.mas_right).offset(NameLabelLeftOffset);
        }];
        if (!model.showMessageType) {
            [_yuyinView mas_makeConstraints:^(MASConstraintMaker *make) {
                self.yuyinViewLeftConstraint = make.left.equalTo(self.nameLabel.mas_right).offset(YuyinViewLeftOffset);
            }];
        }
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.bgViewRightConstraint = make.right.equalTo(self.articleLabel).offset(ArticleLabelRightOffset);
            self.bgViewLeftConstraint = make.left.equalTo(self.iconImgView.mas_right).offset(BgViewLeftOffset);
        }];
        [_articleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            self.articleLabelLeftConstraint = make.left.equalTo(self.bgView).offset(ArticleLabelLeftOffset);
        }];
        _iconImgView.image = [UIImage imageNamed:@"chat_head_user"];
        _bgView.image = [UIImage strethImageWith:@"chat_left_bg"];
        _articleLabel.textColor = UI_COLOR_B1;
    }
    
}
@end

/*********************************************************************/

/*********************************************************************/
@interface ChatTextImportView ()
@property (nonatomic, assign) CGFloat lastContentH; ///< 记录上一次的高度
@property (nonatomic, assign) NSInteger currentTextRow; ///< 当前文字行数
@end
@implementation ChatTextImportView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor bm_colorWithHex:0xf2f2f2];
        _miniHeith = 33;
        _maxHeith = 85;

        _textView = [BMPlaceholderTextView new];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = UI_FONT_14;
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.placeholder = @"请输入文字";
        _textView.placeholderColor = [UIColor bm_colorWithHex:0xcdcdcd];
        [self addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(8);
            make.right.equalTo(self).offset(-8);
            make.top.equalTo(self).offset(6);
            make.bottom.equalTo(self).offset(-6);
            self.textViewHeightConstaint = make.height.offset(_miniHeith);
        }];
        
        self.puppet = [[BMPlaceholderTextView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH - 16, frame.size.height)];
        _puppet.font = UI_FONT_14;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)keyboardWillShow:(NSNotification *)noti {
    NSLog(@"%@", noti.userInfo);
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat distanceForBottom = rect.size.height;
    if ([self.delegate respondsToSelector:@selector(importView:keyboardFrameDidChangeWithDistanceRelativeBottom:)]) {
        [self.delegate importView:self keyboardFrameDidChangeWithDistanceRelativeBottom:distanceForBottom];
    }
}

- (void)keyboardWillHide:(NSNotification *)noti {
    if ([self.delegate respondsToSelector:@selector(importView:keyboardFrameDidChangeWithDistanceRelativeBottom:)]) {
        [self.delegate importView:self keyboardFrameDidChangeWithDistanceRelativeBottom:0];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(importView:senderBtnDidClick:)]) {
            [self.delegate importView:self senderBtnDidClick:textView.text];
            textView.text = nil;
            _textViewHeightConstaint.offset = _miniHeith;
            [_textView updateConstraintsIfNeeded];
        }
        return NO;
    } else {
        
        NSString *result = [textView.text stringByReplacingCharactersInRange:range withString:text];
        _puppet.text = result;
        float textViewHeight =  [_puppet sizeThatFits:CGSizeMake(_puppet.frame.size.width, MAXFLOAT)].height;

        if (textViewHeight < _maxHeith) {
            textView.scrollEnabled = NO;
        } else {
            textView.scrollEnabled = YES;
        }
        
        return YES;
    }
}

-(void)textViewDidChange:(UITextView *)textView {
    float textViewHeight =  [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)].height;
    if (textViewHeight > _maxHeith) {
        _textViewHeightConstaint.offset = _maxHeith;
        [_textView updateConstraintsIfNeeded];
    } else {
        _textViewHeightConstaint.offset = textViewHeight;
        [_textView updateConstraintsIfNeeded];
    }
}
// remove notification
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


@interface messageTypeView ()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation messageTypeView

- (instancetype)init
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
        [self bm_roundedRect:1.0f];
        
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 12, 12)];
        [self addSubview:_iconImgView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 3, 48, 12)];
        _titleLabel.textColor = [UIColor colorWithRed:181.0f/255.0f green:181.0f/255.0f blue:181.0f/255.0f alpha:1.0f];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:10.0f];
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (void)setMessageType:(BOOL)isYunyin
{
    if (isYunyin)
    {
        _iconImgView.image = [UIImage imageNamed:@"chat_message_voice"];
        _titleLabel.text = @"语音识别";
    }
    else
    {
        _iconImgView.image = [UIImage imageNamed:@"chat_message_text"];
        _titleLabel.text = @"手动输入";
    }
}

@end




