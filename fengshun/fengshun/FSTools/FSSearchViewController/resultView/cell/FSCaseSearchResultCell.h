//
//  FSCaseSearchResultCell.h
//  fengshun
//
//  Created by Aiwei on 2018/9/7.
//  Copyright © 2018 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCaseSearchResultModel.h"

@interface FSCaseSearchResultCell : UITableViewCell

@property (nonatomic, strong) FSCaseResultModel *m_caseResultModel;
- (void)setCaseResultModel:(FSCaseResultModel *)model attributed:(BOOL)attributed;
@end
