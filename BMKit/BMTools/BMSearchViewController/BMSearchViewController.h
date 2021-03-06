//
//  BMSearchViewController.h
//  fengshun
//
//  Created by jiang deng on 2018/8/23.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^searchViewSearchHandler)(NSString * _Nonnull search);

@interface BMSearchViewController : UIViewController

@property (nonatomic, assign) BOOL showSearchHistory;
@property (nonatomic, assign) BOOL addHotTagSearchHistory;

//@property (nonatomic, strong) NSMutableArray *searchSuggestArray;

@property (nullable, nonatomic, copy) searchViewSearchHandler searchHandler;

- (nullable instancetype)initWithSearchKey:(nonnull NSString *)searchKey hotSearchTags:(nullable NSArray *)hotSearchTags searchHandler:(nullable searchViewSearchHandler)searchHandler;

- (void)setSearchBarPplaceholder:(nullable NSString *)searchBarPplaceholder;
- (void)setSearchBarBackgroundColor:(nonnull UIColor *)searchBarBackgroundColor;
- (void)setSearchBarCornerRadius:(CGFloat)searchBarCornerRadius;

@end
