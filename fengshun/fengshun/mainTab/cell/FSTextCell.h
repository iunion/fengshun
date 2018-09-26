//
//  FSTextCell.h
//  fengshun
//
//  Created by Aiwei on 2018/9/12.
//  Copyright © 2018 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTextModel.h"

@interface FSTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *m_titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

@property (nonatomic, strong)FSTextModel *m_textModel;

- (void)setTextModel:(FSListTextModel *)textModel colors:(BOOL)colors;

@end
