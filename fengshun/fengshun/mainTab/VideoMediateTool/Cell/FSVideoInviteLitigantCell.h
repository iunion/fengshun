//
//  FSVideoInviteLitigantCell.h
//  fengshun
//
//  Created by ILLA on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVideoMediateModel.h"

@class FSVideoInviteLitigantCell;

typedef void(^deleteLitigantCellBlock)(FSVideoInviteLitigantCell *cell);

@interface FSVideoInviteLitigantCell : UITableViewCell

@property (nonatomic, copy) deleteLitigantCellBlock deleteBlock;

@property (nonatomic, strong) FSMeetingPersonnelModel *m_Model;

@end
