//
//  FSCaseCell.h
//  fengshun
//
//  Created by Aiwei on 2018/9/7.
//  Copyright © 2018 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSSearchResultModel.h"

@interface FSCaseCell : UITableViewCell

@property (nonatomic, strong) FSCaseModel *m_caseModel;

- (void)setCaseResultModel:(FSCaseResultModel *)model attributed:(BOOL)attributed;

@end
