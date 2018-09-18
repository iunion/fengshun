//
//  FSTopicDetailVC.h
//  fengshun
//
//  Created by best2wa on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSWebViewController.h"

@interface FSTopicDetailVC : FSWebViewController

- (instancetype)initWithTitle:(NSString *)title url:(NSString *)url showLoadingBar:(BOOL)showLoadingBar loadingBarColor:(nullable UIColor *)color delegate:(nullable id<FSWebViewControllerDelegate>)delegate topicId:(NSInteger )topicId;

@end
