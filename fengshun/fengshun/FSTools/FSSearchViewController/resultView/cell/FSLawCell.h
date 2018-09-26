//
//  FSLawCell.h
//  fengshun
//
//  Created by Aiwei on 2018/9/10.
//  Copyright © 2018 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSSearchResultModel.h"

@interface FSLawCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *m_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_matchLabel;
@property (weak, nonatomic) IBOutlet UIImageView *m_matchTag;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

@property(nonatomic, strong)FSLawModel *m_lawModel;
- (void)setLawResultModel:(FSLawResultModel *)model attributed:(BOOL)attributed;
@end
