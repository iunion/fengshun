//
//  NSObject+BMCategory.h
//  BMBasekit
//
//  Created by DennisDeng on 12-8-7.
//  Copyright (c) 2012年 DennisDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BMCategory)

/**
 * Additional performSelector signatures that support up to 7 arguments.
 */
- (nullable id)bm_performSelector:(nonnull SEL)selector
                       withObject:(nullable id)p1
                       withObject:(nullable id)p2
                       withObject:(nullable id)p3;
- (nullable id)bm_performSelector:(nonnull SEL)selector
                       withObject:(nullable id)p1
                       withObject:(nullable id)p2
                       withObject:(nullable id)p3
                       withObject:(nullable id)p4;
- (nullable id)bm_performSelector:(nonnull SEL)selector
                       withObject:(nullable id)p1
                       withObject:(nullable id)p2
                       withObject:(nullable id)p3
                       withObject:(nullable id)p4
                       withObject:(nullable id)p5;
- (nullable id)bm_performSelector:(nonnull SEL)selector
                       withObject:(nullable id)p1
                       withObject:(nullable id)p2
                       withObject:(nullable id)p3
                       withObject:(nullable id)p4
                       withObject:(nullable id)p5
                       withObject:(nullable id)p6;
- (nullable id)bm_performSelector:(nonnull SEL)selector
                       withObject:(nullable id)p1
                       withObject:(nullable id)p2
                       withObject:(nullable id)p3
                       withObject:(nullable id)p4
                       withObject:(nullable id)p5
                       withObject:(nullable id)p6
                       withObject:(nullable id)p7;

- (void)bm_performSelectorCoalesced:(nonnull SEL)selector
                         withObject:(nullable id)obj
                         afterDelay:(NSTimeInterval)delay;

- (BOOL)bm_isValided;
- (BOOL)bm_isNotNSNull;
- (BOOL)bm_isNotEmpty;
- (BOOL)bm_isNotEmptyExceptNSNull;
- (BOOL)bm_isNotEmptyDictionary;

+ (nonnull NSString *)bm_className;
- (nonnull NSString *)bm_className;

@end

@interface NSObject (BMSwizzle)

+ (BOOL)bm_swizzleMethod:(nonnull SEL)originalSEL withMethod:(nonnull SEL)swizzledSEL error:(NSError * _Nullable * _Nullable)error;
+ (BOOL)bm_swizzleClassMethod:(nonnull SEL)originalSEL withClassMethod:(nonnull SEL)swizzledSEL error:(NSError * _Nullable * _Nullable)error;

@end


@interface NSObject (BMBoolean)

- (BOOL)bm_isNotProxy;

- (BOOL)bm_isNotKindOfClass:(nonnull Class)aClass;
- (BOOL)bm_isNotMemberOfClass:(nonnull Class)aClass;
- (BOOL)bm_notConformsToProtocol:(nonnull Protocol *)aProtocol;

- (BOOL)bm_notRespondsToSelector:(nonnull SEL)aSelector;

@end
