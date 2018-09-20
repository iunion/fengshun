//
//  FSListTextModel.h
//  fengshun
//
//  Created by Aiwei on 2018/9/12.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSuperModel.h"

@interface FSTextModel : FSSuperModel

@property (nonatomic, copy)NSString *m_title;
@property (nonatomic, copy)NSString *m_fileId;

@property (nonatomic, copy)NSString *m_previewUrl; // 详情页Url


@end

@interface FSCollectionTextModel : FSTextModel

@property (nonatomic, copy)NSString *m_collectionId;
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
