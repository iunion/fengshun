//
//  FSEditorVC.h
//  fengshun
//
//  Created by jiang deng on 2018/9/7.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSetTableViewVC.h"

@protocol FSEditorDelegate;

@interface FSEditorVC : FSSetTableViewVC

@property (nonatomic, weak) id <FSEditorDelegate> delegate;
@property (nonatomic, assign, readonly) FSUpdateUserInfoOperaType m_OperaType;

@property (nonatomic, assign, readonly) NSUInteger m_MinWordCount;
@property (nonatomic, assign, readonly) NSUInteger m_MaxWordCount;

- (instancetype)initWithOperaType:(FSUpdateUserInfoOperaType)operaType minWordCount:(NSUInteger)minWordCount maxnWordCount:(NSUInteger)maxWordCount text:(NSString *)text placeholderText:(NSString *)placeholder;

@end

@protocol FSEditorDelegate <NSObject>

@optional

- (void)editorFinishedWithOperaType:(FSUpdateUserInfoOperaType)operaType value:(NSString *)value;

@end
