//
//  BMTableViewManagerDefine.h
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2017/4/20.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#ifndef BMTableViewManagerDefine_h
#define BMTableViewManagerDefine_h

#import "NSArray+BMCategory.h"
#import "NSAttributedString+BMCategory.h"
#import "NSDate+BMCategory.h"
#import "NSObject+BMCategory.h"
#import "NSString+BMCategory.h"
#import "NSString+BMFormat.h"
#import "NSString+BMRegEx.h"
#import "NSNumber+BMCategory.h"

#import "UIColor+BMCategory.h"
#import "UIFont+BMCategory.h"
#import "UITextField+BMCategory.h"
#import "UIView+BMSize.h"
#import "UIView+BMPositioning.h"


typedef NS_OPTIONS(NSUInteger, BMTableViewCell_PositionType)
{
    BMTableViewCell_PositionType_None = 0,
    BMTableViewCell_PositionType_First = 1 << 0,
    BMTableViewCell_PositionType_Middle = 1 << 1,
    BMTableViewCell_PositionType_Last = 1 << 2,
    BMTableViewCell_PositionType_ALL = BMTableViewCell_PositionType_First | BMTableViewCell_PositionType_Last,
    BMTableViewCell_PositionType_Single = BMTableViewCell_PositionType_ALL
};

typedef NS_ENUM(NSUInteger, BMTableViewCell_UnderLineDrawType)
{
    BMTableViewCell_UnderLineDrawType_None,
    BMTableViewCell_UnderLineDrawType_SeparatorAllLeftInset,
    BMTableViewCell_UnderLineDrawType_SeparatorLeftInset,
    BMTableViewCell_UnderLineDrawType_SeparatorInset,
    BMTableViewCell_UnderLineDrawType_Image,
    BMTableViewCell_UnderLineDrawType_ImageInset,
    BMTableViewCell_UnderLineDrawType_Full
};

typedef NS_ENUM(NSUInteger, BMTableViewCell_SubtitleStyleImageAlignment)
{
    // 上
    BMTableViewCell_SubtitleStyleImageAlignmentTop = 0,
    // Default 中
    BMTableViewCell_SubtitleStyleImageAlignmentCenter,
    // 下
    BMTableViewCell_SubtitleStyleImageAlignmentBottom
};

NS_ASSUME_NONNULL_BEGIN

typedef void (^tableViewImageLoadedHandler)(id item);

typedef void (^tableViewSelectionHandler)(id item);
typedef void (^tableViewAccessoryButtonTapHandler)(id item);
typedef void (^tableViewInsertionHandler)(id item);
typedef void (^tableViewDeletionHandler)(id item);
typedef void (^tableViewDeletionHandlerWithCompletion)(id item, void (^)(void));
typedef BOOL (^tableViewMoveHandler)(id item, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);
typedef void (^tableViewMoveCompletionHandler)(id item, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);

typedef void (^tableViewCutHandler)(id item);
typedef void (^tableViewCopyHandler)(id item);
typedef void (^tableViewPasteHandler)(id item);

// Action bar
typedef void (^tableViewActionBarNavButtonTapHandler)(id item); //handler for nav button on ActionBar
typedef void (^tableViewActionBarDoneButtonTapHandler)(id item); //handler for done button on ActionBar


@protocol RETextCellProtocol <NSObject>

- (void)textFieldDidChanged:(UITextField *)textField;

@end

NS_ASSUME_NONNULL_END


#endif /* BMTableViewManagerDefine_h */
