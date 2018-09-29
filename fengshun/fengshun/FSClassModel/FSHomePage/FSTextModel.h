//
//  FSListTextModel.h
//  fengshun
//
//  Created by Aiwei on 2018/9/12.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSuperModel.h"

@interface FSTextModel : FSSuperModel

@property (nonatomic, readonly)NSString *m_title;
@property (nonatomic, readonly)NSString *m_subTitle;
@property (nonatomic, copy)NSString *m_fullTitle;
@property (nonatomic, copy)NSString *m_fileId;
@property (nonatomic, copy)NSString *m_documentId;

@property (nonatomic, copy)NSString *m_previewUrl; // 详情页Url


@end

@interface FSListTextModel : FSTextModel

@property (nonatomic, copy)NSString *m_typeCode; // 与FSTextTypeModel对应

@end

@interface FSTextTypeModel : FSSuperModel

@property (nonatomic, copy)NSString *m_typeCode;
@property (nonatomic, copy)NSString *m_typeName;

// 非网络解析,手动赋值
@property (nonatomic, strong)NSArray <FSListTextModel *>*m_textList;

@end
