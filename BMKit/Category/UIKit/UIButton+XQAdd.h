//
//  UIButton+XQAdd.h
//  Tea
//
//  Created by Ticsmatic on 2016/12/21.
//  Copyright © 2016年 Ticsmatic. All rights reserved.
//

#define GetVerifyCodeStart(sender) [(sender) startWithTime:59 title:@"获取验证码" countDownTitle:@[@"", @"秒后重发"] mainColor:[UIColor clearColor] countColor:kGrayColor6 font:[UIFont systemFontOfSize:14]];

#import <UIKit/UIKit.h>

@interface UIButton (XQAdd)

#pragma mark - 调整文字或者图片的位置
// https://github.com/Phelthas/Demo_ButtonImageTitleEdgeInsets
typedef NS_ENUM(NSInteger, LXMImagePosition) {
    LXMImagePositionLeft = 0,              //图片在左，文字在右，默认
    LXMImagePositionRight = 1,             //图片在右，文字在左
    LXMImagePositionTop = 2,               //图片在上，文字在下
    LXMImagePositionBottom = 3,            //图片在下，文字在上
};

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)setImagePosition:(enum LXMImagePosition)postion spacing:(CGFloat)spacing;

#pragma mark - 倒计时

/**
 倒计时按钮
 eg:[btn startWithTime:10 title:@"获取验证码" countDownTitle:@[@"重新获取", @"s"] mainColor:[UIColor redColor] countColor:[UIColor blueColor] font:[UIFont systemFontOfSize:15]];
 @param timeLine    倒计时总时间
 @param title       还没倒计时的title
 @param subTitles   倒计时的子名字 如@[@"重新获取", @"s"]
 @param mColor      还没倒计时的颜色
 @param color       倒计时的颜色
 @param font        字体大小
 */
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSArray<NSString *> *)subTitles mainColor:(UIColor *)mColor countColor:(UIColor *)color font:(UIFont *)font;
/**
 倒计时按钮——带boardColor颜色方法
 eg:[btn startWithTime:10 title:@"获取验证码" countDownTitle:@[@"重新获取", @"s"] mainColor:[UIColor redColor] countColor:[UIColor blueColor] font:[UIFont systemFontOfSize:15]];
 @param timeLine    倒计时总时间
 @param title       还没倒计时的title
 @param subTitles   倒计时的子名字 如@[@"重新获取", @"s"]
 @param mColor      还没倒计时的字体和边框颜色
 @param color       倒计时的字体和边框颜色
 @param font        字体大小
 */
- (void)startWithBorderColorMainColor:(UIColor *)mColor countColor:(UIColor *)color countDowntime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSArray<NSString *> *)subTitles font:(UIFont *)font;

@end
