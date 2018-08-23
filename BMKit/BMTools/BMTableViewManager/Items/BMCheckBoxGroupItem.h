//
//  BMCheckBoxGroupItem.h
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2018/2/8.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "BMTableViewItem.h"
#import "BMCheckBoxGroup.h"
#import "BMCheckBoxLabel.h"

NS_ASSUME_NONNULL_BEGIN

#define BMCheckBoxGroupCell_MaxItemCount    (6)
#define BMCheckBoxGroupCell_TitleTop        (12.0f)
#define BMCheckBoxGroupCell_TitleLeft       (16.0f)
#define BMCheckBoxGroupCell_ItemTopGap      (10.0f)
#define BMCheckBoxGroupCell_ItemHGap        (12.0f)
#define BMCheckBoxGroupCell_ItemVGap        (8.0f)

@class BMCheckBoxGroupItem;
typedef void (^checkBoxValueChangeHandler)(BMCheckBoxGroupItem *item);

@interface BMCheckBoxGroupImage : NSObject

// 图片
@property (nullable, nonatomic, strong) UIImage *image;
@property (nullable, nonatomic, strong) UIImage *bigImage;

// 图片URL
@property (nullable, nonatomic, strong) NSString *imageUrl;
@property (nullable, nonatomic, strong) NSString *bigImageUrl;

// 图片size
@property (nonatomic, assign) CGSize imageSize;

@end

@interface BMCheckBoxGroupItem : BMTableViewItem

// 每行个数 default: 1
@property (nonatomic, assign) NSUInteger oneLineItemCount;

@property (nullable, nonatomic, strong, readonly) BMCheckBoxGroup *checkBoxGroup;

// 多选个数 default: 1
@property (nonatomic, assign) NSUInteger maxSelectedCount;
// 选中index数组 NSNumber
@property (nullable, nonatomic, strong, readonly) NSArray<NSNumber *> *selectedIndexArray;

@property (nullable, nonatomic, strong) NSMutableArray<NSNumber *> *boxStateArray;

// checkbox 类型
@property (nonatomic, assign) BMCheckBoxType boxType;

// checkbox 水平位置
@property (nonatomic, assign) BMCheckBoxHorizontallyType horizontallyType;
// checkbox 垂直位置
@property (nonatomic, assign) BMCheckBoxVerticallyType verticallyType;

// checkbox 宽度
@property (nonatomic, assign) CGFloat checkWidth;

// 选框文本 NSString 
@property (nullable, nonatomic, strong) NSMutableArray<NSString *> *boxTextArray;
@property (nullable, nonatomic, strong) UIFont *boxTextFont;
@property (nullable, nonatomic, strong) UIColor *boxCheckedTextColor;
@property (nullable, nonatomic, strong) UIColor *boxUnCheckedTextColor;

@property (nonatomic, assign) CGFloat boxStrokeWidth;

@property (nullable, nonatomic, strong) UIColor *boxCheckedStrokeColor;
@property (nullable, nonatomic, strong) UIColor *boxUnCheckedStrokeColor;
@property (nullable, nonatomic, strong) UIColor *boxMixedStrokeColor;

@property (nonatomic, assign) BOOL isBoxFill;

@property (nullable, nonatomic, strong) UIColor *boxCheckedFillColor;
@property (nullable, nonatomic, strong) UIColor *boxUnCheckedFillColor;
@property (nullable, nonatomic, strong) UIColor *boxMixedFillColor;

@property (nonatomic, assign) CGFloat boxCornerRadius;

@property (nullable, nonatomic, copy) BMCheckBoxShapeBlock boxShapeBlock;

@property (nonatomic, assign) CGFloat markStrokeWidth;

@property (nullable, nonatomic, strong) UIColor *markCheckedStrokeColor;
@property (nullable, nonatomic, strong) UIColor *markMixedStrokeColor;

@property (nullable, nonatomic, copy) BMCheckBoxShapeBlock markShapeBlock;

// 文本和选择框的间隔
@property (nonatomic, assign) CGFloat checkBoxGap;

// 选项内容，文本NSString 图片BMCheckBoxGroupItem
@property (nullable, nonatomic, strong) NSMutableArray *labelContentArray;

// 文本
//@property (nullable, nonatomic, strong) NSMutableArray *labelTextArray;

@property (nonatomic, assign) NSTextAlignment labelTextAlignment;

@property (nullable, nonatomic, strong) UIFont *labelTextFont;

@property (nullable, nonatomic, strong) UIColor *labelTextCheckedColor;
@property (nullable, nonatomic, strong) UIColor *labelTextUnCheckedColor;
@property (nullable, nonatomic, strong) UIColor *labelTextMixedColor;

// 图片
//@property (nullable, nonatomic, strong) NSMutableArray *labelImageArray;
// 图片URL
//@property (nullable, nonatomic, strong) NSMutableArray *labelImageUrlArray;
// 图片size
//@property (nullable, nonatomic, strong) NSMutableArray *labelImageSizeArray;

@property (nullable, nonatomic, strong) UIImage *placeholderLabelImage;

@property (nullable, nonatomic, copy) checkBoxLabelImageLongPress imageLongPress;


// UI
@property (nonatomic, assign, readonly) CGFloat titleWidth;
@property (nonatomic, assign, readonly) CGFloat titleHeight;

@property (nonatomic, assign, readonly) CGFloat itemWidth;
@property (nullable, nonatomic, strong, readonly) NSMutableArray<NSMutableDictionary *> *itemFrameArray;

@property (nullable, nonatomic, copy) checkBoxValueChangeHandler valueChangeHandler;


+ (instancetype)itemWithTitle:(nullable NSString *)title oneLineItemCount:(NSUInteger)oneLineItemCount maxSelectedCount:(NSUInteger)maxSelectedCount boxTextArray:(nullable NSMutableArray<NSString *> *)boxTextArray labelContentArray:(NSMutableArray *)labelContentArray;
+ (instancetype)itemWithTitle:(nullable NSString *)title oneLineItemCount:(NSUInteger)oneLineItemCount maxSelectedCount:(NSUInteger)maxSelectedCount boxTextArray:(nullable NSMutableArray<NSString *> *)boxTextArray labelContentArray:(NSMutableArray *)labelContentArray checkBoxValueChangeHandler:(nullable checkBoxValueChangeHandler)valueChangeHandler;
- (instancetype)initWithTitle:(nullable NSString *)title oneLineItemCount:(NSUInteger)oneLineItemCount maxSelectedCount:(NSUInteger)maxSelectedCount boxTextArray:(nullable NSMutableArray<NSString *> *)boxTextArray labelContentArray:(NSMutableArray *)labelContentArray;
- (instancetype)initWithTitle:(nullable NSString *)title oneLineItemCount:(NSUInteger)oneLineItemCount maxSelectedCount:(NSUInteger)maxSelectedCount boxTextArray:(nullable NSMutableArray<NSString *> *)boxTextArray labelContentArray:(NSMutableArray *)labelContentArray checkBoxValueChangeHandler:(nullable checkBoxValueChangeHandler)valueChangeHandler;

- (void)caleCellHeightWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
