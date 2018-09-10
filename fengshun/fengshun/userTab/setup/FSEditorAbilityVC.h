//
//  FSEditorAbilityVC.h
//  fengshun
//
//  Created by jiang deng on 2018/9/7.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSetTableViewVC.h"

@protocol FSEditorAbilityDelegate;
@interface FSEditorAbilityVC : FSSetTableViewVC

@property (nonatomic, weak) id <FSEditorAbilityDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *m_AbilityArray;

@end

@protocol FSEditorAbilityDelegate <NSObject>

@optional

// ","逗号分隔
- (void)editorAbilityFinished:(FSEditorAbilityVC *)vc ability:(NSString *)ability;

@end
