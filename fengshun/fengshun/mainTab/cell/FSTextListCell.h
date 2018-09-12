//
//  FSTextListCell.h
//  fengshun
//
//  Created by Aiwei on 2018/9/12.
//  Copyright © 2018 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSListTextModel.h"

@interface FSTextListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *m_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_subTitleLabel;

@property (nonatomic, strong)FSListTextModel *m_textModel;

- (void)setTextModel:(FSListTextModel *)textModel colors:(BOOL)colors;
@end
