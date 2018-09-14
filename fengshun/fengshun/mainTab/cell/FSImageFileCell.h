//
//  FSImageFileCell.h
//  fengshun
//
//  Created by Aiwei on 2018/9/14.
//  Copyright © 2018 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSImageFileModel.h"



@interface FSImageFileCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *m_imageView;
@property (weak, nonatomic) IBOutlet UILabel *m_creatTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_selectIndexLabel;
@property (weak, nonatomic) IBOutlet UIImageView *m_selectTag;

+(CGSize)cellSize;

@property (nonatomic, strong)FSImageFileModel *m_imageFile;
@property (nonatomic, assign)BOOL m_editing;

@end
