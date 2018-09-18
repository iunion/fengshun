//
//  FSLawSearchResultCell.h
//  fengshun
//
//  Created by Aiwei on 2018/9/10.
//  Copyright © 2018 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSLawSearchResultModel.h"

@interface FSLawSearchResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *m_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_matchLabel;


@property(nonatomic, strong)FSLawResultModel *m_lawResultModel;

@end
