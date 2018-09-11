//
//  FSSearchViewController.h
//  fengshun
//
//  Created by jiang deng on 2018/8/23.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSSuperVC.h"

#define SEARCH_CASEHOTKEY_CACHEFILE [[NSString bm_documentsPath] stringByAppendingPathComponent:@"caseHotkey.plist"]
#define SEARCH_LAWTOPIC_CACHEFILE [[NSString bm_documentsPath] stringByAppendingPathComponent:@"lawtopic.plist"]


typedef void (^searchViewSearchHandler)(NSString * _Nonnull search);

typedef NS_ENUM(NSUInteger, FSSearchResultType)
{
    FSSearchResultType_text = 0,
    FSSearchResultType_case,
    FSSearchResultType_laws
};

@interface FSSearchViewController : FSSuperVC

@property (nonatomic, assign) BOOL showSearchHistory;
@property (nonatomic, assign) BOOL addHotTagSearchHistory;

//@property (nonatomic, strong) NSMutableArray *searchSuggestArray;

@property (nullable, nonatomic, copy) searchViewSearchHandler searchHandler;

- (instancetype)initWithSearchKey:(nonnull NSString *)searchKey resultType:(FSSearchResultType)resultType hotSearchTags:(nullable NSArray *)hotSearchTags searchHandler:(nullable searchViewSearchHandler)searchHandler;

- (void)setSearchBarPplaceholder:(nullable NSString *)searchBarPplaceholder;
- (void)setSearchBarBackgroundColor:(nonnull UIColor *)searchBarBackgroundColor;
- (void)setSearchBarCornerRadius:(CGFloat)searchBarCornerRadius;

@end
