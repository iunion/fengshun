//
//  FSCaseSearchResultModel.h
//  fengshun
//
//  Created by Aiwei on 2018/9/7.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSuperModel.h"
#import "FSCaseModel.h"
#import "FSLawModel.h"

@class FSSearchFilterSegment, FSSearchFilter;


@interface FSSearchResultModel : FSSuperModel

@property (nonatomic, assign) BOOL      m_isMore;
@property (nonatomic, assign) NSInteger m_totalCount;

// 用于跳转到详情页
@property (nonatomic, copy) NSString *m_keywordsStr;

@property (nonatomic, strong) NSArray<FSSearchFilterSegment *> *m_filterSegments;
@property (nonatomic, strong) NSArray *m_resultDataArray;

+ (void)setTextLabel:(UILabel *)label withText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor attributed:(BOOL)attributed;
@end

// 案例检索
@interface FSCaseSearchResultModel : FSSearchResultModel

@end


// 法规检索
@interface FSLawSearchResultModel : FSSearchResultModel


@end

@interface FSSearchFilterSegment : FSSuperModel

@property (nonatomic, copy) NSString *                   m_title;
@property (nonatomic, copy) NSString *                   m_type;
@property (nonatomic, strong) NSArray<FSSearchFilter *> *m_filters;

@end

@interface FSSearchFilter : FSSuperModel

@property (nonatomic, copy) NSString *  m_name;
@property (nonatomic, copy) NSString *  m_value;
@property (nonatomic, assign) NSInteger m_docCount;

@end
