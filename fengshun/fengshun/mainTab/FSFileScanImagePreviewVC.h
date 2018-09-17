//
//  FSFileScanImagePreviewVC.h
//  fengshun
//
//  Created by Aiwei on 2018/9/14.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSuperVC.h"

@class FSImageFileModel;


@interface FSFileScanImagePreviewVC : FSSuperVC

@property(nonatomic, copy) void(^SourceDataChanged)(void);

@property (nonatomic, weak)NSMutableArray <FSImageFileModel *> *m_localImageFiles;
@property (nonatomic, weak)NSMutableArray <FSImageFileModel *> *m_allImageFiles;
@property (nonatomic, weak)FSImageFileModel *m_selectedImageFile;

@end
