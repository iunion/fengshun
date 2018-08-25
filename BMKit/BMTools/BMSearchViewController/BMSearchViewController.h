//
//  BMSearchViewController.h
//  fengshun
//
//  Created by jiang deng on 2018/8/23.
//  Copyright © 2018年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^searchViewSearchHandler)(NSString *search);

@interface BMSearchViewController : UIViewController

@property (nonatomic, assign) BOOL showSearchHistory;

//@property (nonatomic, strong) NSMutableArray *searchSuggestArray;

@property (nonatomic, copy) searchViewSearchHandler searchHandler;

- (instancetype)initWithSearchKey:(NSString *)searchKey hotSearchTags:(NSArray *)hotSearchTags searchHandler:(searchViewSearchHandler)searchHandler;

- (void)setSearchBarPplaceholder:(NSString *)searchBarPplaceholder;
- (void)setSearchBarBackgroundColor:(UIColor *)searchBarBackgroundColor;
- (void)setSearchBarCornerRadius:(CGFloat)searchBarCornerRadius;

@end
