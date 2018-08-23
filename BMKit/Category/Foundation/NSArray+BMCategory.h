//
//  NSArray+BMCategory.h
//  BMBasekit
//
//  Created by DennisDeng on 13-12-18.
//  Copyright (c) 2013年 DennisDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (BMCategory)

/**
 *  Convert the given array to JSON as NSString
 *
 *  @param array The array to be reversed
 *
 *  @return Return the JSON as NSString or nil if error while parsing
 */
+ (nullable NSString *)bm_arrayToJSON:(nullable NSArray *)array;
+ (nullable NSString *)bm_arrayToJSON:(nullable NSArray *)array options:(NSJSONWritingOptions)options;

- (nullable NSString *)bm_toJSON;
- (nullable NSString *)bm_toJSONWithOptions:(NSJSONWritingOptions)options;

/**
 *  Get the object at a given index in safe mode (nil if self is empty or out of range)
 *
 *  @param index The index
 *
 *  @return Return the object at a given index in safe mode (nil if self is empty or out of range)
 */
- (nullable id)bm_safeObjectAtIndex:(NSUInteger)index;

// 随机获取一个元素
- (nullable id)bm_randomObject;

/**
 *  Create a new array with count form begin to end
 *
 *  @param count the count of new array
 *
 *  @return a new array
 */
- (nonnull NSArray *)bm_firstArrayWithCount:(NSUInteger)count;

/**
 *  Create a new array with count form end to begin
 *
 *  @param count the count of new array
 *
 *  @return a new array
 */
- (nonnull NSArray *)bm_lastArrayWithCount:(NSUInteger)count;

/**
 *  Simulates the array as a circle. When it is out of range, begins again
 *
 *  @param index The index
 *
 *  @return Return the object at a given index
 */
+ (NSUInteger)bm_circleIndex:(NSInteger)index maxSize:(NSUInteger)maxSize;
- (nonnull id)bm_objectAtCircleIndex:(NSUInteger)index;

/**
 *  将array分割成几个为count个元素的子array并创建新的MutableArray
 *
 *  @param count 子array的元素数
 *
 *  @return MutableArray
 */
- (nullable NSMutableArray *)bm_divisionWithCount:(NSUInteger)count;
- (nullable NSMutableArray *)bm_divisionWithCount:(NSUInteger)count1 andCount:(NSUInteger)count2;

/**
 *  Create a reversed array from the given array
 *
 *  @param array The array to be converted
 *
 *  @return Return the reversed array
 */
+ (nonnull NSArray *)bm_reversedArray:(nullable NSArray *)array;

/**
 *  Create a reversed array from self
 *
 *  @return Return the reversed array
 */
- (nonnull NSArray *)bm_reversedArray;

- (nullable NSArray *)bm_sortedArray;
- (nullable NSArray *)bm_sortedCaseInsensitiveArray;

- (nullable NSArray *)bm_sortArrayByKey:(nonnull NSString *)key ascending:(BOOL)ascending;

// 简单去重
- (nonnull NSArray *)bm_uniqueArray;
// 简单合并
- (nonnull NSArray *)bm_unionWithArray:(nullable NSArray *)anArray;
// 简单交叉，找相同
- (nonnull NSArray *)bm_intersectionWithArray:(nullable NSArray *)anArray;
// 简单排除
- (nonnull NSArray *)bm_differenceToArray:(nullable NSArray *)anArray;

/*!
 Filter array.
 @param filterBlock Filter block
 */
- (nonnull NSArray *)bm_filterArray:(nullable BOOL(^)(id _Nonnull obj, NSUInteger index))filterBlock;

@end


@interface NSArray (BMFunction)

- (void)bm_makeObjectsPerformBlock:(void (^_Nullable)(id _Nonnull object))block;
- (BOOL)bm_containsObjectOfClass:(Class _Nonnull )cls;
- (NSInteger)bm_countObjectsOfClass:(Class _Nonnull )cls;
- (NSArray *_Nonnull)bm_objectsOfClass:(Class _Nonnull )cls;

@end

