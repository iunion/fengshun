//
//  NSArray+BMCategory.m
//  BMBasekit
//
//  Created by DennisDeng on 13-12-18.
//  Copyright (c) 2013年 DennisDeng. All rights reserved.
//

#import "NSArray+BMCategory.h"
#import "NSObject+BMCategory.h"

@implementation NSArray (BMCategory)

+ (NSString *)bm_arrayToJSON:(NSArray *)array
{
    // NSJSONWritingPrettyPrinted
    return [NSArray bm_arrayToJSON:array options:0];
}

+ (NSString *)bm_arrayToJSON:(NSArray *)array options:(NSJSONWritingOptions)options
{
    return [array bm_toJSONWithOptions:options];
}

- (NSString *)bm_toJSON
{
    // NSJSONWritingPrettyPrinted
    return [self bm_toJSONWithOptions:0];
}

- (NSString *)bm_toJSONWithOptions:(NSJSONWritingOptions)options
{
    NSString *json = nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:options error:&error];
    
    if (!jsonData)
    {
        return @"{}";
    }
    else if (!error)
    {
        json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    else
    {
        BMLog(@"%@", error.localizedDescription);
    }
    
    return nil;
}

- (id)bm_safeObjectAtIndex:(NSUInteger)index
{
    if (self.count > 0 && self.count > index)
    {
        return [self objectAtIndex:index];
    }
    else
    {
        return nil;
    }
}

- (id)bm_randomObject
{
    if (!self.count)
    {
        return nil;
    }
    
    NSUInteger whichItem = (NSUInteger)(arc4random() % self.count);
    
    return self[whichItem];
}

- (NSArray *)bm_firstArrayWithCount:(NSUInteger)count
{
    if (self.count <= count)
    {
        return self;
    }
    
    NSRange range = NSMakeRange(0, count);
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:range];
    
    return [self objectsAtIndexes:indexSet];
}

- (NSArray *)bm_lastArrayWithCount:(NSUInteger)count
{
    if (self.count <= count)
    {
        return self;
    }
    
    NSRange range = NSMakeRange(self.count-count, count);
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:range];
    
    return [self objectsAtIndexes:indexSet];
}

+ (NSUInteger)bm_circleIndex:(NSInteger)index maxSize:(NSUInteger)maxSize
{
    if (index < 0)
    {
        index = index % maxSize;
        index += maxSize;
    }
    if (index >= maxSize)
    {
        index = index % maxSize;
    }
    
    return (NSUInteger)index;
}

- (id)bm_objectAtCircleIndex:(NSUInteger)index
{
    return [self objectAtIndex:[NSArray bm_circleIndex:index maxSize:self.count]];
}

- (NSMutableArray *)bm_divisionWithCount:(NSUInteger)count
{
    if (count == 0)
    {
        return nil;
    }
    
    NSMutableArray *arrayArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    for (NSUInteger index = 0; index < self.count; index++)
    {
        [array addObject:self[index]];
        
        if (((index+1) % count) == 0)
        {
            [arrayArray addObject:array];
            array = [NSMutableArray array];
        }
    }
    
    if (array.count > 0)
    {
        [arrayArray addObject:array];
    }
    
    return arrayArray;
}

- (NSMutableArray *)bm_divisionWithCount:(NSUInteger)count1 andCount:(NSUInteger)count2
{
    if (count1 == 0)
    {
        return nil;
    }
    
    if (count2 == 0)
    {
        return [self bm_divisionWithCount:count1];
    }
    
    NSMutableArray *arrayArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    for (NSUInteger index = 0; index < self.count; index++)
    {
        [array addObject:self[index]];
        
        if (((index+1) % (count1+count2)) == 0)
        {
            NSArray *array1 = [array bm_firstArrayWithCount:count1];
            NSArray *array2 = [array bm_lastArrayWithCount:count2];
            [arrayArray addObject:array1];
            [arrayArray addObject:array2];
            array = [NSMutableArray array];
        }
    }
    
    if (array.count > 0)
    {
        NSArray *array1 = [array bm_firstArrayWithCount:count1];
        
        [arrayArray addObject:array1];
        
        if (array.count > array1.count)
        {
            NSArray *array2 = [array bm_lastArrayWithCount:(array.count - array1.count)];
            
            [arrayArray addObject:array2];
        }
    }
    
    return arrayArray;
}

+ (NSArray *)bm_reversedArray:(NSArray *)array
{
    NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:[array count]];
    NSEnumerator *enumerator = [array reverseObjectEnumerator];
    
    for (id element in enumerator)
    {
        [arrayTemp addObject:element];
    }
    
    return arrayTemp;
}

- (NSArray *)bm_reversedArray
{
    return [NSArray bm_reversedArray:self];
}

- (NSArray *)bm_sortedArray
{
    NSArray *resultArray = [self sortedArrayUsingComparator:
                            ^(id obj1, id obj2){return [obj1 compare:obj2];}];
    return resultArray;
}

- (NSArray *)bm_sortedCaseInsensitiveArray
{
    NSArray *resultArray = [self sortedArrayUsingComparator:
                            ^(id obj1, id obj2){return [obj1 caseInsensitiveCompare:obj2];}];
    return resultArray;
}

- (NSArray *)bm_sortArrayByKey:(NSString *)key ascending:(BOOL)ascending
{
    if (![self bm_isNotEmpty])
    {
        return self;
    }
    
    NSArray *tempArray = [[NSArray alloc] initWithArray:self];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    NSArray *sortedArray = [tempArray sortedArrayUsingDescriptors:@[descriptor]];
    
    return sortedArray;
}

- (NSArray *)bm_uniqueArray
{
    return [NSOrderedSet orderedSetWithArray:self].array.copy;
}

- (NSArray *)bm_unionWithArray:(NSArray *)anArray
{
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    
    [set1 unionOrderedSet:set2];
    
    return set1.array.copy;
}

- (NSArray *)bm_intersectionWithArray:(NSArray *)anArray
{
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    
    [set1 intersectOrderedSet:set2];
    
    return set1.array.copy;
}

- (NSArray *)bm_differenceToArray:(NSArray *)anArray
{
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    
    [set1 minusOrderedSet:set2];
    
    return set1.array.copy;
}

- (NSArray *)bm_filterArray:(BOOL(^)(id obj, NSUInteger index))filterBlock
{
    NSMutableArray *filteredArray = [NSMutableArray arrayWithCapacity:[self count]];
    NSUInteger i = 0;
    for (id obj in self)
    {
        if (filterBlock(obj, i))
        {
            [filteredArray addObject:obj];
        }
        i++;
    }
    
    return [NSArray arrayWithArray:filteredArray];
}

@end


#pragma mark -
#pragma mark Function

@implementation NSArray (BMFunction)

- (void)bm_makeObjectsPerformBlock:(void (^)(id))block
{
    if (!block)
    {
        return;
    }
    
    for (id object in self)
    {
        block(object);
    }
}

- (BOOL)bm_containsObjectOfClass:(Class)cls
{
    for (id obj in self)
    {
        if ([obj isKindOfClass:cls])
        {
            return YES;
        }
    }
    return NO;
}

- (NSInteger)bm_countObjectsOfClass:(Class)cls
{
    NSInteger count = 0;
    for (id obj in self)
    {
        if ([obj isKindOfClass:cls])
        {
            count++;
        }
    }
    return count;
}

- (NSArray *)bm_objectsOfClass:(Class)cls
{
    NSMutableArray *objects = [NSMutableArray array];
    for (id obj in self)
    {
        if ([obj isKindOfClass:cls])
        {
            [objects addObject:obj];
        }
    }
    return objects;
}

@end

