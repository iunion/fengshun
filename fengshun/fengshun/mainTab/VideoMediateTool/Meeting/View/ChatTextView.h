//
//  ChatTextView.h
//  ODR
//
//  Created by DH on 2017/9/12.
//  Copyright © 2017年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMPlaceholderTextView.h"

@class messageTypeView;

#define kArticleLabelFontSize 14

@class ChatTextModel;

@interface ChatTimeViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) ChatTextModel *model;
@end

@interface ChatTextViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) messageTypeView *yuyinView;
@property (nonatomic, strong) UILabel *articleLabel;
@property (nonatomic, strong) UIImageView *bgView;

@property (nonatomic, strong) ChatTextModel *model;

@property (nonatomic, strong) MASConstraint *nameLabelLeftConstraint;
@property (nonatomic, strong) MASConstraint *iconImgViewLeftConstraint;
@property (nonatomic, strong) MASConstraint *yuyinViewLeftConstraint;
@property (nonatomic, strong) MASConstraint *bgViewLeftConstraint;
@property (nonatomic, strong) MASConstraint *bgViewRightConstraint;
@property (nonatomic, strong) MASConstraint *articleLabelLeftConstraint;
@end



@protocol ChatTextImportViewDelegate;
@class PlaceHolderTextView;
@interface ChatTextImportView : UIView <UITextViewDelegate>
@property (nonatomic, strong) BMPlaceholderTextView *textView;
@property (nonatomic, strong) MASConstraint *textViewHeightConstaint;
@property (nonatomic, weak) id <ChatTextImportViewDelegate> delegate;
@property (nonatomic, assign) NSInteger maxRow; ///< 最大行数
@end

@protocol ChatTextImportViewDelegate <NSObject>
- (void)importView:(ChatTextImportView *)importView keyboardFrameDidChangeWithDistanceRelativeBottom:(CGFloat)distance;
- (void)importView:(ChatTextImportView *)importView senderBtnDidClick:(NSString *)content;
@end


// 语音消息还是文本消息
@interface messageTypeView : UIView
- (void)setMessageType:(BOOL)isYunyin;
@end


