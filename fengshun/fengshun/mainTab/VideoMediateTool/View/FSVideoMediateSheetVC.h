//
//  FSVideoMediateSheetVC.h
//  fengshun
//
//  Created by ILLA on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSuperVC.h"

typedef void(^FSVideoMediateActionSheetDoneBlock)(NSInteger index, NSString *title);

@interface FSVideoMediateSheetVC : FSSuperVC

@property (nonatomic, copy) FSVideoMediateActionSheetDoneBlock m_ActionSheetDoneBlock;

- (instancetype)initWithTitleArray:(NSArray *)titles block:(FSVideoMediateActionSheetDoneBlock)block;

- (instancetype)initWithTitleArray:(NSArray *)titles;

@end
