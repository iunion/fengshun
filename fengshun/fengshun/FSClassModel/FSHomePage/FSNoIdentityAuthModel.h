//
//  FSNoIdentityAuthModel.h
//  fengshun
//
//  Created by 龚旭杰 on 2019/4/22.
//  Copyright © 2019年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSNoIdentityAuthModel : NSObject

@property (nonatomic, copy) NSString *m_ImageName;
@property (nonatomic, copy) NSString *m_Title;
@property (nonatomic, copy) NSString *m_Content;
@property (nonatomic, copy) NSArray *m_keyWords;

@end

NS_ASSUME_NONNULL_END
