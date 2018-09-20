//
//  FSApiErrorLog.h
//  miaoqian
//
//  Created by dengjiang on 15/12/30.
//  Copyright © 2015年 ShiCaiDai. All rights reserved.
//

#ifdef DEBUG
#import <Foundation/Foundation.h>

@interface FSApiErrorLog : NSObject

+ (BOOL)insertAndUpdateErrorLogWithURLRequest:(NSURLRequest *)request error:(NSError *)error;

@end
#endif
