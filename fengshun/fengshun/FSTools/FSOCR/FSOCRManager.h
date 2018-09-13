//
//  FSOCRManager.h
//  fengshun
//
//  Created by Aiwei on 2018/9/13.
//  Copyright © 2018 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSOCRManager : NSObject

+(instancetype)manager;

- (void)ocr_getTextWithImage:(id )image succeed:(void(^)(NSString *text))succeed failed:(void(^)(NSError *error))failed;
@end
