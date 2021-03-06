//
//  FSVideoMediatePersonalCell.h
//  fengshun
//
//  Created by ILLA on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMTableViewCell.h"
#import "FSVideoMediateModel.h"

@interface FSVideoMediatePersonalCell : BMTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier selectEnable:(BOOL)enable;

@property (nonatomic, assign) BOOL selectEnable;

@property (nonatomic, strong) FSMeetingPersonnelModel *model;

- (void)showCellLine:(BOOL)show;

@end
