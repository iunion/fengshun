//
//  FSMainToolCell.h
//  fengshun
//
//  Created by Aiwei on 2018/9/5.
//  Copyright © 2018 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSHomePageToolModel.h"

#define MAIN_TOOLCELL_HEIGHT 80.f
#define MAIN_TOOLCELL_WIDTH 70.f
#define MAIN_TOOLCELL_GAP_V 30.0f

@interface FSMainToolCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *m_iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *m_titleLabel;

@property (nonatomic, strong)FSHomePageToolModel *m_tool;

@end
