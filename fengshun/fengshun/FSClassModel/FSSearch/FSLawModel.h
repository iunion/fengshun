//
//  FSLawModel.h
//  fengshun
//
//  Created by Aiwei on 2018/9/20.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSuperModel.h"

@interface FSLawModel : FSSuperModel

@property (nonatomic, copy) NSString *m_lawsId;
@property (nonatomic, copy) NSString *m_title;

@end

// 法规搜索结果
@interface FSLawResultModel : FSLawModel



@property (nonatomic, copy) NSString *m_lawsNo;

@property (nonatomic, copy) NSString *m_simpleContent;

@property (nonatomic, copy) NSString *m_Organ;

@property (nonatomic, copy) NSString *m_publishDate;
@property (nonatomic, copy) NSString *m_executeDate;
// 生效标识
@property (nonatomic, copy) NSString *m_executeTag;

// 命中数
@property (nonatomic, assign) NSInteger m_matchCount;


@end
