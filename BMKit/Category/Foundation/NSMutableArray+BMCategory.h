//
//  NSMutableArray+BMCategory.h
//  BMBasekit
//
//  Created by DennisDeng on 2017/5/19.
//  Copyright © 2016年 DennisDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (BMCategory)

- (void)bm_moveObjectToTop:(NSUInteger)index;

- (void)bm_moveObjectFromIndex:(NSUInteger)oldIndex toIndex:(NSUInteger)newIndex;

- (nonnull NSMutableArray *)bm_removeFirstObject;

// maxCount 数组最大容量
- (BOOL)bm_addObject:(nonnull id)anObject withMaxCount:(NSUInteger)maxCount;
- (NSUInteger)bm_addObjects:(nullable NSArray *)array withMaxCount:(NSUInteger)maxCount;

- (void)bm_insertArray:(nonnull NSArray *)array atIndex:(NSUInteger)index;
- (NSUInteger)bm_replaceObject:(nonnull id)objectToReplace withObject:(nonnull id)object;

- (void)bm_shuffle;

@end
