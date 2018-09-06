//
//  FSCourseModel.h
//  fengshun
//
//  Created by Aiwei on 2018/9/5.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSuperModel.h"

@interface FSCourseModel : FSSuperModel

@property (nonatomic, assign) NSInteger m_id;
@property (nonatomic, copy) NSString *  m_tilte;
@property (nonatomic, copy) NSString *  m_sourceInfo;

// 封面缩略图url
@property (nonatomic, copy) NSString *  m_coverThumbUrl;
@property (nonatomic, assign) NSInteger m_readCount;
@property (nonatomic, copy) NSString *  m_jumpAddress;

// 是否属于某个系列
@property (nonatomic, assign) BOOL bm_isSeries;


@end

@interface FSCourseRecommendModel : FSCourseModel


@end
