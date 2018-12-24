//
//  FSInputTextView.h
//  fengshun
//
//  Created by BeSt2wa on 2018/12/21.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSInputTextView : UIView

@property (nonatomic , copy) NSString *m_PlaceHolder;

@property (nonatomic , copy) NSString *m_Title;

@property (nonatomic , copy) NSString *m_Content;

@property (nonatomic , assign) BOOL m_IsShowBottomLine;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSString *)content placeHolder:(NSString *)placeholder;

@end

NS_ASSUME_NONNULL_END
