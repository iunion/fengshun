//
//  UIButton+XQAdd.m
//  Tea
//
//  Created by Ticsmatic on 2016/12/21.
//  Copyright © 2016年 Ticsmatic. All rights reserved.
//

#import "UIButton+XQAdd.h"

@implementation UIButton (XQAdd)

- (void)setImagePosition:(enum LXMImagePosition)postion spacing:(CGFloat)spacing {
    [self setTitle:self.currentTitle forState:UIControlStateNormal];
    [self setImage:self.currentImage forState:UIControlStateNormal];
    
    
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2;//image中心移动的x距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
    CGFloat labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
    
    CGFloat tempWidth = MAX(labelWidth, imageWidth);
    CGFloat changedWidth = labelWidth + imageWidth - tempWidth;
    CGFloat tempHeight = MAX(labelHeight, imageHeight);
    CGFloat changedHeight = labelHeight + imageHeight + spacing - tempHeight;
    
    switch (postion) {
        case LXMImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
            break;
            
        case LXMImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing/2), 0, imageWidth + spacing/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
            break;
            
        case LXMImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(imageOffsetY, -changedWidth/2, changedHeight-imageOffsetY, -changedWidth/2);
            break;
            
        case LXMImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(changedHeight-imageOffsetY, -changedWidth/2, imageOffsetY, -changedWidth/2);
            break;
            
        default:
            break;
    }
    
}

- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSArray<NSString *> *)subTitles mainColor:(UIColor *)mColor countColor:(UIColor *)color font:(UIFont *)font{
    BMWeakSelf
    // 倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        BMStrongSelf
        if (!strongSelf) return;
        // 倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf setTitle:title forState:UIControlStateNormal];
                [strongSelf setTitleColor:color forState:UIControlStateNormal];
                strongSelf.titleLabel.font = font;
                strongSelf.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeOut % 60;
            NSString * timeStr = [NSString stringWithFormat:@"%0.2ld", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf setTitle:[NSString stringWithFormat:@"%@ %@%@",subTitles.firstObject,timeStr,subTitles.lastObject] forState:UIControlStateNormal];
                [strongSelf setTitleColor:color forState:UIControlStateNormal];
                strongSelf.titleLabel.font = font;
                strongSelf.userInteractionEnabled = NO;
            });
            
            timeOut--;
        }
    });
    
    dispatch_resume(_timer);
    /**
     关于GCD的小知识（http://blog.csdn.net/nogodoss/article/details/31346207）
     Grand Central Dispatch支持以下dispatch source：
     Timer dispatch source：定期产生通知
     Signal dispatch source：UNIX信号到达时产生通知
     Descriptor dispatch source：各种文件和socket操作的通知
     ...
     ...
     当你配置一个dispatch source时，你指定要监测的事件、dispatch queue、以及处理事件的代码(block或函数)。当事件发生时，dispatch source会提交你的block或函数到指定的queue去执行
     
     为了防止事件积压到dispatch queue，dispatch source实现了事件合并机制。如果新事件在上一个事件处理器出列并执行之前到达，dispatch source会将新旧事件的数据合并。根据事件类型的不同，合并操作可能会替换旧事件，或者更新旧事件的信息
     
     
     */
}

- (void)startWithBorderColorMainColor:(UIColor *)mColor countColor:(UIColor *)color countDowntime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSArray<NSString *> *)subTitles font:(UIFont *)font {
    BMWeakSelf
    // 倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        BMStrongSelf
        if (!strongSelf) return;
        // 倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf setTitle:title forState:UIControlStateNormal];
                [strongSelf setTitleColor:color forState:UIControlStateNormal];
                strongSelf.titleLabel.font = font;
                strongSelf.layer.borderColor = mColor.CGColor;
                strongSelf.userInteractionEnabled = YES;
                [strongSelf setTitleColor:mColor forState:(UIControlStateNormal)];
            });
        }else{
            NSInteger seconds = timeOut;
            NSString * timeStr = [NSString stringWithFormat:@"%0.2ld", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf setTitle:[NSString stringWithFormat:@"%@ %@%@", subTitles.firstObject, timeStr, subTitles.lastObject] forState:UIControlStateNormal];
                [strongSelf setTitleColor:color forState:UIControlStateNormal];
                strongSelf.titleLabel.font = font;
                strongSelf.layer.borderColor = color.CGColor;
                strongSelf.userInteractionEnabled = NO;
                [strongSelf setTitleColor:color forState:(UIControlStateNormal)];
            });
            
            timeOut--;
        }
    });
    
    dispatch_resume(_timer);
}
@end
