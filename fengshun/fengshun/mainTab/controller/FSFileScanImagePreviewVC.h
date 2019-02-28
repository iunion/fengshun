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

@property(nonatomic, copy) void(^m_SourceDataChanged)(void);

@property (nonatomic, assign)NSUInteger m_selectedIndex;

@end
