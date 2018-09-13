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
@property (weak, nonatomic) IBOutlet UILabel *m_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_tabLabel;
@property (weak, nonatomic) IBOutlet UIView *m_tagView;

@property (nonatomic, strong) FSCaseReultModel *m_caseResultModel;
- (void)setAttributedCaseResultModel:(FSCaseReultModel *)model;
@end
