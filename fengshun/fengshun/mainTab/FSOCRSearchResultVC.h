//
//  FSOCRSearchResultVC.h
//  fengshun
//
//  Created by Aiwei on 2018/9/17.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSTableViewVC.h"

typedef NS_ENUM(NSUInteger, FSOCRSearchType)
{
    FSOCRSearchType_case,
    FSOCRSearchType_laws,
    
};

@interface FSOCRSearchResultVC : FSTableViewVC

@property (nonatomic, assign)FSOCRSearchType m_ocrSearchType;

@end
