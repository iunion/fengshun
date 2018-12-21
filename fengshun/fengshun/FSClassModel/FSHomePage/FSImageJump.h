//
//  FSImageJump.h
//  fengshun
//
//  Created by Aiwei on 2018/9/5.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSSuperModel.h"

@interface FSImageJump : FSSuperModel

@property (nonatomic, copy) NSString *   m_tilte;
@property (nonatomic, assign) NSInteger  m_id;
@property (nonatomic, copy) NSString *   m_imageUrl;
@property (nonatomic, copy) NSString *   m_jumpAddress;
@property (nonatomic, assign) FSJumpType m_jumpType;

@end

